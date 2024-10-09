import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  // Method to handle user signup
  Future<bool> signup(String username, String fullname, String address,
      String contactNumber, String password) async {
    const String url =
        'https://darkgoldenrod-goose-321756.hostingersite.com/signup.php'; // Replace with your endpoint

    try {
      // Send POST request with signup data
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'fullname': fullname,
          'address': address,
          'contactNumber': contactNumber,
          'password': password,
        }),
      );

      // Check the response status code and content
      if (response.statusCode == 200) {
        // Decode the JSON response from the server
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Check for successful signup based on the status returned from PHP
        if (jsonResponse['success'] == true) {
          return true; // Signup successful
        } else {
          return false; // Signup failed
        }
      } else {
        // If server did not return a 200 OK response, throw an error.
        throw Exception('Failed to sign up.');
      }
    } catch (e) {
      // Handle any errors or exceptions
      print('Error occurred during signup: $e');
      return false; // Return false if an error occurs
    }
  }
}
