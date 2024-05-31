import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PageBayar extends StatefulWidget {
  final Barcode scanResult;
  final double? totalHarga;

  PageBayar({super.key, required this.scanResult, this.totalHarga});

  @override
  State<PageBayar> createState() => _PageBayarState();
}

class _PageBayarState extends State<PageBayar> {
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
    return const Placeholder();
  }
}