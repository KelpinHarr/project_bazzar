import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/tambahBarang.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xffF0F0E8),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xff0A2B4E),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Profile.png', // Replace with your image path
                  height: 60, // Adjust image size as needed
                  width: 60,
                  fit: BoxFit.contain, // Ensure image fits within container
                ),
                Text(
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
                fontWeight: FontWeight.bold,
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () {
              // Add action
            },
          ),
          ListTile(
            title: Text(
              'Buat transaksi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () {
              // Add action
            },
          ),
          ListTile(
            title: Text(
              'Riwayat transaksi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () {
              // Add action
            },
          ),
          ListTile(
            title: Text(
              'Daftar barang',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () {
              // Add action
            },
          ),
          ListTile(
            title: Text(
              'Tambah barang',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TambahBarang()),
              );
            },
          ),
          Spacer(), // Tambahkan Spacer agar tombol logout muncul di bagian bawah
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan fungsi logout di sini
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Atur borderRadius di sini
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0)
                ),
                child: Text(
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
