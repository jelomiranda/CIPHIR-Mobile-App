import 'package:ciphir_mobile/screens/camera.dart';
import 'package:ciphir_mobile/screens/home.dart';
import 'package:ciphir_mobile/screens/login.dart';
import 'package:ciphir_mobile/screens/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIPHIR App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const Login(),
        '/profile': (context) => const Profile(),
        '/home': (context) => const Home(),
        '/camera': (context) => const Camera(),
      },
      initialRoute: '/login',
    );
  }
}
