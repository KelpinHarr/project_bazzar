import 'package:flutter/material.dart';
import 'package:project_bazzar/admin/navbarv2.dart';

class DaftarUser extends StatefulWidget {
  const DaftarUser({super.key});

  @override
  _DaftarUserState createState() => _DaftarUserState();
}

class _DaftarUserState extends State<DaftarUser> {
  // Dummy data for users
  final List<Map<String, String>> users = [
    {'name': 'John Doe', 'role': 'Stand'},
    {'name': 'Alice Smith', 'role': 'Student'},
    {'name': 'Bob Johnson', 'role': 'Student'},
    {'name': 'Emily Brown', 'role': 'Stand'},
    {'name': 'Michael Davis', 'role': 'Stand'},
    {'name': 'Laura Garcia', 'role': 'Student'},
    {'name': 'David Lee', 'role': 'Student'},
    {'name': 'Emma Wilson', 'role': 'Stand'},
  ];

  @override
  Widget build(BuildContext context) {
    return NavbarAdminv2(
      key: GlobalKey(),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: users.map((user) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Profile.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Role: ${user['role']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      activePage: 'Daftar user',
    );
  }
}
