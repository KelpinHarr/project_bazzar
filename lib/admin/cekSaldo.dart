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
  @override
  Widget build(BuildContext context) {
    String barcodeString = widget.scanResult.code ?? '{}';
    Map<String, dynamic> user = jsonDecode(barcodeString);
    String name = user['nama'] ?? 'Unknown';
    String balance = user['saldo'] != null ? formatCurrency(user['saldo']) : 'Rp0';

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
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18.0,
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
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        balance,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeAdmin()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffAAD4FF),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(
                      color: Color(0xff0A2B4E),
                      fontSize: 16,
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

