import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/editBarang.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

class DaftarBarang extends StatefulWidget {
  const DaftarBarang({Key? key}) : super(key: key);

  @override
  _DaftarBarangState createState() => _DaftarBarangState();
}

class _DaftarBarangState extends State<DaftarBarang> {
  // Dummy data for barang
  final List<Map<String, dynamic>> daftarBarang = [
    {'nama': 'Tuna Sushi', 'harga': 'Rp 20.000'},
    {'nama': 'Salmon Sushi', 'harga': 'Rp 25.000'},
    // Add more data as needed
  ];

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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: daftarBarang.length,
                  itemBuilder: (context, index) {
                    final barang = daftarBarang[index];
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
                                    barang['nama'],
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
                                    barang['harga'],
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
                                            return CustomDialog(
                                              title: "Konfirmasi Hapus Barang",
                                              icon: const Icon(Icons.warning, color: Colors.orange),
                                              message: "Apakah Anda yakin ingin menghapus barang ini?",
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
                                          MaterialPageRoute(builder: (context) => EditBarang()),
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

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget icon;
  final String message;
  final VoidCallback onDeletePressed;
  final VoidCallback onCancelPressed;

  const CustomDialog({
    required this.title,
    required this.icon,
    required this.message,
    required this.onDeletePressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: const Color(0xff0A2B4E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: icon),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onDeletePressed,
                  child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                TextButton(
                  onPressed: onCancelPressed,
                  child: const Text("Kembali", style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
