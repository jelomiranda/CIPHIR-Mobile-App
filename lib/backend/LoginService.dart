import 'dart:convert';
import 'package:http/http.dart' as http;


// Global variable to store user data
Map<String, dynamic> currentUser = {};

class LoginService {
  static const String baseUrl =
      'https://darkgoldenrod-goose-321756.hostingersite.com';

  // Login method to authenticate users via the PHP endpoint
  Future<bool> login(String username, String password) async {
    final String url = '$baseUrl/login.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          // Store the user data in the global variable
          currentUser = {
            'username': jsonResponse['username'],
            'fullname': jsonResponse['fullname'],
            'address': jsonResponse['address'],
            'contactNumber': jsonResponse['contactNumber'],
            'resident_id': jsonResponse['resident_id'],
          };

          print("currentuser: ${currentUser}");
          return true; // Login successful
        } else {
          clearCurrentUser();
          return false; // Login failed
        }
      } else {
        throw Exception('Failed to login.');
      }
    } catch (e) {
      print('Error occurred during login: $e');
      clearCurrentUser();
      return false;
    }
  }

  // Method to update user information
  Future<bool> updateUserInfo(Map<String, dynamic> updatedInfo) async {
    final String url =
        '$baseUrl/update_user.php'; // Assuming you have this endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedInfo),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          // Update the currentUser with new information
          currentUser.addAll(updatedInfo);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error occurred during user info update: $e');
      return false;
    }
  }

  // Method to change password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final String url =
        '$baseUrl/change_password.php'; // Assuming you have this endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': currentUser['username'],
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error occurred during password change: $e');
      return false;
    }
  }
}

// Global functions to access and modify currentUser
Map<String, dynamic> getCurrentUser() {
  return Map.from(currentUser); // Return a copy to prevent direct modification
}

void clearCurrentUser() {
  currentUser.clear();
}

void updateCurrentUser(Map<String, dynamic> updatedUser) {
  currentUser.addAll(updatedUser);
}
