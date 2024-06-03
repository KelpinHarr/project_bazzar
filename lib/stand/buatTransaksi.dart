import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:project_bazzar/ConfirmDialog.dart';
import 'package:project_bazzar/CustomDialog.dart';
import 'package:project_bazzar/Transaction.dart';
import 'package:project_bazzar/currencyUtils.dart';
import 'package:project_bazzar/stand/home.dart';
import 'package:project_bazzar/stand/navbarv2.dart';
import 'package:project_bazzar/stand/qrBayar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

late List<CameraDescription>? cameras;
Future<List<CameraDescription>?> initializeCamera() async {
  cameras = await availableCameras();
  return cameras;
}

class BuatTransaksi extends StatefulWidget {
  final String name;
  const BuatTransaksi({super.key, required this.name});

  @override
  _BuatTransaksiState createState() => _BuatTransaksiState();
}

class _BuatTransaksiState extends State<BuatTransaksi> {
  final _formKey = GlobalKey<FormState>();
  List<String> productNames = [];
  Map<String, double> _productDetails = {};
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // Input controllers for various fields
  // final _namaController = TextEditingController();
  int _qty = 1; // Track quantity, set initial value to 1
  // final _hargaController = TextEditingController();
  bool _showTambahBarangInput = false;
  bool _showDataTable = false;

  String _selectedProduct = '';
  List<String> _filteredProducts = [];
  List<Transactions> transactions = [];

  @override
  void initState() {
    super.initState();
    _getItem();
  }

  Future<void> _getItem() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final itemDoc = await firestore
          .collection('items')
          .where('stand_name', isEqualTo: widget.name)
          .get();
      if (itemDoc.docs.isNotEmpty) {
        // print('Total Items Found: ${itemDoc.docs.length}');
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data:  ${itemDoc.docs.length}')));
        for (final item in itemDoc.docs) {
          setState(() {
            final name = item['name'].trim();
            final price = (item['price'] is String)
                ? double.parse(item['price'])
                : (item['price'] as num).toDouble();
            productNames.add(name);
            _productDetails[name] = price;
          });
          _filteredProducts = List.from(productNames);

          if (productNames.isNotEmpty) {
            _selectedProduct = productNames[0];
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalHarga = transactions
        .expand((transaction) => transaction.items)
        .fold(0, (sum, item) => sum + item.price * item.quantity);

    return NavbarStandv2(
      name: widget.name,
      key: GlobalKey(),
      body: Scaffold(
        backgroundColor: const Color(0xffF0F0E8),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  if (_showDataTable)
                    Center(
                      child: transactions.isEmpty
                          ? Container() // Jika kosong, tampilkan container kosong
                          : Flexible(
                        child: DataTable(
                          columnSpacing: 16.0,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Nama',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Qty',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // DataColumn(
                            //   label: Text(
                            //     'Harga',
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            DataColumn(
                              label: Text(
                                'Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: [
                            ...transactions.asMap().entries.map((entry) {
                              final item = transactions[entry.key].items[0];
                              final truncatedName = item.name.length > 15
                                  ? item.name.substring(0, 15) + '...'
                                  : item.name;

                              return DataRow(
                                cells: [
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 100,
                                      ),
                                      child: Text(
                                        truncatedName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff36454F),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(item.quantity.toString()),
                                  ),
                                  // DataCell(
                                  //   Text(
                                  //     formatCurrency(item.price.toInt()),
                                  //   ),
                                  // ),
                                  DataCell(
                                    Text(
                                      formatCurrency(item.price.toInt() * item.quantity),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          transactions.removeAt(entry.key);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            DataRow(
                              cells: [
                                const DataCell(
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // const DataCell(
                                //   Text(''),
                                // ),
                                const DataCell(
                                  Text(''),
                                ),
                                DataCell(
                                  Text(
                                    formatCurrency(totalHarga.toInt()),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const DataCell(
                                  Text(''),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  // input barang
                  Visibility(
                    visible: _showTambahBarangInput,
                    child: Container(
                      margin: const EdgeInsets.only(top: 16.0), // Menambahkan margin atas
                      padding: const EdgeInsets.all(16.0), // Menambahkan padding dalam kotak
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff0A2B4E),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0), // Mengatur border radius
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownSearch<String>(
                            popupProps: const PopupProps.menu(
                              showSelectedItems: true,
                            ),
                            items: _filteredProducts,
                            dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Nama barang",
                                labelStyle: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedProduct = value!;
                              });
                            },
                            selectedItem: _selectedProduct,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Qty: ",
                                style: const TextStyle(
                                  color: Color(0xff0A2B4E),
                                  fontSize: 18.0,
                                ),
                              ),
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
                                    icon: const Icon(Icons.remove),
                                    color: const Color(0xff0A2B4E),
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                    child: TextField(
                                      controller: TextEditingController(text: '$_qty'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        try {
                                          int newQty = int.parse(value);
                                          if (newQty >= 1) {
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
                                        contentPadding: EdgeInsets.all(0.0),
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
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      final selectedProductPrice = _productDetails[_selectedProduct]!;
                                      Transactions newTransaction = Transactions(
                                        name: widget.name,
                                        items: [
                                          TransactionItem(
                                            name: _selectedProduct,
                                            quantity: _qty,
                                            price: selectedProductPrice,
                                          ),
                                        ],
                                        buyerId: "Kenny",
                                        date: DateTime(2024, 11, 11, 18, 58, 23),
                                        id: "PK1239423",
                                        stand: "Sushi Saga",
                                        status: "Belum Bayar",
                                        totalAmount: selectedProductPrice * _qty,
                                        totalQty: (_qty as num).toDouble(),
                                      );

                                      transactions.add(newTransaction);
                                      _showTambahBarangInput = false;
                                      _qty = 1;
                                      _showDataTable = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff0A2B4E),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  ),
                                  child: const Text(
                                    'Tambah',
                                    style: TextStyle(
                                      color: Color(0xffAAD4FF),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8.0),
                  Visibility(
                    visible:
                        !_showTambahBarangInput,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _showTambahBarangInput = true;
                          _qty = 1;
                        });
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff0A2B4E)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 8), // Adjust the width as needed
                          Text(
                              "Tambah barang",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff0A2B4E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32.0),
                  // button bayar transaksi
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (transactions.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  title: "Belum ada item yang ditambahkan",
                                  icon: const Icon(Icons.warning,
                                      color: Colors.red),
                                  actionText:
                                  "OK",
                                  onPressed: () {
                                    Navigator.pop(context); // Tutup dialog saat tombol ditekan
                                  },
                                );
                              },
                            );
                          } else {
                            await initializeCamera();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QrBayarTransaksi(
                                  totalHarga: totalHarga,
                                  stand_name: widget.name,
                                  transactions: transactions,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffAAD4FF),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        child: const Text(
                          'Bayar',
                          style: TextStyle(
                            color: Color(0xff0A2B4E),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // button batal membuat transaksi
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialog(
                                title: "Konfirmasi Membatalkan Transaksi",
                                icon: const Icon(Icons.warning,
                                    color: Colors.orange),
                                message:
                                    "Apakah Anda yakin ingin membatalkan transaksi ini?",
                                mode: "Ya",
                                onDeletePressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeStand(name: widget.name)));
                                },
                                onCancelPressed: () => Navigator.pop(context),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12.0)),
                        child: const Text(
                          'Batalkan transaksi',
                          style: TextStyle(
                              color: Colors.white,
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
      ),
      activePage: 'Buat transaksi',
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
