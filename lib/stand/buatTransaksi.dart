import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

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
  const BuatTransaksi({Key? key}) : super(key: key);

  @override
  _BuatTransaksiState createState() => _BuatTransaksiState();
}

class _BuatTransaksiState extends State<BuatTransaksi> {
  final _formKey = GlobalKey<FormState>(); // For form validation

  // Input controllers for various fields
  final _namaController = TextEditingController();
  int _qty = 1; // Track quantity, set initial value to 1
  final _hargaController = TextEditingController();
  bool _showQtyInput = false;

  String _selectedProduct = productNames[0];
  List<String> _filteredProducts = productNames;


  @override
  Widget build(BuildContext context) {
    return NavbarStandv2(
      key: GlobalKey(),
      body: Scaffold(
        backgroundColor: const Color(0xffF0F0E8),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                  ),
                  items: _filteredProducts,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Nama barang",
                    ),
                  ),
                  onChanged: print,
                  selectedItem: _selectedProduct,
                ),

                const SizedBox(height: 16.0),

                // Jumlah TextField
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                  children: [
                    // Widgets for displaying the quantity
                    Text(
                      "Qty: $_qty",
                      style: const TextStyle(
                        color: Color(0xff0A2B4E),
                        fontSize: 16.0,
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
                            controller: TextEditingController(text: '$_qty'),
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
                  ],
                ),
                const SizedBox(height: 32.0),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // showEditSuccessDialog(context);
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
                        'Buat transaksi',
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
      activePage: 'Tambah',
    );
  }
}