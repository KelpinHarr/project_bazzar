import 'package:flutter/material.dart';
import 'package:project_bazzar/student/navbar.dart';
import 'package:project_bazzar/Transaction.dart';

class HomeStudent extends StatelessWidget {
  const HomeStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome, Kenny!",
          style: TextStyle(
            color: Color(0xffAAD4FF),
          ),
        ),
        backgroundColor: const Color(0xff0A2B4E),
        iconTheme: const IconThemeData(color: Color(0xffAAD4FF)),
      ),
      endDrawer: const NavBarStudent(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[200]!, Colors.white],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200, // Shadow color
                    offset: const Offset(0.0, 2.0), // Shadow offset
                    blurRadius: 4.0, // Shadow blur radius
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Saldo',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Rp150.000',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 16.0
              ),
              child: Text(
                'History Transaksi',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff0A2B4E),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Transaction(
                    id: 'PK1249281',
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
                    date: DateTime(2024, 4, 24, 11, 11, 23),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Transaction(
                    id: 'PK1249281',
                    stand: 'Uncle Tan',
                    buyerId: 'Kenny',
                    status: 'Completed',
                    items: const [
                      TransactionItem(name: 'Product A', quantity: 2, price: 25000),
                      TransactionItem(name: 'Product B', quantity: 1, price: 15000),
                      TransactionItem(name: 'Product C', quantity: 3, price: 10000),
                    ],
                    totalAmount: 100000,
                    totalQty: 6,
                    date: DateTime(2024, 6, 25, 14, 11, 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
