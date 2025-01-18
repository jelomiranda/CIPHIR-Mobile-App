import 'dart:convert';
import 'package:http/http.dart' as http;

class DataService {
  static const String baseUrl =
      'https://darkgoldenrod-goose-321756.hostingersite.com';

  // Method to fetch infrastructure types
  static Future<List<Map<String, dynamic>>> getInfrastructureTypes() async {
    try {
      final String url = '$baseUrl/get_infrastructure_types.php';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data.map((item) => {
              'infrastructure_id': int.tryParse(item['infrastructure_id']) ?? 0,
              'infrastructure_type': item['infrastructure_type'] ?? '',
            }));
      } else {
        print('Failed to fetch infrastructure types: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching infrastructure types: $e');
      return [];
    }
  }

  // Method to fetch issues for a specific infrastructure type
  static Future<List<Map<String, dynamic>>> getIssuesForInfrastructure(
      int infrastructureId) async {
    try {
      final String url = '$baseUrl/get_issues_for_infrastructure.php';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'infrastructure_id': infrastructureId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data.map((item) => {
              'issue_id': int.tryParse(item['issue_id']) ?? 0,
              'issue_type': item['issue_type'] ?? '',
            }));
      } else {
        print('Failed to fetch issues: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching issues: $e');
      return [];
    }
  }

  // Method to fetch report history
  static Future<List<Map<String, dynamic>>> getReportHistory(
      int residentId) async {
    final String url = '$baseUrl/get_report_history.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'resident_id': residentId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          print('Failed to fetch report history: ${responseData['message']}');
          return [];
        }
      } else {
        print(
            'Failed to fetch report history. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching report history: $e');
      return [];
    }
  }

  // Method to submit a report
  static Future<Map<String, dynamic>> submitReport(
      Map<String, dynamic> data) async {
    final String url = '$baseUrl/report_issue.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        return result;
      } else {
        print('Failed to submit report. Response: ${response.body}');
        return {"status": "error", "message": response.body};
      }
    } catch (e) {
      print('Error submitting report: $e');
      return {"status": "error", "message": e.toString()};
    }
  }

  // Method to fetch notifications for a resident
  static Future<List<Map<String, dynamic>>> getNotifications(
      int residentId) async {
    final String url = '$baseUrl/get_notifications.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'resident_id': residentId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          throw Exception(
              'Failed to fetch notifications: ${responseData['message']}');
        }
      } else {
        throw Exception(
            'Failed to fetch notifications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  // Method to mark a notification as read
  static Future<Map<String, dynamic>> markNotificationAsRead(
      int notificationId) async {
    final String url = '$baseUrl/mark_notification_as_read.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'notification_id': notificationId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        return result;
      } else {
        print(
            'Failed to mark notification as read. Response: ${response.body}');
        return {"status": "error", "message": response.body};
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      return {"status": "error", "message": e.toString()};
    }
  }
}
