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
          "Hi, Admin!",
          style: TextStyle(color: Color(0xffAAD4FF), fontWeight: FontWeight.bold),
        ),
        elevation: 10,
        backgroundColor: Color(0xff0A2B4E),
        iconTheme: IconThemeData(color: Color(0xffAAD4FF)),
      ),
      endDrawer: NavBarAdmin(),
      backgroundColor: Color(0xffF0F0E8),
    );
  }
}