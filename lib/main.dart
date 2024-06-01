import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_bazzar/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyC1b1KTJgae_97i_bgkB4InVga_MZaI4Ko",
          appId: "1:806688010038:android:ddcf9c90259394be5a8d97",
          messagingSenderId: "806688010038",
          projectId: "projectbazzar-9e716"
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        // '/': (context) => HomeStudent(),
      },
    );
  }
}