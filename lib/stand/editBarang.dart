import 'package:flutter/material.dart';
import 'package:project_bazzar/CustomDialog.dart';
import 'package:project_bazzar/stand/daftarBarang.dart';
import 'package:project_bazzar/stand/navbarv2.dart';
class EditBarang extends StatefulWidget {
  const EditBarang({super.key});

  @override
  _EditBarangState createState() => _EditBarangState();
}

class _EditBarangState extends State<EditBarang> {
  final _namaBarangController = TextEditingController();
  final _hargaController = TextEditingController();
  bool _showQtyInput = false;
  int _qty = 0; // Current quantity

  @override
  Widget build(BuildContext context) {
    return NavbarStandv2(
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
                  decoration: const InputDecoration(
                    labelText: "Nama Barang",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0A2B4E)),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xff0A2B4E),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField (
                  controller: _hargaController,
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
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _qty > 0
                        ? Text(
                        "Qty: $_qty",
                        style: const TextStyle(
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
                        foregroundColor: MaterialStateProperty.all<Color>(const Color(0xff0A2B4E)), // Mengatur warna teks menjadi hitam
                      ),
                      child: const Row(
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
                            icon: const Icon(Icons.remove),
                            color: const Color(0xff0A2B4E),
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Invalid quantity. Please enter a number.'),
                                    ),
                                  );
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
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
                      onPressed: () {
                        showEditSuccessDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffAAD4FF),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0)
                      ),
                      child: const Text(
                        'Edit',
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
      ),
      activePage: 'Edit barang',
    );
  }
}

void showEditSuccessDialog(BuildContext context) async {
  final result = await showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return CustomDialog(
        title: "Edit Berhasil",
        // content: "Barang berhasil diedit.",
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48.0),
        actionText: "Kembali ke daftar barang",
        onPressed: () => Navigator.pop(context), // Pop the dialog first
      );
    },
  );

  if (result == true) {
    // User pressed the action button
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DaftarBarang()),
    );
  }
}
