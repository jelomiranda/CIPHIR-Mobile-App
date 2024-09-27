import 'package:ciphir_mobile/screens/signup.dart';
import 'package:ciphir_mobile/screens/home.dart';
import 'package:ciphir_mobile/utils/color_utils.dart';
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: Center(
                child: Image.asset(
                  'assets/images/mobile_logo.png',
                  width: 220,
                  height: 220,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 40),
              child: Center(
                child: Image.asset(
                  'assets/images/welcome.png',
                  height: 40,
                  width: 200,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Username',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: hexStringToColor("363333"),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                child: const Text(
                  "Don't have an account yet? Sign up here",
                  style: TextStyle(
                    color: Color.fromARGB(164, 104, 96, 96),
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Signup()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
