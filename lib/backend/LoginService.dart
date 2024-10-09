import 'dart:convert'; // for JSON encoding and decoding
import 'package:http/http.dart' as http; // to make HTTP requests

class LoginService {
  // Login method to authenticate users via the PHP endpoint
  Future<bool> login(String username, String password) async {
    const String url =
        'https://darkgoldenrod-goose-321756.hostingersite.com/login.php'; // Replace with your endpoint

    try {
      // Send POST request with username and password
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username, // Sending 'username' now
          'password': password,
        }),
      );

      // Check the response status code and content
      if (response.statusCode == 200) {
        // Decode the JSON response from the server
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Check for successful login based on the status returned from PHP
        if (jsonResponse['status'] == 'success') {
          return true; // Login successful
        } else {
          return false; // Login failed
        }
      } else {
        // If server did not return a 200 OK response, throw an error.
        throw Exception('Failed to login.');
      }
    } catch (e) {
      // Handle any errors or exceptions
      print('Error occurred during login: $e');
      return false; // Return false if an error occurs
    }
  }
}
