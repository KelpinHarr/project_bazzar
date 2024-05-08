import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/detailTransaksi.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

class RiwayatTransaksi extends StatefulWidget {
  const RiwayatTransaksi({Key? key}) : super(key: key);

  @override
  _RiwayatTransaksiState createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi>{
  final Transaction dummyTransaction = Transaction(
    id: 'PK1249281',
    date: '01/05/2024',
    time: '11:11',
    stand: 'Felicia',
    buyerId: 'Kenny',
    status: 'Completed',
    items: [
      TransactionItem(name: 'Product A', quantity: 2, price: 25000),
      TransactionItem(name: 'Product B', quantity: 1, price: 15000),
      TransactionItem(name: 'Product C', quantity: 3, price: 10000),
    ],
    totalAmount: 100000,
    totalQty: 6,
  );

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
              children: [
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Set rounded corners
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text vertically within row
                          children: [
                            // Transaction ID (increased font size)
                            Text(
                              dummyTransaction.id,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Color(0xff0A2B4E),
                                fontWeight: FontWeight.w900
                              ),
                            ),
                            const Spacer(), // Add space between ID and price

                            // Price (increased font size, margin right)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Rp${dummyTransaction.totalAmount}',
                                style: TextStyle(fontSize: 16.0, color: Color(0xff0A2B4E)),
                              ),
                            )

                          ],
                        ),
                        const SizedBox(height: 4.0), // Spacing between rows
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Date and Time
                            Text(
                              '1 Mei 2024, 11:11', // Replace with actual date and time
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xff0A2B4E)
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DetailTransaksi(transaction: dummyTransaction)),
                                );
                              },
                              child: Text(
                                'Lihat detail >',
                                style: TextStyle(
                                    color: Color(0xff0A2B4E),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      activePage: 'Riwayat transaksi',
    );
  }
}

class Transaction {
  final String id;
  final String date;
  final String time;
  final String stand;
  final String buyerId;
  final String status;
  final List<TransactionItem> items;
  final double totalAmount;
  final double totalQty;

  const Transaction({
    required this.id,
    required this.date,
    required this.time,
    required this.stand,
    required this.buyerId,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.totalQty,
  });
}

class TransactionItem {
  final String name;
  final int quantity;
  final double price;

  const TransactionItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
