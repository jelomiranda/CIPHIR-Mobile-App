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
      title: 'CIPHIR App', // You can add a title for the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Add a theme if needed
      ),
      debugShowCheckedModeBanner: false, // Remove debug symbol
      // Define named routes
      routes: {
        '/login': (context) => const Login(), // Named route for login screen
        '/profile': (context) =>
            const Profile(), // Named route for profile screen
        '/camera': (context) => const Camera(),
         '/home': (context) => Home(),
      },
      initialRoute: '/login', // Set the initial route to the login screen
    );
  }
}
