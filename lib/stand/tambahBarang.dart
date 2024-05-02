import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

class TambahBarang extends StatefulWidget {
  @override
  _TambahBarangState createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> {
  final _namaBarangController = TextEditingController();
  final _hargaController = TextEditingController();
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Navbarv2(
      key: GlobalKey(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _namaBarangController,
                decoration: InputDecoration(
                  labelText: "Nama Barang",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga",
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Qty: $_qty"),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_qty > 1) {
                              _qty--;
                            }
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _qty++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Simpan data ke database atau lakukan proses lainnya
                  Navigator.pop(context);
                },
                child: Text("Tambah"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
