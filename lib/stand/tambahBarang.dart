import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/navbarv2.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class TambahBarang extends StatefulWidget {
  final String name;
  const TambahBarang({super.key, required this.name});

  @override
  _TambahBarangState createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang>
    with SingleTickerProviderStateMixin {
  final _namaBarangController = TextEditingController();
  final _hargaController = TextEditingController();
  bool _showQtyInput = false;
  int _qty = 0;

  @override
  Widget build(BuildContext context) {
    return NavbarStandv2(
      name: widget.name,
      key: GlobalKey(),
      body: Scaffold(
        backgroundColor: const Color(0xffF0F0E8),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _namaBarangController,
                  cursorColor: const Color(0xff0A2B4E),
                  decoration: const InputDecoration(
                    labelText: "Nama Barang",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0A2B4E)),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xff0A2B4E),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama barang tidak boleh kosong';
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _hargaController,
                  cursorColor: const Color(0xff0A2B4E),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Harga Barang",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0A2B4E)),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xff0A2B4E),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga barang tidak boleh kosong';
                    }
                    try {
                      int.parse(value);
                      return null; // Valid number
                    } catch (e) {
                      return 'Harga barang harus berupa angka';
                    }
                  },
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _qty > 0
                        ? Text("Qty: $_qty",
                            style: const TextStyle(
                                color: Color(0xff0A2B4E), fontSize: 16.0))
                        :
                        // Button add qty
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _showQtyInput = true;
                                _qty = 1;
                              });
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  const Color(
                                      0xff0A2B4E)), // Mengatur warna teks menjadi hitam
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(
                                    width: 8), // Adjust the width as needed
                                Text("Add Qty"),
                              ],
                            ),
                          ),
                    Visibility(
                      visible: _qty > 0, // Only show when qty is positive
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _qty--;
                              });
                            },
                            icon: const Icon(Icons.remove),
                            color: const Color(0xff0A2B4E),
                          ),
                          // Text("$_qty"),
                          SizedBox(
                            width: 40.0,
                            child: TextField(
                              controller: TextEditingController(text: '$_qty'),
                              cursorColor: const Color(0xff0A2B4E),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                // Update _qty based on user input, handling potential errors
                                try {
                                  int newQty = int.parse(value);
                                  if (newQty >= 0) {
                                    setState(() {
                                      _qty = newQty;
                                    });
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Invalid quantity. Please enter a number.'),
                                    ),
                                  );
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(
                                    0.0),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _qty++;
                              });
                            },
                            icon: const Icon(Icons.add),
                            color: const Color(0xff0A2B4E),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_namaBarangController.text.isEmpty ||
                            _hargaController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Nama / harga tidak boleh kosong!")));
                          return;
                        }

                        try {
                          int harga = int.parse(_hargaController.text);

                          await FirebaseFirestore.instance.collection('items').add({
                            'name' : _namaBarangController.text,
                            'stand_name' : widget.name,
                            'qty' : _qty > 0 ? _qty : null,
                            'price' : harga
                          });

                          _namaBarangController.clear();
                          _hargaController.clear();
                          setState(() {
                            _qty = 0;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Barang berhasil ditambahkan!')),
                          );
                        }
                        catch(e){
                          print(e);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffAAD4FF),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0)),
                      child: const Text(
                        'Tambah barang',
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
      activePage: 'Tambah barang',
    );
  }
}
