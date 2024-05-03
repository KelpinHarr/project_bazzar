import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

class TambahBarang extends StatefulWidget {
  @override
  _TambahBarangState createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> {
  final _namaBarangController = TextEditingController();
  final _hargaController = TextEditingController();
  bool _showQtyInput = false; // Flag to control quantity input visibility
  int _qty = 0; // Current quantity

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
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0A2B4E)),
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xff0A2B4E),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga Barang",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0A2B4E)),
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xff0A2B4E),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _qty > 0
                      ? Text(
                        "Qty: $_qty",
                        style: TextStyle(
                          color: Color(0xff0A2B4E),
                          fontSize: 16.0
                        )
                      )
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
                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xff0A2B4E)), // Mengatur warna teks menjadi hitam
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 8), // Adjust the width as needed
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
                          icon: Icon(Icons.remove),
                          color: Color(0xff0A2B4E),
                        ),
                        // Text("$_qty"),
                        SizedBox(
                          width: 40.0,
                          child: TextField(
                            controller: TextEditingController(text: '$_qty'),
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
                                print("Invalid quantity input: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid quantity. Please enter a number.'),
                                  ),
                                );
                              }
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0.0), // Remove padding for a cleaner look
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _qty++;
                            });
                          },
                          icon: Icon(Icons.add),
                          color: Color(0xff0A2B4E),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan fungsi tambah barang di sini
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffAAD4FF),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0)
                    ),
                    child: Text(
                      'Tambah',
                      style: TextStyle(
                        color: Color(0xff0A2B4E),
                        fontSize: 16,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
