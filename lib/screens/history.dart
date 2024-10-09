import 'package:ciphir_mobile/utils/color_utils.dart';
import 'package:flutter/material.dart';

class ReportHistory extends StatefulWidget {
  const ReportHistory({super.key});

  @override
  _ReportHistoryState createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {
  // Dummy data for report history
  final List<Map<String, String>> reports = [
    {
      "reportID": "100006062024",
      "status": "Pending",
      "type": "Electric Post",
      "date": "06/06/24",
      "description":
          "An electric post is bent due to a vehicle accident last night.",
      "location": "Main St.",
      "attachment": "IMG_492.jpg",
    },
    {
      "reportID": "100005202024",
      "status": "Completed",
      "type": "Pothole",
      "date": "05/20/24",
      "description": "Pothole filled on the main street.",
      "location": "Elm St.",
      "attachment": "IMG_493.jpg",
    },
    // Additional dummy reports
  ];

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
            // Logo and Title
            Column(
              children: [
                Image.asset(
                  'assets/images/ciphir_logo2.png', // Replace with actual logo path
                  height: 150,
                ),
                const SizedBox(height: 5),
                const Divider(thickness: 1),
              ],
            ),

            const SizedBox(height: 20),

            // Report History Header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "REPORT HISTORY",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF243464), // Custom color
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Report History List with a subtle scroll indicator
            Expanded(
              child: Scrollbar(
                thumbVisibility: true, // Subtle scrollbar
                radius: const Radius.circular(10),
                thickness: 1.5, // Scrollbar thickness
                child: ListView.builder(
                  padding:
                      const EdgeInsets.only(bottom: 40), // Bottom allowance
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showReportDetails(
                                context, report); // Show modal on tap
                          },
                          child: _buildReportCard(
                            context,
                            report["status"] ?? "",
                            report["type"] ?? "",
                            report["date"] ?? "",
                          ),
                        ),
                        const SizedBox(height: 10), // Space between cards
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

  // Method to build each report history card
  Widget _buildReportCard(
      BuildContext context, String status, String type, String date) {
    // Icon and color change based on status
    IconData statusIcon;
    Color statusColor;

    if (status == "Completed") {
      statusIcon = Icons.check_circle;
      statusColor = Colors.green;
    } else {
      statusIcon = Icons.pending;
      statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            hexStringToColor("eceeee"), // Background color for the report card
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
          // Left side for status/type
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 25),
                const SizedBox(width: 10), // Space between icon and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5), // Space between status and type
                    Text(
                      "Type: $type",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Middle column for "Tap to view more"
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Tap to view more",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
          // Right side for date
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show the modal with detailed report information
  void _showReportDetails(BuildContext context, Map<String, String> report) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  "Report ID: ${report["reportID"]}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(report["description"] ?? ""),
              const SizedBox(height: 20),
              const Text(
                "Date and Time",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(report["date"] ?? ""),
              const SizedBox(height: 20),
              const Text(
                "Type of Issue",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(report["type"] ?? ""),
              const SizedBox(height: 20),
              const Text(
                "Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(report["location"] ?? ""),
              const SizedBox(height: 20),
              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(report["status"] ?? ""),
              const SizedBox(height: 20),
              const Text(
                "Attachments",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(report["attachment"] ?? "No Attachments"),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // background
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  child: const Text("CLOSE"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
