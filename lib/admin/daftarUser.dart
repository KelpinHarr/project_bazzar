import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/navbarv2.dart';

class DaftarUser extends StatefulWidget {
  const DaftarUser({super.key});

  @override
  _DaftarUserState createState() => _DaftarUserState();
}

class _DaftarUserState extends State<DaftarUser>{
  @override
  Widget build(BuildContext context) {
    return NavbarAdminv2(
      key: GlobalKey(),
      body: const Scaffold(

      ),
      activePage: 'Daftar user',
    );
  }
}