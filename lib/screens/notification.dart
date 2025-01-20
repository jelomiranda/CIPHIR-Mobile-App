import 'package:ciphir_mobile/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:ciphir_mobile/backend/data_service.dart';
import 'package:ciphir_mobile/backend/LoginService.dart'; // For accessing currentUser

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // Fetch notifications from the backend
  Future<void> _fetchNotifications() async {
    try {
      final int residentId = int.parse(currentUser['resident_id'].toString());
      final fetchedNotifications =
          await DataService.getNotifications(residentId);

      if (mounted) {
        setState(() {
          notifications = fetchedNotifications;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching notifications: $e");
    }
  }

  // Method to handle feedback submission
  Future<void> _submitFeedback(int reportId, String comment) async {
    try {
      final response = await DataService.submitFeedback({
        'report_id': reportId,
        'comment': comment,
      });

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Feedback submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit feedback.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error submitting feedback: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while submitting feedback.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Image.asset(
                  'assets/images/ciphir_logo2.png',
                  height: 150,
                ),
                const SizedBox(height: 5),
                const Divider(thickness: 1),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "NOTIFICATIONS",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF243464),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notifications.isEmpty
                      ? const Center(
                          child: Text(
                            "No notifications available.",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : Scrollbar(
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
                                    notification["date_received"] ?? "",
                                    notification["time_received"] ?? "",
                                    notification["report_id"] ?? 0,
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, String message,
      String date, String time, int reportId) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: hexStringToColor("879EA6"),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (message.contains(
              "resolved")) // Show feedback button for resolved messages
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _showFeedbackDialog(reportId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                ),
                child: const Text("Write Feedback"),
              ),
            ),
        ],
      ),
    );
  }

  // Dialog for submitting feedback
  void _showFeedbackDialog(int reportId) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submit Feedback"),
          content: TextField(
            controller: feedbackController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Write your feedback here...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _submitFeedback(reportId, feedbackController.text);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
