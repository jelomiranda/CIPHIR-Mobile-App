import 'package:flutter/material.dart';
import 'package:ciphir_mobile/screens/camera.dart';
import 'package:ciphir_mobile/screens/notification.dart';
import 'package:ciphir_mobile/screens/history.dart';
import 'package:ciphir_mobile/screens/profile.dart';
import 'package:ciphir_mobile/utils/color_utils.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns items to the left
          children: <Widget>[
            // Logo at the top
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                // Centering the logo
                child: Image.asset(
                  'assets/images/mobile_logo.png',
                  height: 180,
                  width: 380, // Adjust according to your logo's size
                ),
              ),
            ),

            // Greeting Text
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 50.0), // Adds left padding for left alignment
              child: Align(
                alignment: Alignment.centerLeft, // Aligns text to the left
                child: Text(
                  'Hello, how can we assist you?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: hexStringToColor("243464"),
                  ),
                ),
              ),
            ),

            // Buttons Grid
            Padding(
              padding: const EdgeInsets.only(top: 1.0, left: 20.0, right: 20.0),
              child: GridView.count(
                shrinkWrap: true, // So GridView doesn't scroll
                physics:
                    const NeverScrollableScrollPhysics(), // Disables scrolling
                crossAxisCount: 2, // 2 buttons per row
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1, // Make each button a square
                children: <Widget>[
                  buildMenuItem(
                    icon: Icons.report_problem,
                    label: "REPORT ISSUE",
                    color: hexStringToColor("e74c3c"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Camera()));
                    },
                  ),
                  buildMenuItem(
                    icon: Icons.history,
                    label: "REPORT HISTORY",
                    color: hexStringToColor("229954"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportHistory()));
                    },
                  ),
                  buildMenuItem(
                    icon: Icons.notifications,
                    label: "NOTIFICATIONS",
                    color: hexStringToColor("f4d03f"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Notifications()));
                    },
                  ),
                  buildMenuItem(
                    icon: Icons.person,
                    label: "USER PROFILE",
                    color: hexStringToColor("616a6b"),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a menu item
  Widget buildMenuItem(
      {required IconData icon,
      required String label,
      required Color color,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 60, color: color), // Custom icon color
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: hexStringToColor("243464"),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
