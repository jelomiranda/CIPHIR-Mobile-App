import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isEditing = false; // Track whether the user is in edit mode
  final TextEditingController _nameController =
      TextEditingController(text: 'Jelo Miranda');
  final TextEditingController _addressController =
      TextEditingController(text: 'Sta Cruz Proper St., Sta Cruz, Naga City');
  final TextEditingController _contactController =
      TextEditingController(text: '0919332502');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Back button functionality
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/ciphir_logo2.png',
                  height: 150, // Ensure full logo height
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 5),
              const Divider(thickness: 1),
              const SizedBox(height: 20), // Add space between logo and title

              const Text(
                'USER INFORMATION',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF243464), // Dark Blue Color
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center aligns the content
                    children: [
                      // Profile Icon
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      // Profile Information
                      const Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildInfoRow('Username:', 'jelmir13', false),
                      buildEditableInfoRow('Name:', _nameController),
                      buildEditableInfoRow('Address:', _addressController,
                          isMultiline: true), // Multiline address field
                      buildEditableInfoRow('Contact No.:', _contactController),
                      const SizedBox(height: 20),

                      // Buttons: Edit, Change Password, and Logout
                      buildActionButton(
                        label: _isEditing ? 'SAVE CHANGES' : 'EDIT',
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      buildActionButton(
                        label: 'CHANGE PASSWORD',
                        color: Colors.orange,
                        onPressed: () {
                          _showChangePasswordDialog(context);
                        },
                      ),
                      const SizedBox(height: 10),
                      buildActionButton(
                        label: 'LOGOUT',
                        color: Colors.red,
                        onPressed: () {
                          // Handle Logout action
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to create editable rows of information
  Widget buildEditableInfoRow(String label, TextEditingController controller,
      {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isEditing ? Colors.blue : Colors.transparent,
                  width: 0.8, // Adds a border to indicate the field is editable
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                controller: controller,
                enabled: _isEditing, // Enable the text field only in edit mode
                textAlign: TextAlign.end,
                maxLines:
                    isMultiline ? null : 1, // Support multiline if specified
                decoration: const InputDecoration(
                  border: InputBorder.none, // No internal border
                  contentPadding: EdgeInsets.all(8), // Adjust padding
                ),
                style: TextStyle(
                    fontSize: 16,
                    color: _isEditing ? Colors.black : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to create rows of uneditable information (like Username)
  Widget buildInfoRow(String label, String value, bool editable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // Button Builder for Edit, Change Password, and Logout
  Widget buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Dialog for changing the password
  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController _oldPasswordController =
        TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text("Change Password"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Save"),
              onPressed: () {
                // Handle password change logic
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
