import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/Transaction.dart';
import 'package:project_bazzar/currencyUtils.dart';
import 'package:project_bazzar/stand/home.dart';
import 'package:project_bazzar/stand/navbarv2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PageBayar extends StatefulWidget {
  final Barcode scanResult;
  final double? totalHarga;
  final int totalQty;
  final String stand_name;
  final List<Transactions> transactions;

  PageBayar({super.key, required this.scanResult, this.totalHarga, required this.stand_name, required this.transactions, required this.totalQty});

  @override
  State<PageBayar> createState() => _PageBayarState();
}

class _PageBayarState extends State<PageBayar> {
  late String barcodeString;
  late Map<String, dynamic> user;
  late String name;
  late Future<int> _balance;

  @override
  void initState() {
    super.initState();
    barcodeString = widget.scanResult.code ?? '{}';
    user = jsonDecode(barcodeString);
    name = user['nama'] ?? 'Unknown';
    _balance = _getUserBalance();
  }

  Future<void> _addTransaction() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final transactionItems = widget.transactions.expand((transaction) {
        return transaction.items.map((item) {
          return {
            'name': item.name,
            'qty': item.quantity,
            'price': item.price
          };
        });
      }).toList();

      final transactionRef = await firestore.collection('transactions').add({
        'buyerId': user['id'],
        'date': FieldValue.serverTimestamp(),
        'items': transactionItems,
        'name': name,
        'stand': widget.stand_name,
        'status': 1,
        'totalAmount': widget.totalHarga,
        'totalQty': widget.totalQty
      });

      for (var item in transactionItems) {
        await firestore.collection('transaction_items').add({
          'name': item['name'],
          'price': item['price'],
          'quantity': item['qty']
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<int> _getUserBalance() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final itemUser = await firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .where('name', isEqualTo: name)
          .get();
      if (itemUser.docs.isNotEmpty) {
        final user = itemUser.docs.first;
        final balance = user['balance'];
        print("Fetched balance for user $name: $balance");
        return balance ?? 0;
      } else {
        print("User $name not found.");
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<void> _buyItem() async {
    try {
      final balance = await _balance;
      final totalHarga = widget.totalHarga ?? 0;
      if (balance >= totalHarga.toInt()) {
        final newBalance = balance - totalHarga.toInt();
        final firestore = FirebaseFirestore.instance;
        final itemUser = await firestore
            .collection('users')
            .where('role', isEqualTo: 'student')
            .where('name', isEqualTo: name)
            .get();

        final standDocs = await firestore
            .collection('users')
            .where('role', isEqualTo: 'stand')
            .where('name', isEqualTo: widget.stand_name)
            .get();

        if (itemUser.docs.isNotEmpty && standDocs.docs.isNotEmpty) {
          final userDoc = itemUser.docs.first;
          final standDoc = standDocs.docs.first;

          final standBalance = standDoc['balance'] + widget.totalHarga;

          await firestore.collection('users').doc(userDoc.id).update({'balance': newBalance});
          await firestore.collection('users').doc(standDoc.id).update({'balance': standBalance});

          setState(() {
            _balance = Future.value(newBalance);
          });

          await _addTransaction();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pembayaran Berhasil!')));
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeStand(name: widget.stand_name,))
          );
        }
      } else {
        final currentBalance = await _balance;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saldo tidak cukup, saldo anda : $currentBalance')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavbarStandv2(
      key: GlobalKey(),
      name: widget.stand_name,
      body: Scaffold(
        backgroundColor: const Color(0xffF0F0E8),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Stand: ${widget.stand_name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0A2B4E),
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Total: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0A2B4E),
                        ),
                      ),
                      TextSpan(
                        text: '${widget.totalHarga != null ? formatCurrency(widget.totalHarga!.toInt()) : 'N/A'}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: widget.totalHarga != null ? Colors.green : Colors.red, // Menetapkan warna hijau jika totalHarga tidak null
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = widget.transactions[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: transaction.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.name} x${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff36454F),
                                ),
                              ),
                              Text(
                                '${formatCurrency(item.price.toInt())}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff36454F),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _buyItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffAAD4FF),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: const Text(
                        'Bayar',
                        style: TextStyle(
                          color: Color(0xff0A2B4E),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      activePage: "Bayar Transaksi",
    );
  }
}
