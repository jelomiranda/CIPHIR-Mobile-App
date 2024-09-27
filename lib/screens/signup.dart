import 'package:ciphir_mobile/utils/color_utils.dart';
import 'package:flutter/material.dart';

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

  bool _passwordsMatch = true; // Tracks if passwords match

  // Method to validate the form
  void _validateForm() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });

    if (_formKey.currentState?.validate() ?? false) {
      // Proceed with registration if all fields are valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Successfully registered!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey, // Attach form key for validation
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 100), // Adds spacing before logo

                        // Logo
                        Center(
                          child: Image.asset(
                            'assets/images/ciphir_logo1.png',
                            height: 180,
                            width: 380, // Adjust according to your logo's size
                          ),
                        ),
                        const SizedBox(height: 30), // Adds space after logo

                        // Title
                        const Text(
                          "FILL OUT THE FOLLOWING DETAILS:",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),

                        const SizedBox(
                            height: 20), // Adds space before input fields

                        // Input Fields
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
                          keyboardType: TextInputType
                              .phone, // Brings up the numeric keypad
                          validator: (value) => value!.isEmpty
                              ? "Contact Number is required"
                              : null,
                        ),

                        // Password field
                        InputField(
                          label: "Password",
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) =>
                              value!.isEmpty ? "Password is required" : null,
                        ),

                        // Confirm Password field
                        InputField(
                          label: "Confirm Password",
                          controller: _confirmPasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Confirm Password is required";
                            }
                            return _passwordsMatch
                                ? null
                                : "Passwords do not match";
                          },
                        ),

                        const SizedBox(height: 30), // Space before the button

                        // Register Button
                        Center(
                          child: MaterialButton(
                            minWidth: 150,
                            height: 53,
                            onPressed: _validateForm, // Validation on click
                            color: hexStringToColor("243464"),
                            elevation: 9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(), // This spacer will push the content up if there is extra space
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget for input fields.
class InputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator; // Validator function
  final TextInputType? keyboardType; // Added for numeric keypad

  const InputField({
    required this.label,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType, // Use the passed keyboard type
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 0, horizontal: 10), // Padding inside the text field
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: validator, // Attach validator for each input field
      ),
    );
  }
}
