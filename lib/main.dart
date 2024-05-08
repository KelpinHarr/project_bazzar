import 'package:flutter/material.dart';
import 'package:project_bazzar/login.dart';
import 'package:project_bazzar/admin/navbar.dart';
import 'package:project_bazzar/stand/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // '/': (context) => Login(),
        '/': (context) => HomePage(),
        // '/main': (context) => HomePage(),
        // tambahkan rute lain jika diperlukan
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome, Sushi Saga!",
          style: TextStyle(color: Color(0xffAAD4FF), fontWeight: FontWeight.bold),
        ),
        elevation: 10,
        backgroundColor: Color(0xff0A2B4E),
        iconTheme: IconThemeData(color: Color(0xffAAD4FF)),
      ),
      endDrawer: NavBarStand(),
      backgroundColor: Color(0xffF0F0E8),
      body: SingleChildScrollView (
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Memberikan margin horizontal 16.0
          height: 180,
          child: Container(
            width: double.infinity, // Lebar penuh
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[200]!, Colors.white],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200, // Shadow color
                  offset: Offset(0.0, 2.0), // Shadow offset
                  blurRadius: 4.0, // Shadow blur radius
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              children: [
                Text(
                  'Pendapatan Hari Ini',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Rp150.000',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
