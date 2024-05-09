import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/navbar.dart';

class HomeStand extends StatefulWidget {
  const HomeStand({super.key});

  @override
  _HomeStandState createState() => _HomeStandState();
}

class _HomeStandState extends State<HomeStand>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Welcome, Sushi Saga!",
          style: TextStyle(
            color: Color(0xffAAD4FF),
          ),
        ),
        backgroundColor: const Color(0xff0A2B4E),
        iconTheme: const IconThemeData(color: Color(0xffAAD4FF)),
      ),
      endDrawer: const NavBarStand(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[200]!, Colors.white],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200, // Shadow color
                    offset: const Offset(0.0, 2.0), // Shadow offset
                    blurRadius: 4.0, // Shadow blur radius
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pedapatan hari ini',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Rp1.500.000',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 16.0
              ),
              child: Text(
                'Laporan Penjualan',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff0A2B4E),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

          ],
        ),
      ),
    );
  }
}