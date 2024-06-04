import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/home.dart';
import 'package:project_bazzar/admin/navbarv2.dart';
import 'package:project_bazzar/currencyUtils.dart';
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class TopUp extends StatefulWidget {
  final Barcode scanResult;
  const TopUp({super.key, required this.scanResult});

  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  final _nominalTopUpController = TextEditingController();
  late String _errorText;
  late String barcodeString;
  late Map<String, dynamic> user;
  late String name;
  late Future<int> _balance;

  @override
  void initState() {
    super.initState();
    _errorText = '';
    barcodeString = widget.scanResult.code ?? '{}';
    user = jsonDecode(barcodeString);
    name = user['nama'] ?? 'Unknown';    
    _balance = _getUserBalance();
  }

  Future<int> _getUserBalance() async {
    try{
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
    catch(e){
      print(e);
      return 0;
    }
  }

  Future<void> topUpSaldo() async {
    try {
      final currentBalance = await _balance;
      final topUpAmount = int.parse(_nominalTopUpController.text);
      final newBalance = currentBalance + topUpAmount;

      final firestore = FirebaseFirestore.instance;
      final userSnapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .where('name', isEqualTo: name)
          .get();

      if (userSnapshot.docs.isNotEmpty){
        final userDoc = userSnapshot.docs.first;
        await firestore.collection('users').doc(userDoc.id).update({
          'balance': newBalance
        });
        setState(() {
          _balance = Future.value(newBalance);
        });
      }

      final topupRef = await firestore.collection('topup').add({
        'user_name' : name,
        'date' : FieldValue.serverTimestamp(),
        'totalAmount' : topUpAmount
      });

      final adminSnapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();
          
      if (adminSnapshot.docs.isNotEmpty){
        final adminDoc = adminSnapshot.docs.first;
        final adminBalance = adminDoc['balance'] + topUpAmount;
        await firestore.collection('users').doc(adminDoc.id).update({
          'balance': adminBalance
        });
      }

      _nominalTopUpController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Top up berhasil!'))
      );
    } 
    catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Top up gagal! Error $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavbarAdminv2(
      key: GlobalKey(),
      body: Scaffold(
        backgroundColor: const Color(0xffF0F0E8),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Nama:',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0A2B4E)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      'Saldo:',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 12.0),
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
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _nominalTopUpController,
                  decoration: const InputDecoration(
                    labelText: "Nominal top up",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0A2B4E)),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xff0A2B4E),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nominal top up tidak boleh kosong';
                    }
                    final double amount = double.tryParse(value) ?? 0;
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  _errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nominalTopUpController.text.isEmpty) {
                          setState(() {
                            _errorText = 'Nominal top up tidak boleh kosong';
                          });
                          return;
                        }
                        final double amount =
                            double.tryParse(_nominalTopUpController.text) ?? 0;
                        // if (amount <= 0) {
                        //   setState(() {
                        //     _errorText = 'Nominal top up harus lebih dari 0';
                        //   });
                        //   return;
                        // }
                        topUpSaldo();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffAAD4FF),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0)),
                      child: const Text(
                        'Top up',
                        style: TextStyle(
                            color: Color(0xff0A2B4E),
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      activePage: 'Top up',
    );
  }
}
