import 'package:ciphir_mobile/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:ciphir_mobile/backend/SignupService.dart'; // Import the SignupService

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false; // Controls the visibility of the password
  bool _isConfirmPasswordVisible =
      false; // Controls visibility for confirm password
  bool _passwordsMatch = true; // Tracks if passwords match

  // Method to validate the form and call signup
  void _validateForm() async {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });

    if (_formKey.currentState?.validate() ?? false) {
      // Call the signup service to perform the signup
      bool success = await SignupService().signup(
        _usernameController.text,
        _fullNameController.text,
        _addressController.text,
        _contactNumberController.text,
        _passwordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Center(
              child: Text(
                'Successfully registered!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to register.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Form(
            key: _formKey, // Attach form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/ciphir_logo1.png',
                    height: 180,
                    width: 380, // Adjust according to your logo's size
                  ),
                ),
                const Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 54, 51, 51),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Together, we keep our city thriving!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(209, 151, 146, 146),
                  ),
                ),
                const SizedBox(height: 40),

                // Input Fields for Username, Full Name, Address, Contact Number, Password
                InputField(
                  label: "Username",
                  controller: _usernameController,
                  validator: (value) =>
                      value!.isEmpty ? "Username is required" : null,
                ),
                InputField(
                  label: "Full Name",
                  controller: _fullNameController,
                  validator: (value) =>
                      value!.isEmpty ? "Full Name is required" : null,
                ),
                InputField(
                  label: "Address",
                  controller: _addressController,
                  validator: (value) =>
                      value!.isEmpty ? "Address is required" : null,
                ),
                InputField(
                  label: "Contact Number",
                  controller: _contactNumberController,
                  keyboardType: TextInputType.phone, // Numeric keypad for phone
                  validator: (value) =>
                      value!.isEmpty ? "Contact Number is required" : null,
                ),
                InputField(
                  label: "Password",
                  controller: _passwordController,
                  obscureText:
                      !_isPasswordVisible, // Toggle password visibility
                  validator: (value) =>
                      value!.isEmpty ? "Password is required" : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),

                // Confirm Password field with visibility toggle
                InputField(
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible, // Toggle visibility
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Confirm Password is required";
                    }
                    return _passwordsMatch ? null : "Passwords do not match";
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Sign Up Button
                MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: _validateForm, // Validation on click
                  color: hexStringToColor("363333"), // Adjust the color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom InputField widget implementation goes here
class InputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator; // Validator function
  final TextInputType? keyboardType; // For numeric inputs
  final Widget?
      suffixIcon; // Optional suffix icon for password visibility toggle

  const InputField({
    required this.label,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.suffixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType, // Use the passed keyboard type
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 15), // Padding inside the text field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded input fields
            borderSide: const BorderSide(color: Colors.grey),
          ),
          suffixIcon:
              suffixIcon, // Add suffix icon if provided (for password visibility)
        ),
        validator: validator, // Attach validator for each input field
      ),
    );
  }
}
