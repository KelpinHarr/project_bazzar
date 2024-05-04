import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:project_bazzar/admin/qrCekSaldo.dart';
import 'package:project_bazzar/login.dart';

late List<CameraDescription>? cameras;
Future<List<CameraDescription>?> initializeCamera() async {
  cameras = await availableCameras();
  return cameras;
}

class NavBarAdmin extends StatelessWidget {
  const NavBarAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  'assets/Profile.png',
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
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
            title: const Text(
              'Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () {
              // Add action
            },
          ),
          ListTile(
            title: const Text(
              'Cek saldo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () async {
              await initializeCamera();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QrCekSaldo()),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Top up',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () {
              // Add action
            },
          ),
          ListTile(
            title: const Text(
              'Daftar user',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () {

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
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
