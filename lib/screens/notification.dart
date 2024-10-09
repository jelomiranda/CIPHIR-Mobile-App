import 'package:ciphir_mobile/utils/color_utils.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for notifications with a "dateReceived" and "timeReceived" field
    final List<Map<String, String>> notifications = [
      {
        "message":
            "Your report has been submitted and will be reviewed shortly. Please wait for further updates.",
        "dateReceived": "06/06/24",
        "timeReceived": "10:30 AM"
      },
      {
        "message": "Report has been resolved. Thank you for your assistance!",
        "dateReceived": "05/20/24",
        "timeReceived": "01:45 PM"
      },
      {
        "message":
            "Your report has been submitted and will be reviewed shortly. Please wait for further updates.",
        "dateReceived": "05/20/24",
        "timeReceived": "02:00 PM"
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
                const SizedBox(height: 5),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF243464), // Custom color
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Notification List with a scrollbar
            Expanded(
              child: Scrollbar(
                thickness: 4.0,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Column(
                      children: [
                        _buildNotificationCard(
                          context,
                          notification["message"] ?? "",
                          notification["dateReceived"] ?? "",
                          notification["timeReceived"] ?? "",
                        ),
                        if (index != notifications.length - 1)
                          const SizedBox(
                              height: 5), // Reduced space between cards
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(
                height: 20), // Extra spacing before the bottom of the screen
          ],
        ),
      ),
    );
  }

  // Method to build each notification card
  Widget _buildNotificationCard(BuildContext context, String message,
      String dateReceived, String timeReceived) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: hexStringToColor("879EA6"), // Background color for notification
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ], // Subtle shadow for depth
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side for message and date
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      dateReceived,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      timeReceived,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
