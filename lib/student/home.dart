import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saldo',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Rp 1.500.000',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
          Divider(),
          Text(
            'History Transaksi',
            style: TextStyle(fontSize: 16.0),
          ),
          // Expanded(
          //   child: ListView(
          //     children: [
          //       TransactionItem(
          //         merchantName: 'Sushi Saga',
          //         amount: 25000,
          //         date: DateTime(2024, 4, 24, 11, 11),
          //       ),
          //       TransactionItem(
          //         merchantName: 'Uncle Tan',
          //         amount: 125000,
          //         date: DateTime(2024, 6, 25, 14, 11),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}