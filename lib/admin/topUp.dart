import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/navbarv2.dart';

class TopUp extends StatefulWidget {
  const TopUp({Key? key}) : super(key: key);

  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  @override
  Widget build(BuildContext context) {
    return NavbarAdminv2(
      key: GlobalKey(),
      body: Scaffold(

      ),
      activePage: 'Top up',
    );
  }
}

