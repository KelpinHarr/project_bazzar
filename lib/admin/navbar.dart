import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:project_bazzar/admin/cekSaldo.dart';

late List<CameraDescription>? cameras;
Future<List<CameraDescription>?> initializeCamera() async {
  cameras = await availableCameras();
  return cameras;
}

class NavBarAdmin extends StatelessWidget {
  const NavBarAdmin({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  'assets/Profile.png',
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
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
                fontWeight: FontWeight.bold,
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
                color: Color(0xff0A2B4E),
              ),
            ),
            onTap: () async {
              await initializeCamera();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CekSaldo(cameras: cameras)),
              );
            },
          ),
          ListTile(
            title: Text(
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
            title: Text(
              'Daftar user',
              textAlign: TextAlign.center,
              style: TextStyle(
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
      ),
    );
  }
}
