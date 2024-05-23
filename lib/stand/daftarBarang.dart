import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_bazzar/ConfirmDialog.dart';
import 'package:project_bazzar/stand/editBarang.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

class DaftarBarang extends StatefulWidget {
  final String name;
  const DaftarBarang({Key? key, required this.name}) : super(key: key);

  @override
  _DaftarBarangState createState() => _DaftarBarangState();
}

class _DaftarBarangState extends State<DaftarBarang> {
  List<Map<String, dynamic>> daftarBarang = [];

  @override
  void initState(){
    super.initState();
    _getItem();
  }

  Future<void>_getItem() async {
    try{
      final firestore = FirebaseFirestore.instance;
      final itemDoc = await firestore
          .collection('items')
          .where('stand_name', isEqualTo: widget.name)
          .get(); 
      if (itemDoc.docs.isNotEmpty){
        for (final item in itemDoc.docs){
          final name = item['name'].trim();
          final price = item['price'];
          final qty = item['qty'];
          print('name: $name, stand_name: ${item['stand_name']}, qty: $qty');
          setState(() {
            daftarBarang.add({'nama': name, 'harga': price, 'qty': qty});
          });
        }
      }
    }
    catch(e){
      print(e);
    }
  }

  String formatIdr(int amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(amount);
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
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: daftarBarang.length,
                  itemBuilder: (context, index) {
                    final barang = daftarBarang[index];
                    final String namaBarang = barang['qty'] != null
                        ? '${barang['nama']} (Qty: ${barang['qty']})'
                        : barang['nama'];
                    return Card(
                      elevation: 2.5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    namaBarang,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0A2B4E),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Rp ${barang['harga'].toString()}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff0A2B4E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                              return ConfirmDialog(
                                              title: "Konfirmasi Hapus Barang",
                                              icon: const Icon(Icons.warning, color: Colors.orange),
                                              message: "Apakah Anda yakin ingin menghapus barang ini?",
                                              mode: "Hapus",
                                              onDeletePressed: () {
                                                // Implement your logic for deleting the item here
                                                Navigator.pop(context);
                                              },
                                              onCancelPressed: () => Navigator.pop(context),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => EditBarang(
                                            name: barang['nama'],
                                            price: barang['harga'],
                                            qty: barang['qty'],
                                          )),
                                        );
                                      },
                                      icon: const Icon(Icons.edit, color: Color(0xff0A2B4E)),
                                      label: const Text('Edit', style: TextStyle(color: Color(0xff0A2B4E))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      activePage: 'Daftar barang',
    );
  }
}
