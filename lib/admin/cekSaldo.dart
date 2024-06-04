import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/navbarv2.dart';
import 'package:project_bazzar/currencyUtils.dart';
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'home.dart';

class CekSaldo extends StatefulWidget {
  final Barcode scanResult;
  const CekSaldo({Key? key, required this.scanResult}) : super(key: key);

  @override
  _CekSaldoState createState() => _CekSaldoState();
}

class _CekSaldoState extends State<CekSaldo> {
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
    // _balance = user['balance'] != null ? formatCurrency(user['balance']) : 'Rp0';
    _balance = _getUserBalance();
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
        print("Balance : $user");
        return balance ?? 0;
      }
      else {
        return 0;
      }
    } 
    catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // String barcodeString = widget.scanResult.code ?? '{}';
    // Map<String, dynamic> user = jsonDecode(barcodeString);
    // String name = user['nama'] ?? 'Unknown';
    // String balance = user['saldo'] != null ? formatCurrency(user['saldo']) : 'Rp0';

    return NavbarAdminv2(
      key: GlobalKey(),
      body: Scaffold(
        backgroundColor: const Color(0xffF0F0E8),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Nama: ',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0A2B4E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Saldo: ',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.black54,
                      ),
                    ),
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
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeAdmin()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffAAD4FF),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                      color: Color(0xff0A2B4E),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      activePage: 'Cek saldo',
    );
  }
}
