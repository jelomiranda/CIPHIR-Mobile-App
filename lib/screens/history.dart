import 'package:ciphir_mobile/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:ciphir_mobile/backend/data_service.dart';
import 'package:ciphir_mobile/backend/LoginService.dart'; // For accessing currentUser

class ReportHistory extends StatefulWidget {
  const ReportHistory({super.key});

  @override
  _ReportHistoryState createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {
  List<Map<String, dynamic>> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReportHistory();
  }

  // Fetch report history from the backend
  Future<void> _fetchReportHistory() async {
    try {
      // Safely ensure `resident_id` is an integer
      final residentId =
          int.tryParse(currentUser['resident_id'].toString()) ?? 0;

      if (residentId == 0) {
        throw Exception("Invalid resident_id");
      }

      print('Fetching reports for resident ID: $residentId'); // Debugging
      final fetchedReports = await DataService.getReportHistory(residentId);

      if (mounted) {
        setState(() {
          reports = fetchedReports.map((report) {
            return {
              'reportID': report['reportID'],
              'status': report['status'],
              'description': report['description'],
              'priorityLevel': report['priorityLevel'],
              'date': report['date'],
              'street': report['street'],
              'barangay': report['barangay'],
              'attachment': report['attachment'],
            };
          }).toList();
          isLoading = false;
        });
        print('Fetched reports: $reports'); // Debugging
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching report history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building ReportHistory Screen');
    print('Reports: $reports'); // Debugging

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
                "REPORT HISTORY",
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
                  : reports.isEmpty
                      ? const Center(
                          child: Text(
                            "No reports available.",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : Scrollbar(
                          thumbVisibility: true,
                          radius: const Radius.circular(10),
                          thickness: 1.5,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 40),
                            itemCount: reports.length,
                            itemBuilder: (context, index) {
                              final report = reports[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showReportDetails(
                                          context, report); // Show modal
                                    },
                                    child: _buildReportCard(
                                      context,
                                      report["status"] ?? "N/A",
                                      "Priority: ${report["priorityLevel"]}",
                                      report["date"] ?? "N/A",
                                    ),
                                  ),
                                  const SizedBox(height: 10),
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

  Widget _buildReportCard(
      BuildContext context, String status, String priority, String date) {
    IconData statusIcon;
    Color statusColor;

    if (status == "Resolved") {
      statusIcon = Icons.check_circle;
      statusColor = Colors.green;
    } else {
      statusIcon = Icons.pending;
      statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: hexStringToColor("eceeee"),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 25),
                const SizedBox(width: 10),
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
                    const SizedBox(height: 5),
                    Text(
                      priority,
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

  void _showReportDetails(BuildContext context, Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      isScrollControlled: true, // Allows the modal to resize based on content
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
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
                    Text(report["description"] ?? "N/A"),
                    const SizedBox(height: 20),
                    const Text(
                      "Date and Time",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(report["date"] ?? "N/A"),
                    const SizedBox(height: 20),
                    const Text(
                      "Priority Level",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(report["priorityLevel"] ?? "N/A"),
                    const SizedBox(height: 20),
                    const Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("${report["street"]}, ${report["barangay"]}"),
                    const SizedBox(height: 20),
                    const Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(report["status"] ?? "N/A"),
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
                          backgroundColor: Colors.red,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        child: const Text("CLOSE"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
