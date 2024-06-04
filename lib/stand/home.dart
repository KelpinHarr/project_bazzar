import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/Transaction.dart';
import 'package:project_bazzar/currencyUtils.dart';
import 'package:project_bazzar/stand/detailTransaksi.dart';
import 'package:project_bazzar/stand/navbar.dart';

class HomeStand extends StatefulWidget {
  final String name;
  const HomeStand({super.key, required this.name});

  @override
  _HomeStandState createState() => _HomeStandState();
}

class _HomeStandState extends State<HomeStand> {
  late Future<int> _balance;
  List<Transactions>? riwayatTransaksi;
  Future<List<Transactions>>? _futureTransactions;

  void initState() {
    super.initState();
    _balance = _getUserBalance();
    _futureTransactions = _getTransaction();
  }

  Future<int> _getUserBalance() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final itemUser = await firestore
          .collection('users')
          .where('role', isEqualTo: 'stand')
          .where('name', isEqualTo: widget.name)
          .get();
      if (itemUser.docs.isNotEmpty) {
        final user = itemUser.docs.first;
        final balance = user['balance'];
        print("Fetched user: ${user.id}, balance: $balance");
        return (balance is double) ? balance.toInt() : balance;
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<List<Transactions>> _getTransaction() async {
    List<Transactions> transactions = [];
    try {
      final firestore = FirebaseFirestore.instance;
      final itemTransaction = await firestore
          .collection('transactions')
          .where('stand', isEqualTo: widget.name)
          .orderBy('date', descending: true)
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Welcome, ${widget.name}",
          style: TextStyle(
            color: Color(0xffAAD4FF),
          ),
        ),
        backgroundColor: const Color(0xff0A2B4E),
        iconTheme: const IconThemeData(color: Color(0xffAAD4FF)),
      ),
      endDrawer: NavBarStand(
        name: widget.name,
      ),
      backgroundColor: Color(0xffF0F0E8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffAAD4FF), Colors.white],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200, // Shadow color
                    offset: const Offset(0.0, 2.0), // Shadow offset
                    blurRadius: 4.0, // Shadow blur radius
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pendapatan hari ini',
                    style: TextStyle(fontSize: 22.0),
                  ),
                  SizedBox(height: 8.0),
                  FutureBuilder<int>(
                    future: _balance,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        );
                      } else if (!snapshot.hasData || snapshot.data == 0) {
                        return const Text(
                          'Rp0',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        );
                      } else {
                        final balance = snapshot.data!;
                        return Text(
                          formatCurrency(balance),
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
              child: Text(
                'Laporan Penjualan',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff0A2B4E),
                ),
              ),
            ),
            FutureBuilder<List<Transactions>>(
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
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Column(
                      children: [
                        Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${transaction.date.day} ${_getMonthName(transaction.date.month)} ${transaction.date.year}, ${_getTimeString(transaction.date.hour, transaction.date.minute, transaction.date.second)}',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        color: Color(0xff0A2B4E),
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        formatCurrency(transaction.totalAmount.toInt()),
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xff0A2B4E),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      transaction.buyerId,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0xff0A2B4E),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailTransaksi(
                                              transaction: transaction,
                                              name: widget.name,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Lihat detail >',
                                        style: TextStyle(
                                          color: Color(0xff0A2B4E),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    );
                  },
                );
              }
            ),
          ],
        ),
      ),
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

  String _getTimeString(int hour, int minute, int second) {
    String hourString = hour.toString().padLeft(2, '0');
    String minuteString = minute.toString().padLeft(2, '0');
    String secondString = second.toString().padLeft(2, '0');
    return '$hourString:$minuteString:$secondString';
  }
}
