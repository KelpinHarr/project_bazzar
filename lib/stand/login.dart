import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F0E8),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 100.0),
            child: Image.asset('assets/Logo Pelangi Kristus.png'),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xff0A2B4E),
                      fontSize: 24, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 40),
                  // const Text(
                  //   'Username',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //
                  //   ),
                  // ),
                  SizedBox(
                    width: 275.0,
                    height: 50.0,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Color(0xff36454F)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffAAD4FF)), // Warna tepi luar saat tidak aktif
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0A2B4E)), // Warna tepi luar saat aktif
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 275.0,
                    height: 50.0,
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Color(0xff36454F)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffAAD4FF)), // Warna tepi luar saat tidak aktif
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff0A2B4E)), // Warna tepi luar saat aktif
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 275.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //   colors: [
                        //     Color.fromRGBO(170, 212, 255, 1.0),
                        //     Color.fromRGBO(10, 43, 78, 1.0),
                        //   ],
                        //   begin: Alignment.centerLeft,
                        //   end: Alignment.centerRight,
                        // ),
                        color: Color(0xffAAD4FF),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.lightBlueAccent.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ]
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
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
          ),
        ],
      ),
    );
  }
}
