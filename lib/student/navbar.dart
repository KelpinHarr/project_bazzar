import 'package:flutter/material.dart';
import 'package:project_bazzar/login.dart';
import 'package:project_bazzar/student/home.dart';

class NavBarStudent extends StatelessWidget {
  final String name;
  const NavBarStudent({Key? key, required this.name}) : super(key: key);

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
                  'assets/Profile.png', // Replace with your image path
                  height: 60, // Adjust image size as needed
                  width: 60,
                  fit: BoxFit.contain, // Ensure image fits within container
                ),
                Text(
                  '$name',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeStudent(name: name)),
              );
            },
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
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
