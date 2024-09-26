import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For using File

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? _image; // To store the captured image
  final ImagePicker _picker = ImagePicker();

  // Function to capture the image
  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path); // Storing the image in the _image variable
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // CIPHIR Logo (Centered)
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/ciphir_logo1.png', // Replace with your logo path
                    height: 80,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          const Spacer(), // Pushes content towards the center

          // Framing for the picture or display the captured photo
          _image == null
              ? Container(
                  height: 400,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Frame color
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Tap the button below to take a photo.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Image.file(
                  _image!, // Display the captured image
                  height: 350,
                  width: 250,
                  fit: BoxFit.cover,
                ),

          const Spacer(), // Pushes content towards the center

          // Button to take the photo
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: FloatingActionButton(
              onPressed: _takePhoto, // Opens the camera
              backgroundColor: Colors.red,
              child: Icon(Icons.camera_alt, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
