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
            height: 120,
            decoration: BoxDecoration(
              color: Color(0xff0A2B4E),
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.all(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/profile.png', // Ganti dengan path gambar Anda
                      height: 60, // Atur ukuran gambar sesuai kebutuhan Anda
                      width: 60,
                      fit: BoxFit.contain, // Atur agar gambar sesuai ke dalam kotak
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
              ],
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
