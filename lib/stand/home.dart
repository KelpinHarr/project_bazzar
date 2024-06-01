import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_bazzar/currencyUtils.dart';
import 'package:project_bazzar/stand/navbar.dart';

class HomeStand extends StatefulWidget {
  final String name;
  const HomeStand({super.key, required this.name});

  @override
  _HomeStandState createState() => _HomeStandState();
}

class _HomeStandState extends State<HomeStand>{
  late Future<int> _balance;

  void initState() {
    super.initState();
    _balance = _getUserBalance();
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
      endDrawer: NavBarStand(name: widget.name,),
      backgroundColor: Color(0xffF0F0E8),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pendapatan hari ini',
                    style: TextStyle(fontSize: 18.0),
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
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                              ),
                          );
                      } else {
                          final balance = snapshot.data!;
                          return Text(
                              formatCurrency(balance),
                              style: const TextStyle(
                                  fontSize: 24.0,
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
            const SizedBox(height: 32.0),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 16.0
              ),
              child: Text(
                'Laporan Penjualan',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff0A2B4E),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

          ],
        ),
      ),
    );
  }
}