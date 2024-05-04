import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/navbarv2.dart';

class CekSaldo extends StatefulWidget {
  const CekSaldo({Key? key}) : super(key: key);

  @override
  _CekSaldoState createState() => _CekSaldoState();
}

class _CekSaldoState extends State<CekSaldo> {
  @override
  Widget build(BuildContext context) {
    return NavbarAdminv2(
      key: GlobalKey(),
      body: Scaffold(

      ),
      activePage: 'Cek saldo',
    );
  }
}

