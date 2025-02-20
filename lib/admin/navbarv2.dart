import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:project_bazzar/admin/home.dart';
import 'package:project_bazzar/admin/qrCekSaldo.dart';
import 'package:project_bazzar/admin/qrTopUp.dart';
import 'package:project_bazzar/login.dart';

late List<CameraDescription>? cameras;
Future<List<CameraDescription>?> initializeCamera() async {
  cameras = await availableCameras();
  return cameras;
}

class NavbarAdminv2 extends StatelessWidget {
  const NavbarAdminv2({super.key, required this.body, required this.activePage});

  final Widget body;
  final String activePage;

  @override
  Widget build(BuildContext context) {
    String pageTitle = '';
    if (activePage == 'Cek saldo') {
      pageTitle = 'Cek saldo';
    } else if (activePage == 'Top up') {
      pageTitle = 'Top up';
    } else if (activePage == 'Scan QR Top Up') {
      pageTitle = 'Scan QR Top Up';
    } else if (activePage == 'Scan QR Cek Saldo') {
      pageTitle = 'Scan QR Cek Saldo';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: const TextStyle(
            color: Color(0xffAAD4FF),
          ),
        ),
        backgroundColor: const Color(0xff0A2B4E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: const Color(0xffAAD4FF),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              color: const Color(0xffAAD4FF), // Set menu icon color here
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Color(0xffAAD4FF)),
      ),
      body: body,
      endDrawer: Builder(
        builder: (context) => Drawer(
            backgroundColor: const Color(0xffF0F0E8),
              child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xff0A2B4E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 75),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Profile.png', // Replace with your image path
                        height: 60, // Adjust image size as needed
                        width: 60,
                        fit: BoxFit.contain, // Ensure image fits within container
                      ),
                      const Text(
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
                      color: const Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeAdmin()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Cek saldo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Cek saldo' ? FontWeight.bold : FontWeight.normal,
                      color: const Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () async {
                    await initializeCamera();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QrCekSaldo()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Top up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: activePage == 'Top up' ? FontWeight.bold : FontWeight.normal,
                      color: const Color(0xff0A2B4E),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QrTopUp()),
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0)
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
