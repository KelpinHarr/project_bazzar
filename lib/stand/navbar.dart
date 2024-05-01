import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xffF0F0E8),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xff0A2B4E),
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.all(16),
            child: DrawerHeader(
              child: Text(
                'Sushi Saga',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, // Mengubah warna teks menjadi putih
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff0A2B4E)
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
                  color: Color(0xff0A2B4E)
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
                    color: Color(0xff0A2B4E)
                )
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
                    color: Color(0xff0A2B4E)
                )
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
                    color: Color(0xff0A2B4E)
                )
            ),
            onTap: () {
              // Add action
            },
          ),
        ],
      ),
    );
  }
}
