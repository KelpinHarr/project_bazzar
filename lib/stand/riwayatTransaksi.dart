import 'package:flutter/material.dart';
import 'package:project_bazzar/Transaction.dart';
import 'package:project_bazzar/stand/detailTransaksi.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

class RiwayatTransaksi extends StatefulWidget {
  const RiwayatTransaksi({super.key});

  @override
  _RiwayatTransaksiState createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi>{
  // Dummy data for riwayat transaksi
  final List<Transaction> riwayatTransaksi = [
    Transaction(
      id: 'PK1249281',
      date: DateTime(2024, 4, 24, 10, 11),
      stand: 'Felicia',
      buyerId: 'Kenny',
      status: 'Completed',
      items: const [
        TransactionItem(name: 'Product A', quantity: 2, price: 25000),
        TransactionItem(name: 'Product B', quantity: 1, price: 15000),
        TransactionItem(name: 'Product C', quantity: 3, price: 10000),
      ],
      totalAmount: 100000,
      totalQty: 6,
    ),
    // Add more transactions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return NavbarStandv2(
      key: GlobalKey(),
      body: Scaffold(
        backgroundColor: const Color(0xffF0F0E8),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: riwayatTransaksi.map((transaction) {
                return Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                                  fontWeight: FontWeight.w900
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Rp${transaction.totalAmount}',
                                style: const TextStyle(fontSize: 16.0, color: Color(0xff0A2B4E)),
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
                              style: const TextStyle(fontSize: 14.0, color: Color(0xff0A2B4E)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DetailTransaksi(transaction: transaction)),
                                );
                              },
                              child: const Text(
                                'Lihat detail >',
                                style: TextStyle(color: Color(0xff0A2B4E), fontSize: 16.0, fontWeight: FontWeight.bold),
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
        ),
      ),
      activePage: 'Riwayat transaksi',
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