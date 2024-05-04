import 'package:flutter/material.dart';

class NavbarAdminv2 extends StatelessWidget {
  const NavbarAdminv2({Key? key, required this.body, required this.activePage});

  final Widget body;
  final String activePage;

  @override
  Widget build(BuildContext context) {
    String pageTitle = '';
    if (activePage == 'Cek saldo') {
      pageTitle = 'Cek saldo';
    } else if (activePage == 'Top up') {
      pageTitle = 'Top up';
    } else if (activePage == 'Daftar user') {
      pageTitle = 'Daftar user';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: TextStyle(
            color: Color(0xffAAD4FF),
          ),
        ),
        backgroundColor: Color(0xff0A2B4E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          color: Color(0xffAAD4FF),
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
                        'Admin',
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
                      fontWeight: activePage == 'Home' ? FontWeight.bold : FontWeight.normal,
                      color: Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    // Add action
                  },
                ),
                ListTile(
                  title: Text(
                    'Cek saldo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Cek saldo' ? FontWeight.bold : FontWeight.normal,
                      color: Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    // Add action
                  },
                ),
                ListTile(
                  title: Text(
                    'Top up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Top up' ? FontWeight.bold : FontWeight.normal,
                      color: Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    // Add action
                  },
                ),
                ListTile(
                  title: Text(
                    'Daftar user',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Daftar user' ? FontWeight.bold : FontWeight.normal,
                      color: Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {

                  },
                ),
                Spacer(),
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
                            borderRadius: BorderRadius.circular(8.0),
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
            )
        ),
      ),
    );
  }
}
