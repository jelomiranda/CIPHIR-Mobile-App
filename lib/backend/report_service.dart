import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

// This class handles image uploads and report submissions
class ReportService {
  // Upload image to Hostinger and return the path
  static Future<String?> uploadImage(File? imageFile) async {
    if (imageFile == null) return null;

    // Convert image to Base64
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Define the filename (you can use a timestamp or unique identifier)
    String filename = path.basename(imageFile.path);

    // Prepare the data to send to the PHP backend
    var data = {
      "image": base64Image,
      "filename": filename,
    };

    // Make POST request to upload image to the server
    var response = await http.post(
      Uri.parse(
          'https://darkgoldenrod-goose-321756.hostingersite.com/upload_image.php'),
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        // Return the path of the uploaded image
        return jsonResponse['path'];
      } else {
        print('Failed to upload image: ${jsonResponse['message']}');
        return null;
      }
    } else {
      print('Server error: ${response.statusCode}');
      return null;
    }
  }

  // Submit report with image path and location
  static Future<Map<String, dynamic>> submitReport(
      Map<String, dynamic> reportData) async {
    var response = await http.post(
      Uri.parse(
          'https://darkgoldenrod-goose-321756.hostingersite.com/report_issue.php'),
      body: jsonEncode(reportData),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to submit report. Server error: ${response.statusCode}');
      return {"status": "error"};
    }
  }
}
