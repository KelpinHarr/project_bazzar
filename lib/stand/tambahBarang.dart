import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/navbarv2.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class TambahBarang extends StatefulWidget {
  const TambahBarang({super.key});

  @override
  _TambahBarangState createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang>
    with SingleTickerProviderStateMixin {
  final _namaBarangController = TextEditingController();
  final _hargaController = TextEditingController();
  bool _showQtyInput = false;
  int _qty = 0; // Current quantity

  Future<File> createFileFromUint8List(
      Uint8List uint8list, String filePath) async {
    final file = File(filePath);
    await file.writeAsBytes(uint8list);
    return file;
  }

  late AnimationController loadingController;
  File? _file;
  PlatformFile? _platformFile;

  Future<void> selectFile() async {
    try {
      FilePickerResult? file = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'jpg']);

      if (file != null && file.files != null && file.files.isNotEmpty) { 
      final bytes = file.files.single.bytes;
      if (bytes != null){
          final excel = Excel.decodeBytes(bytes!);

          final sheetName = excel.tables.keys.first;
          final sheet = excel.tables[sheetName];

          if (sheet != null && sheet.rows != null){
            final data = sheet.rows;
            String? namaStand;
            List<String>? namaBarang;
            int? qty;
            int? price;

            for (var row in data!){
              if (row.first?.value == 'NAMA STAND' || row.first?.value == 'NAMA BARANG' || row.first?.value == 'QTY' || row.first?.value == 'HARGA'){
                print('Skipping row with first cell value: ${row.first?.value}');
                continue;
              }
              if (row[1]?.value.toString() == "Sushi Saga") {
                namaStand = row[1]?.value.toString();
                break;
              }
              // final qtyString = row[2]?.value.toString();
              // final priceString = row[row.length - 1]?.value.toString();
              // qty = qtyString != null ? int.tryParse(qtyString) : null;
              // price = priceString != null ? int.tryParse(priceString) : null;
            }
            for (var row in data!.sublist(2)){
              if (namaBarang != null){
                namaBarang!.add(row[0]?.value?.toString() ?? "");
              }
              print('Nama Barang: $namaBarang');
            }
            print('Nama Stand: $namaStand');
            
            print('QTY: $qty');
            print('Harga: $price');
          }

          setState(() {
            _file = File(String.fromCharCodes(file.files.single.bytes!));
            _platformFile = file.files.first;
          });
        }
        loadingController.forward();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting file: $e')),
      );
    }
  }

  Future<void> uploadFileToFirestore() async {
    if (_file == null || _platformFile == null) return;

    try {
      // final firestore = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref().child('files/${_platformFile!.name}');
      final uploadTask = await storageRef.putFile(_file!);

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      final firestore = FirebaseFirestore.instance;

      final fileMetadata = {
        'nama': _platformFile!.name,
        'size': _platformFile!.size,
        'downloadUrl': downloadUrl,
        'item_name': _namaBarangController.text,
        'price': int.parse(_hargaController.text),
        'stand_name': 'Sushi Saga',
      };
      await firestore.collection('items').add(fileMetadata);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File uploaded and saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting file: $e')),
      );
    }
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama barang tidak boleh kosong';
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
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
                                    0.0), // Remove padding for a cleaner look
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
                        } else {
                          await uploadFileToFirestore();
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
                const SizedBox(height: 24.0),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                const SizedBox(height: 24.0),

                // upload file
                GestureDetector(
                  onTap: selectFile,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Colors.blue.shade400,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade50.withOpacity(.3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Iconsax.folder_open,
                                color: Colors.blue,
                                size: 40,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Select your file',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),

                _platformFile != null
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected File',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: const Offset(0, 1),
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
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${(_platformFile!.size / 1024).ceil()} KB',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade500),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 5,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blue.shade50,
                                    ),
                                    child: LinearProgressIndicator(
                                      value: loadingController.value,
                                      backgroundColor: const Color(
                                          0xffAAD4FF), // Warna latar belakang
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xff0A2B4E)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
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
                                          backgroundColor:
                                              const Color(0xffAAD4FF),
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0)),
                                      child: const Text(
                                        'Selanjutnya',
                                        style: TextStyle(
                                            color: Color(0xff0A2B4E),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  )
                                : const SizedBox(), // Widget kosong jika loading belum selesai
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
