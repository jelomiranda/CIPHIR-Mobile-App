import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ciphir_mobile/backend/data_service.dart'; // Import the infrastructure and issue lists
import 'package:ciphir_mobile/backend/LoginService.dart'; // For accessing currentUser

class Report extends StatefulWidget {
  final String? imagePath;

  const Report({Key? key, this.imagePath}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController _descriptionController = TextEditingController();
  String? _selectedInfrastructure;
  int? _selectedIssue;
  List<Map<String, dynamic>> _availableIssues = [];
  String _location = 'Choose location on the map...';
  File? _imageFile; // For the selected image

  @override
  void initState() {
    super.initState();
  }

  // Method to fetch issues when infrastructure is selected
  void _fetchIssuesForInfrastructure(int infrastructureId) {
    setState(() {
      _availableIssues = getIssuesForInfrastructure(infrastructureId);
      _selectedIssue = null; // Reset the issue when infrastructure changes
    });
  }

  // Method to take a photo using the camera
  Future<void> _takePhoto() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  // Convert the image to Base64
  Future<String?> _convertImageToBase64(File? imageFile) async {
    if (imageFile == null) return null;
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  // Method to submit the report
  void _submitReport() async {
    String? base64Image = await _convertImageToBase64(_imageFile);

    if (_selectedInfrastructure != null && _selectedIssue != null) {
      final data = {
        'resident_id': currentUser['resident_id'],
        'infrastructure_id': int.parse(_selectedInfrastructure!), // Convert to int
        'issue_id': _selectedIssue, // Already int
        'description': _descriptionController.text,
        'reportLocation': _location,
        'reportPhoto': base64Image, // Pass the base64 image if available
      };

      final response = await DataService.submitReport(data);

      if (response['status'] == 'success') {
        // Show the toast when the report is successfully submitted
        Fluttertoast.showToast(
          msg: "Report successfully submitted!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Navigate back to home.dart
        Navigator.pushNamed(context, '/home');
      } else {
        // Handle failure
        print('Failed to submit report');
      }
    } else {
      print('Please select infrastructure and issue type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/ciphir_logo2.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 5),
              const Divider(thickness: 1),
              const SizedBox(height: 20),
              const Text(
                'REPORT DETAILS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF243464),
                ),
              ),
              const Text(
                'Please provide information about the issue you want to report.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Description',
                    hintText: 'Tap here to write...',
                  ),
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Attachments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    if (_imageFile != null)
                      Row(
                        children: [
                          Image.file(
                            _imageFile!,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              path.basename(_imageFile!.path), // Show the file name
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _imageFile = null;
                              });
                            },
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _takePhoto,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Upload'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Dropdown for Infrastructure Type
              DropdownButtonFormField<String>(
                value: _selectedInfrastructure,
                hint: const Text('What type of infrastructure?'),
                items: infrastructureTypes.map((infrastructure) {
                  return DropdownMenuItem<String>(
                    value: infrastructure['infrastructure_id'].toString(),
                    child: Text(infrastructure['infrastructure_type']),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedInfrastructure = value;
                    _fetchIssuesForInfrastructure(int.parse(value!));
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 20),
              // Dropdown for Issue Type
              DropdownButtonFormField<int>(
                value: _selectedIssue,
                hint: const Text('What type of issue?'),
                items: _availableIssues.map((issue) {
                  return DropdownMenuItem<int>(
                    value: issue['issue_id'],
                    child: Text(issue['issue_type']),
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    _selectedIssue = value;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Location',
                  suffixIcon: const Icon(Icons.location_on),
                  hintText: _location,
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onTap: () {
                  // Open a map or location picker (optional)
                },
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/map_placeholder.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('SUBMIT', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
