import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:project_bazzar/ConfirmDialog.dart';
import 'package:project_bazzar/Transaction.dart';
import 'package:project_bazzar/stand/navbarv2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

List<String> productNames = [
  'Pisang Ambon',
  'Apel Fuji',
  'Jeruk Manis',
  'Mangga Harum Manis',
  'Anggur Hitam',
  'Semangka Merah',
  'Melon Madu',
  'Nanas Madu',
  'Pepaya California',
  'Stroberi Mekar',
];

class BuatTransaksi extends StatefulWidget {
  final String name;
  const BuatTransaksi({super.key, required this.name});

  @override
  _BuatTransaksiState createState() => _BuatTransaksiState();
}

class _BuatTransaksiState extends State<BuatTransaksi> {
  final _formKey = GlobalKey<FormState>();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // Input controllers for various fields
  // final _namaController = TextEditingController();
  int _qty = 1; // Track quantity, set initial value to 1
  // final _hargaController = TextEditingController();
  bool _showTambahBarangInput = false;
  bool _showDataTable = false;

  String _selectedProduct = productNames[0];
  List<String> _filteredProducts = productNames;
  List<Transactions> transactions = [];

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
                  // header
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Transaksi',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '\nPK1239423',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // receipt
                  // Menampilkan DataTable sesuai kondisi
                  if (_showDataTable)
                    DataTable(
                      // Props DataTable
                      columns: const [
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Nama',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Qty',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Harga',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: transactions
                          .expand(
                            (transaction) => transaction.items
                                .map((item) => DataRow(
                                      cells: [
                                        DataCell(
                                          Expanded(
                                            child: Text(item.name),
                                          ),
                                        ),
                                        DataCell(
                                          Expanded(
                                            child:
                                                Text(item.quantity.toString()),
                                          ),
                                        ),
                                        DataCell(
                                          Expanded(
                                            child: Text('Rp${item.price}'),
                                          ),
                                        ),
                                        DataCell(
                                          Expanded(
                                            child: Text(
                                                'Rp${item.price * item.quantity}'),
                                          ),
                                        ),
                                      ],
                                    ))
                                .toList(),
                          )
                          .toList(),
                    ),

                  // input barang
                  Visibility(
                    visible: _showTambahBarangInput,
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
                          onChanged: print,
                          selectedItem: _selectedProduct,
                        ),

                        const SizedBox(height: 16.0),

                        // Jumlah TextField
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Align children to the start and end of the row
                          children: [
                            // Widgets for displaying the quantity
                            Text(
                              "Qty: $_qty",
                              style: const TextStyle(
                                color: Color(0xff0A2B4E),
                                fontSize: 18.0,
                              ),
                            ),
                            // Widgets for adjusting the quantity
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
                                    controller:
                                        TextEditingController(text: '$_qty'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      // Update _qty based on user input, handling potential errors
                                      try {
                                        int newQty = int.parse(value);
                                        if (newQty >= 1) {
                                          setState(() {
                                            _qty = newQty;
                                          });
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                          ],
                        ),
                        const SizedBox(height: 32.0),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .end, // Align children to the end (right side)
                            children: [
                              SizedBox(
                                width: 180.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // tambah baris tabel
                                    setState(() {
                                      // Buat objek transaksi baru
                                      Transactions newTransaction =
                                          Transactions(
                                            name: widget.name,
                                        // Isi data transaksi sesuai dengan input pengguna
                                        items: [
                                          TransactionItem(
                                              name: _selectedProduct,
                                              quantity: _qty,
                                              price: 4000)
                                        ],
                                        buyerId: "Kenny",
                                        date:
                                            DateTime(2024, 11, 11, 18, 58, 23),
                                        id: "PK1239423",
                                        stand: "Sushi Saga",
                                        status: "Belum Bayar",
                                        totalAmount: 12000,
                                        totalQty: 3,

                                        // tambahkan properti lain jika ada, misalnya tanggal transaksi, dsb.
                                      );

                                      // Tambahkan transaksi baru ke daftar transaksi
                                      transactions.add(newTransaction);
                                      _showTambahBarangInput = false;
                                      _qty = 1;
                                      _showDataTable =
                                          true; // Setelah transaksi ditambahkan, tampilkan DataTable
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff0A2B4E),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16.0),
                  Visibility(
                    visible:
                        !_showTambahBarangInput, // Ubah visible ke false jika _showTambahBarangInput true
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _showTambahBarangInput = true;
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
                          SizedBox(width: 8), // Adjust the width as needed
                          Text("Tambah barang"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48.0),
                  // button bayar transaksi
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffAAD4FF),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 16.0)),
                        child: const Text(
                          'Bayar',
                          style: TextStyle(
                              color: Color(0xff0A2B4E),
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
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
                                const EdgeInsets.symmetric(vertical: 16.0)),
                        child: const Text(
                          'Batalkan transaksi',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
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

  bool _isNavigated = false;
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null && !_isNavigated) {
        _isNavigated = true; // Tandai bahwa navigasi sudah dilakukan
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const TopUp()),
        // ).then((_) {
        //   // Dispose controller after returning from TopUp page
        //   controller.dispose();
        //   setState(() {
        //     result = null;
        //   });
        // });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
