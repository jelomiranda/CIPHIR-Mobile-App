import 'package:ciphir_mobile/utils/color_utils.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for notifications
    final List<Map<String, String>> notifications = [
      {
        "message":
            "Your report has been submitted and will be reviewed shortly. Please wait for further updates.",
        "reportID": "100006062024",
      },
      {
        "message":
            "Report_ID: 100005202024 has been resolved. Thank you for your assistance!",
        "reportID": "100005202024",
      },
      {
        "message":
            "Your report has been submitted and will be reviewed shortly. Please wait for further updates.",
        "reportID": "100005202024",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Add back navigation logic
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Logo and Title
            Column(
              children: [
                Image.asset(
                  'assets/images/ciphir_logo2.png', // Replace with the actual logo path
                  height: 150,
                ),
                const Divider(thickness: 1),
              ],
            ),

            const SizedBox(height: 20),

            // Notification Header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "NOTIFICATIONS",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF243464), // Custom color
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Notification List
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildNotificationCard(
                      context,
                      notification["message"] ?? "",
                      notification["reportID"] ?? "",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build each notification card
  Widget _buildNotificationCard(
      BuildContext context, String message, String reportID) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: hexStringToColor("879EA6"), // Background color for notification
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 1),
        ],
      ),
    );
  }
}
