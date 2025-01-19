import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:ciphir_mobile/backend/data_service.dart';
import 'package:ciphir_mobile/backend/LoginService.dart';
import 'package:ciphir_mobile/screens/map_screen.dart';
import 'package:ciphir_mobile/screens/camera.dart'; // Import the Camera screen
import 'package:latlong2/latlong.dart';

class Report extends StatefulWidget {
  final String imagePath;

  const Report({required this.imagePath, Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  // Controllers
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _otherInfrastructureController =
      TextEditingController();

  // Hardcoded list of barangays
  final List<String> _barangays = [
    'Abella',
    'Bagumbayan Norte',
    'Bagumbayan Sur',
    'Balatas',
    'Calauag',
    'Cararayan',
    'Carolina',
    'Concepcion Grande',
    'Concepcion Pequeño',
    'Dayangdang',
    'Del Rosario',
    'Dinaga',
    'Igualdad Interior',
    'Lerma',
    'Liboton',
    'Mabolo',
    'Pacol',
    'Panicuason',
    'Peñafrancia',
    'Sabang',
    'San Felipe',
    'San Francisco (Pob.)',
    'San Isidro',
    'Santa Cruz',
    'Tabuco',
    'Tinago',
    'Triangulo',
  ];

  // Hardcoded severity levels
  final List<String> _severityLevels = ['Low', 'Medium', 'High'];

  // State Variables
  int? _selectedInfrastructure;
  int? _selectedIssue;
  String? _selectedBarangay; // Selected barangay
  String? _selectedSeverity; // Selected severity level
  bool _isOtherInfrastructure = false;
  String? _otherInfrastructureDescription;
  List<Map<String, dynamic>> _availableIssues = [];
  List<Map<String, dynamic>> _infrastructureTypes = [];
  LatLng? _selectedLocation;
  String _locationDescription = 'Tap to select a location';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    _fetchInfrastructureTypes();
  }

  Future<void> _fetchLocation() async {
    final location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _locationDescription = 'Location services are disabled.';
          });
        }
        return;
      }
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (mounted) {
          setState(() {
            _locationDescription = 'Location permissions are denied.';
          });
        }
        return;
      }
    }
    LocationData currentLocation = await location.getLocation();
    if (mounted) {
      setState(() {
        _selectedLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _locationDescription =
            'Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}';
      });
    }
  }

  Future<void> _fetchInfrastructureTypes() async {
    final response = await DataService.getInfrastructureTypes();
    if (mounted) {
      setState(() {
        _infrastructureTypes = response;
      });
    }
  }

  Future<void> _fetchIssuesForInfrastructure(int infrastructureId) async {
    final issues =
        await DataService.getIssuesForInfrastructure(infrastructureId);
    if (mounted) {
      setState(() {
        _availableIssues = issues;
        _selectedIssue = null;
        _isOtherInfrastructure = _infrastructureTypes.any((type) =>
            type['infrastructure_id'] == infrastructureId &&
            type['infrastructure_type'] == 'Others...');
      });
    }
  }

  Future<void> _openMap() async {
    final LatLng? selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          initialLocation: _selectedLocation ?? LatLng(13.7384, 123.6856),
        ),
      ),
    );
    if (selected != null) {
      setState(() {
        _selectedLocation = selected;
        _locationDescription =
            'Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}';
      });
    }
  }

  Future<void> _takePhoto() async {
    final imagePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Camera(),
      ),
    );
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<String?> _convertImageToBase64(File? imageFile) async {
    if (imageFile == null) return null;
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  void _submitReport() async {
    // Check for missing required fields
    if (_imageFile == null) {
      _showMissingFieldMessage("Photo");
      return;
    }
    if (_selectedInfrastructure == null) {
      _showMissingFieldMessage("Infrastructure Type");
      return;
    }
    if (_isOtherInfrastructure &&
        (_otherInfrastructureController.text.isEmpty)) {
      _showMissingFieldMessage("Other Infrastructure Type");
      return;
    }
    if (_selectedSeverity == null) {
      _showMissingFieldMessage("Severity Level");
      return;
    }
    if (_streetController.text.isEmpty) {
      _showMissingFieldMessage("Street");
      return;
    }
    if (_selectedBarangay == null) {
      _showMissingFieldMessage("Barangay");
      return;
    }
    if (_selectedLocation == null) {
      _showMissingFieldMessage("Location");
      return;
    }

    String? base64Image = await _convertImageToBase64(_imageFile);

    final data = {
      'resident_id': currentUser['resident_id'],
      'infrastructure_id': _selectedInfrastructure,
      'issue_id': _isOtherInfrastructure ? null : _selectedIssue,
      'severityLevel': _selectedSeverity,
      'description': _descriptionController.text,
      'latitude': _selectedLocation!.latitude.toString(),
      'longitude': _selectedLocation!.longitude.toString(),
      'street': _streetController.text,
      'barangay': _selectedBarangay,
      'reportPhoto': base64Image,
      'other_infrastructure':
          _isOtherInfrastructure ? _otherInfrastructureController.text : null,
    };

    try {
      final response = await DataService.submitReport(data);
      if (response['status'] == 'success') {
        Fluttertoast.showToast(
          msg: "Report successfully submitted!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushNamed(context, '/home');
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to submit report: ${response['message']}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error submitting report: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showMissingFieldMessage(String fieldName) {
    Fluttertoast.showToast(
      msg: "$fieldName is required.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report an Issue"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown<int>(
              label: "Select Infrastructure Type",
              value: _selectedInfrastructure,
              items: _infrastructureTypes,
              onChanged: (value) {
                setState(() {
                  _selectedInfrastructure = value;
                  _fetchIssuesForInfrastructure(value!);
                });
              },
              valueKey: 'infrastructure_id',
              displayKey: 'infrastructure_type',
            ),
            const SizedBox(height: 16),
            if (!_isOtherInfrastructure)
              _buildDropdown<int>(
                label: "Select Issue Type",
                value: _selectedIssue,
                items: _availableIssues,
                onChanged: (value) {
                  setState(() => _selectedIssue = value);
                },
                valueKey: 'issue_id',
                displayKey: 'issue_type',
              ),
            if (_isOtherInfrastructure)
              _buildTextField("Other Infrastructure Type",
                  _otherInfrastructureController, "Enter type"),
            const SizedBox(height: 16),
            _buildDropdown<String>(
              label: "Severity Level",
              value: _selectedSeverity,
              items: _severityLevels
                  .map((level) => {'value': level, 'display': level})
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedSeverity = value);
              },
              valueKey: 'value',
              displayKey: 'display',
            ),
            const SizedBox(height: 16),
            _buildTextField("Street", _streetController, "Enter street name"),
            const SizedBox(height: 16),
            _buildDropdown<String>(
              label: "Barangay",
              value: _selectedBarangay,
              items: _barangays
                  .map((barangay) => {'value': barangay, 'display': barangay})
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedBarangay = value);
              },
              valueKey: 'value',
              displayKey: 'display',
            ),
            const SizedBox(height: 16),
            _buildTextField(
                "Description", _descriptionController, "Describe the issue"),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _openMap,
              child: _buildLocationCard(),
            ),
            const SizedBox(height: 16),
            if (_imageFile != null) _buildImagePreview(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera),
                  label: const Text("Take Photo"),
                ),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Upload Photo"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitReport,
                child: const Text("Submit Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hint,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<Map<String, dynamic>> items,
    required ValueChanged<T?> onChanged,
    required String valueKey,
    required String displayKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item[valueKey] as T,
              child: Text(item[displayKey].toString()),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Select $label',
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _locationDescription,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.map),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Column(
      children: [
        Image.file(_imageFile!, height: 150, width: 150, fit: BoxFit.cover),
        Text(path.basename(_imageFile!.path)),
      ],
    );
  }
}
