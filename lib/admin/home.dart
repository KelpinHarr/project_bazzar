import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/Topup.dart';
import 'package:project_bazzar/admin/navbar.dart';
import 'package:project_bazzar/currencyUtils.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin>{
  late Future<int> _balance;
  Future<List<Topup>>? _futureTopup;

  void initState() {
    super.initState();
    _balance = _getUserBalance();
    _futureTopup = _getTopup();
  }

  Future<List<Topup>> _getTopup() async {
    List<Topup> topups = [];
    try {
      final firestore = FirebaseFirestore.instance;
      final itemTopup = await firestore.collection('topup').orderBy("date", descending: true).get();
      if (itemTopup.docs.isNotEmpty) {
        for (var doc in itemTopup.docs) {
          final data = doc.data();
          final topup = Topup(
            id: doc.id,
            buyer: data['user_name'],
            totalAmount: data['totalAmount'],
            date: (data['date'] as Timestamp).toDate(),
          );
          topups.add(topup);
        }
      }
    } 
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error : $e")));
    }
    return topups;
  }

  Future<int> _getUserBalance() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final itemUser = await firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();
      if (itemUser.docs.isNotEmpty) {
        final user = itemUser.docs.first;
        final balance = user['balance'];
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
        title: const Text(
          "Welcome, Admin!",
          style: TextStyle(
            color: Color(0xffAAD4FF),
          ),
        ),
        backgroundColor: const Color(0xff0A2B4E),
        iconTheme: const IconThemeData(color: Color(0xffAAD4FF)),
      ),
      endDrawer: const NavBarAdmin(),
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
                  )
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
                'Daftar Transaksi Top Up',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff0A2B4E),
                ),
              ),
            ),
            Column(
              children: [
                FutureBuilder<List<Topup>>(
                  future: _futureTopup,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No top-up transactions found'));
                    }
                    final topups = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topups.length,
                      itemBuilder: (context, index) {
                        final topup = topups[index];
                        return Card(
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
                                      topup.buyer,
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
                                        formatCurrency(topup.totalAmount),
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xff0A2B4E),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${topup.date.day} ${_getMonthName(topup.date.month)} ${topup.date.year}, ${_getTimeString(topup.date.hour, topup.date.minute, topup.date.second)}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xff0A2B4E),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
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