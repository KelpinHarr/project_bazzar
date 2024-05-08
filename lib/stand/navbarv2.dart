import 'package:flutter/material.dart';
import 'package:project_bazzar/login.dart';
import 'package:project_bazzar/stand/buatTransaksi.dart';
import 'package:project_bazzar/stand/daftarBarang.dart';
import 'package:project_bazzar/stand/riwayatTransaksi.dart';
import 'package:project_bazzar/stand/tambahBarang.dart';

class NavbarStandv2 extends StatelessWidget {
  const NavbarStandv2({super.key, required this.body, required this.activePage});

  final Widget body;
  final String activePage;

  @override
  Widget build(BuildContext context) {
    String pageTitle = '';
    if (activePage == 'Tambah barang') {
      pageTitle = 'Tambah Barang';
    } else if (activePage == 'Tambah transaksi') {
      pageTitle = 'Tambah Transaksi';
    } else if (activePage == 'Riwayat transaksi') {
      pageTitle = 'Riwayat transaksi';
    } else if (activePage == 'List barang') {
      pageTitle = 'List barang';
    } else if (activePage == 'Daftar barang') {
      pageTitle = 'Daftar barang';
    } else if (activePage == 'Edit barang') {
      pageTitle = 'Edit barang';
    } else if (activePage == 'Detil transaksi') {
      pageTitle = 'Detil transaksi';
    } else if (activePage == 'Buat transaksi') {
      pageTitle = 'Buat transaksi';
    } else if (activePage == 'Bayar transaksi') {
      pageTitle = 'Bayar transaksi';
    } else if (activePage == 'Riwayat transaksi') {
      pageTitle = 'Riwayat transaksi';
    } else if (activePage == 'Scan QR') {
      pageTitle = 'Scan QR';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: const TextStyle(
            color: Color(0xffAAD4FF),
          ),
        ),
        backgroundColor: const Color(0xff0A2B4E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (activePage == 'Detil transaksi') {
              Navigator.pop(context);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          },
          color: const Color(0xffAAD4FF),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              color: const Color(0xffAAD4FF), // Set menu icon color here
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Color(0xffAAD4FF)),
      ),
      body: body,
      endDrawer: Builder(
        builder: (context) => Drawer(
          backgroundColor: const Color(0xffF0F0E8),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xff0A2B4E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 75),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Profile.png', // Replace with your image path
                        height: 60, // Adjust image size as needed
                        width: 60,
                        fit: BoxFit.contain, // Ensure image fits within container
                      ),
                      const Text(
                        'Sushi Saga',
                        style: TextStyle(
                          color: Color(0xffAAD4FF),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Home' ? FontWeight.bold : FontWeight.normal,
                      color: const Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                ),
                ListTile(
                  title: Text(
                    'Buat transaksi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Buat transaksi' ? FontWeight.bold : FontWeight.normal,
                      color: const Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BuatTransaksi()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Riwayat transaksi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Riwayat transaksi' ? FontWeight.bold : FontWeight.normal,
                      color: const Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RiwayatTransaksi()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Daftar barang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Daftar barang' ? FontWeight.bold : FontWeight.normal,
                      color: const Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DaftarBarang()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Tambah barang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Tambah barang' ? FontWeight.bold : FontWeight.normal,
                      color: const Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TambahBarang()),
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0)
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
