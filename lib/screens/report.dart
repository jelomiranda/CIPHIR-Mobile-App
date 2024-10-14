import 'package:flutter/material.dart';
import 'dart:io'; // For handling File
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding JSON
import 'package:ciphir_mobile/backend/LoginService.dart';



class Report extends StatefulWidget {
  final String? imagePath; // Add the image path from the camera

  const Report({Key? key, this.imagePath}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
 @override


  TextEditingController _descriptionController = TextEditingController();
  String? _selectedIssueType;
  String? _selectedInfrastructureType;
  String _location = 'Choose location on the map...';

  int? _selectedIssueId;
  int? _selectedInfrastructureId;

  List<Map<String, dynamic>> issueTypes = [
    {'id': 1, 'type': 'Pothole'},
    {'id': 2, 'type': 'Cracked Pavement'},
    {'id': 3, 'type': 'Flooding'},
    {'id': 4, 'type': 'Faded Lane Marking'},
    {'id': 5, 'type': 'Broken or Damaged Signage'}
  ];

  List<Map<String, dynamic>> infrastructureTypes = [
    {'id': 1, 'type': 'Roads'},
    {'id': 2, 'type': 'Railways'},
    {'id': 3, 'type': 'Public Transit System'},
    {'id': 4, 'type': 'Electric Grids'},
    {'id': 5, 'type': 'Pipelines'}
  ];

  String? _imagePath; // Create a new mutable variable for imagePath

  @override
  void initState() {
    super.initState();
     print("Current User Data: ${currentUser.toString()}");
    _imagePath = widget.imagePath; // Initialize the imagePath
  }

  // Function to submit the form data
  Future<void> submitForm() async {
    // Check if all fields are filled in
    if (_selectedIssueId == null || _selectedInfrastructureId == null || _descriptionController.text.isEmpty || _location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all the fields")));
      return;
    }

    // Prepare the form data
    Map<String, dynamic> formData = {
      'resident_id': currentUser['resident_id'], // Placeholder for the current logged-in resident ID
      'issue_id': _selectedIssueId,
      'infrastructure_id': _selectedInfrastructureId,
      'description': _descriptionController.text,
      'reportDateTime': DateTime.now().toIso8601String(),
      'reportPhoto': _imagePath != null ? File(_imagePath!).path.split('/').last : '', // Example file path processing
      'reportLocation': _location,
      'reportStatus': 'Pending',
      'priorityLevel': 'Medium', // You can adjust this based on user input
    };

    try {
      var response = await http.post(
        Uri.parse('https://darkgoldenrod-goose-321756.hostingersite.com/report_issue.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Report submitted successfully")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to submit report")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error submitting report")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occurred: $e")));
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
              // Move the logo here instead of the AppBar
              Center(
                child: Image.asset(
                  'assets/images/ciphir_logo2.png',
                  height: 150, // Set height to 150 as per your requirement
                  fit: BoxFit.contain, // Ensures the image fits properly
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
              // Description Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
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
              // Attachments Section with updated style
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (_imagePath != null)
                      Row(
                        children: [
                          Image.file(
                            File(_imagePath!),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'IMG_492.jpg', // You can replace this with the actual file name
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              // Remove the attached image
                              setState(() {
                                _imagePath = null;
                              });
                            },
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Navigate to camera to add photo
                        Navigator.pushNamed(context, '/camera');
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Add Photo'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Dropdown for Infrastructure Type
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<Map<String, dynamic>>(
                  value: _selectedInfrastructureId != null
                      ? infrastructureTypes.firstWhere(
                          (element) => element['id'] == _selectedInfrastructureId,
                          orElse: () => infrastructureTypes[0],
                        )
                      : null,
                  hint: const Text('What type of infrastructure?'),
                  items: infrastructureTypes.map((Map<String, dynamic> type) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: type,
                      child: Text(type['type']),
                    );
                  }).toList(),
                  onChanged: (Map<String, dynamic>? value) {
                    setState(() {
                      _selectedInfrastructureType = value!['type'];
                      _selectedInfrastructureId = value['id'];
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true, // Adds more padding around the text
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ),
              const SizedBox(height: 20),
              // Dropdown for Issue Type
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<Map<String, dynamic>>(
                  value: _selectedIssueId != null
                      ? issueTypes.firstWhere(
                          (element) => element['id'] == _selectedIssueId,
                          orElse: () => issueTypes[0],
                        )
                      : null,
                  hint: const Text('What type of issue?'),
                  items: issueTypes.map((Map<String, dynamic> type) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: type,
                      child: Text(type['type']),
                    );
                  }).toList(),
                  onChanged: (Map<String, dynamic>? value) {
                    setState(() {
                      _selectedIssueType = value!['type'];
                      _selectedIssueId = value['id'];
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ),
              const SizedBox(height: 20),
              // Location Field
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
                  // Open a map or location picker (You need to implement this separately)
                },
              ),
              const SizedBox(height: 20),
              // Map Placeholder (You would use a Google Map plugin here)
              Image.asset(
                'assets/images/map_placeholder.png', // Dummy image for a map
                height: 200,
              ),
              const SizedBox(height: 20),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the submission logic here
                    submitForm(); // Call the submit form function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
