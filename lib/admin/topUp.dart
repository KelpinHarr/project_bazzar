import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _errorText = '';
  }

  @override
  Widget build(BuildContext context) {
    String barcodeString = widget.scanResult.code ?? '{}';
    Map<String, dynamic> user = jsonDecode(barcodeString);

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
                        fontSize: 18.0,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      user['nama'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 18.0,
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
                        fontSize: 18.0,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Text(
                        formatCurrency(user['saldo'] ?? 0),
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                      ),
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
                    if (amount <= 0) {
                      return 'Nominal top up harus lebih dari 0';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _errorText = '';
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  _errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
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
                        if (amount <= 0) {
                          setState(() {
                            _errorText = 'Nominal top up harus lebih dari 0';
                          });
                          return;
                        }
                        // Lakukan operasi top up disini
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
                            fontSize: 16,
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
