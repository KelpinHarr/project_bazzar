import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/editBarang.dart';
import 'package:project_bazzar/stand/navbarv2.dart';

class DaftarBarang extends StatefulWidget {
  @override
  _DaftarBarangState createState() => _DaftarBarangState();
}

class _DaftarBarangState extends State<DaftarBarang> {
  @override
  Widget build(BuildContext context) {
    return NavbarStandv2(
        key: GlobalKey(),
        body: Scaffold(
        backgroundColor: Color(0xffF0F0E8),
          body: SingleChildScrollView(
            child: Container( // Container untuk menentukan warna latar belakang
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 5.0,
                      // color: Color(0xffAAD4FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Set rounded corners
                      child: Padding(
                        padding: const EdgeInsets.all(16.0), // Add padding around content
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align content horizontally
                          children: [
                            // Info Section
                            const Expanded( // Make info section fill available space
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
                                children: [
                                  // Title Section
                                  Text(
                                    'Tuna Sushi',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff0A2B4E)
                                    ),
                                    maxLines: 1, // Limit title to one line (optional)
                                    overflow: TextOverflow.ellipsis, // Add ellipsis (...) if title overflows
                                  ),
                                  SizedBox(height: 8.0), // Add spacing between title and price

                                  // Price Section
                                  Row(
                                    children: [
                                      Text('Rp 20.000', style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff0A2B4E)
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Action Buttons (Aligned at bottom)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end, // Align buttons at bottom
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons horizontally within column
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              title: "Konfirmasi Hapus Barang",
                                              icon: Icon(Icons.warning, color: Colors.orange),
                                              message: "Apakah Anda yakin ingin menghapus barang ini?",
                                              onDeletePressed: () {
                                                // Implement your logic for deleting the item here
                                                Navigator.pop(context); // Close the dialog after delete
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
                    ),

                  ],
                ),
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
      backgroundColor: Color(0xff0A2B4E), // Set background color (dark grey)
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: icon),
            SizedBox(height: 16.0), // Add spacing between icon and text
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color (white)
              ),
            ),
            SizedBox(height: 8.0), // Add spacing between title and message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70), // Text color (light grey)
            ),
            SizedBox(height: 16.0), // Add spacing before buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center buttons horizontally
              children: [
                ElevatedButton(
                  onPressed: onDeletePressed,
                  child: Text("Hapus", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Button color (red)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(width: 16.0), // Add spacing between buttons
                TextButton(
                  onPressed: onCancelPressed,
                  child: Text("Kembali", style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

