import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/Transaction.dart';
import 'package:project_bazzar/currencyUtils.dart';
import 'package:project_bazzar/stand/detailTransaksi.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

class RiwayatTransaksi extends StatefulWidget {
  final String name;
  const RiwayatTransaksi({super.key, required this.name});

  @override
  _RiwayatTransaksiState createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi> {
  // Dummy data for riwayat transaksi
  List<Transactions>? riwayatTransaksi;
  Future<List<Transactions>>? _futureTransactions;

  @override
  void initState() {
    super.initState();
    _futureTransactions = _getTransaction();
  }

  Future<List<Transactions>> _getTransaction() async {
    List<Transactions> transactions = [];
    try {
      final firestore = FirebaseFirestore.instance;
      final itemTransaction = await firestore
          .collection('transactions')
          .where('stand', isEqualTo: widget.name)
          .get();
      if (itemTransaction.docs.isNotEmpty) {
        for (var trans in itemTransaction.docs) {
          final id = trans.id;
          final date = (trans['date'] as Timestamp).toDate();
          final name = trans['name'];
          String status = trans['status'] == 1 ? 'Completed' : 'Pending';
          final items = trans['items'] as List;
          List<TransactionItem> transactionItems = [];

          for (final item in items) {
            transactionItems.add(TransactionItem(
              name: item['name'],
              price: item['price'],
              quantity: item['qty'],
            ));
          }

          final totalAmount = trans['totalAmount'];
          final totalQty = trans['totalQty'];

          transactions.add(Transactions(
            id: id,
            name: widget.name,
            date: date,
            stand: widget.name,
            buyerId: name,
            status: status,
            items: transactionItems,
            totalAmount: totalAmount.toDouble(),
            totalQty: totalQty.toDouble(),
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavbarStandv2(
        name: widget.name,
        key: GlobalKey(),
        body: Scaffold(
          backgroundColor: const Color(0xffF0F0E8),
          body: FutureBuilder<List<Transactions>>(
            future: _futureTransactions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No transactions found'));
              }
              final transactions = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: transactions.map((transaction) {
                      return Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.id,
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0xff0A2B4E),
                                        fontWeight: FontWeight.w900),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      formatCurrency(transaction.totalAmount.toInt()),
                                      style: const TextStyle(
                                          fontSize: 16.0, color: Color(0xff0A2B4E)),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${transaction.date.day} ${_getMonthName(transaction.date.month)} ${transaction.date.year}, ${_getTimeString(transaction.date.hour, transaction.date.minute)}',
                                    style: const TextStyle(
                                        fontSize: 14.0, color: Color(0xff0A2B4E)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailTransaksi(
                                                  transaction: transaction,
                                                  name: widget.name,
                                                )),
                                      );
                                    },
                                    child: const Text(
                                      'Lihat detail >',
                                      style: TextStyle(
                                          color: Color(0xff0A2B4E),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          )
        ),
        activePage: 'Riwayat transaksi',
      )
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  String _getTimeString(int hour, int minute) {
    String hourString = hour.toString().padLeft(2, '0');
    String minuteString = minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }
}
