import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/stand/home.dart';
import 'package:project_bazzar/student/home.dart';
import 'package:project_bazzar/admin/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0E8),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 100.0),
              child: Image.asset('assets/Logo Pelangi Kristus.png'),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                        color: Color(0xff0A2B4E),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 275.0,
                    height: 50.0,
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Color(0xff36454F)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(
                                  0xffAAD4FF)), // Warna tepi luar saat tidak aktif
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(
                                  0xff0A2B4E)), // Warna tepi luar saat aktif
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 275.0,
                    height: 50.0,
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Color(0xff36454F)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(
                                  0xffAAD4FF)), // Warna tepi luar saat tidak aktif
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(
                                  0xff0A2B4E)), // Warna tepi luar saat aktif
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 275.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.lightBlueAccent.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _loginUser();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffAAD4FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          minimumSize: const Size(275.0, 50.0),
                        ),
                        child: const Text(
                          'Login',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: Color(0xff0A2B4E),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection('users').where('username', isEqualTo: username).get();

      if (userDoc.docs.isNotEmpty) {
        for (var doc in userDoc.docs){
          final user = doc.data();
          if (user!['password'] == password) {
            if (user['role'] == 'admin') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeAdmin()),
              );
            } 
            else if (user['role'] == 'stand') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeStand()),
              );
            } 
            else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeStudent()),
              );
            }
          } 
          else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Invalid password')));
          }

        }
      } 
      else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User not found')));
      }
    } 
    catch (e) {
      print('Error: $e');
    }
  }
}
