import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/navbarv2.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:typed_data';

class TambahBarang extends StatefulWidget {
  @override
  _TambahBarangState createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> with SingleTickerProviderStateMixin{
  final _namaBarangController = TextEditingController();
  final _hargaController = TextEditingController();
  bool _showQtyInput = false;
  int _qty = 0; // Current quantity

  Future<File> createFileFromUint8List(Uint8List uint8list, String filePath) async {
    final file = File(filePath);
    await file.writeAsBytes(uint8list);
    return file;
  }
  late AnimationController loadingController;
  File? _file;
  PlatformFile? _platformFile;

  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'jpg']
    );

    if (file != null) {
      setState(() {
        _file = File(String.fromCharCodes(file.files.single.bytes!));
        _platformFile = file.files.first;
      });
    }

    loadingController.forward();
  }


  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() { setState(() {}); });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavbarStandv2(
      key: GlobalKey(),
      body: Scaffold(
        backgroundColor: Color(0xffF0F0E8),
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
                SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Atau',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),

                // upload file
                GestureDetector(
                  onTap: selectFile,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10),
                        dashPattern: [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Colors.blue.shade400,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade50.withOpacity(.3),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.folder_open, color: Colors.blue, size: 40,),
                              SizedBox(height: 15,),
                              Text('Select your file', style: TextStyle(fontSize: 15, color: Colors.grey.shade400),),
                            ],
                          ),
                        ),
                      )
                  ),
                ),

                _platformFile != null
                    ? Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected File',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _platformFile!.name,
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${(_platformFile!.size / 1024).ceil()} KB',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 5,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue.shade50,
                              ),
                              child: LinearProgressIndicator(
                                value: loadingController.value,
                                backgroundColor: Color(0xffAAD4FF), // Warna latar belakang
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0A2B4E)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      loadingController.value == 1.0
                          ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => (data: dataToPass),
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffAAD4FF),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0)),
                          child: Text(
                            'Selanjutnya',
                            style: TextStyle(
                                color: Color(0xff0A2B4E),
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      )
                          : SizedBox(), // Widget kosong jika loading belum selesai
                    ],
                  ),
                )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      activePage: 'Tambah barang',
    );
  }
}
