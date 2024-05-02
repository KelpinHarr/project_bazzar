import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/tambahBarang.dart';

class Navbarv2 extends StatelessWidget {
  const Navbarv2({Key? key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sushi Saga",
          style: TextStyle(
            color: Color(0xffAAD4FF),
          ),
        ),
        backgroundColor: Color(0xff0A2B4E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Color(0xffAAD4FF), // Set back button icon color here
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              color: Color(0xffAAD4FF), // Set menu icon color here
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Color(0xffAAD4FF)),
      ),
      body: body,
      endDrawer: Builder(
        builder: (context) => Drawer(
          backgroundColor: Color(0xffF0F0E8),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff0A2B4E),
                  borderRadius: BorderRadius.circular(16),
                ),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TambahBarang())
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
