import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For handling files
import 'report.dart'; // Import your Report class

class Camera extends StatefulWidget {
  const Camera({super.key});

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
      // After capturing the image, navigate to the Report screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Report(imagePath: image.path), // Pass image path to Report
        ),
      );
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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

          // Displaying Photo Guidelines
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Photo Guidelines:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Ensure good lighting for clear visibility.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  '2. Capture the issue and its surrounding area for context.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  '3. Take photos from multiple angles, if possible.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  '4. Avoid reflections, glare, or obstructions in the photo.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  '5. Ensure the photo is not blurry or unclear.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Examples',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 20), // Spacing before the example photo

          // Displaying the Example Photo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset(
              'assets/images/sample_photo.jpg', // Replace with the path to your example image
              height: 300,
              fit: BoxFit.cover,
            ),
          ),

          const Spacer(),

          // "Tap the button" text
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: const Text(
              'Tap the button below to take a photo.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Button to take the photo
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: FloatingActionButton(
              onPressed: _takePhoto, // Opens the camera
              backgroundColor: Colors.red,
              child: const Icon(Icons.camera_alt, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
