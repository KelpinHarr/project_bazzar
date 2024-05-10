import 'package:flutter/material.dart';
import 'package:project_bazzar/login.dart';
import 'package:project_bazzar/stand/buatTransaksi.dart';
import 'package:project_bazzar/stand/daftarBarang.dart';
import 'package:project_bazzar/stand/home.dart';
import 'package:project_bazzar/stand/riwayatTransaksi.dart';
import 'package:project_bazzar/stand/tambahBarang.dart';

class NavBarStand extends StatelessWidget {
  const NavBarStand({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            title: const Text(
              'Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeStand()),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Buat transaksi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
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
            title: const Text(
              'Riwayat transaksi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
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
            title: const Text(
              'Daftar barang',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
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
            title: const Text(
              'Tambah barang',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
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
      ),
    );
  }
}
