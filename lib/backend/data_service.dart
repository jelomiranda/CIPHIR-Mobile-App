import 'dart:convert';
import 'package:http/http.dart' as http;

Map<int, List<Map<String, dynamic>>> infrastructureIssueMap = {
  1: [
    {"issue_id": 1, "issue_type": "Pothole"},
    {"issue_id": 2, "issue_type": "Cracked Pavement"},
    {"issue_id": 3, "issue_type": "Flooding"},
    {"issue_id": 4, "issue_type": "Faded Lane Marking"},
    {"issue_id": 5, "issue_type": "Broken or Damaged Signage"},
    {"issue_id": 6, "issue_type": "Malfunctioning Traffic Light"},
    {"issue_id": 7, "issue_type": "Dangerous Intersection"},
    {"issue_id": 8, "issue_type": "Loose or Missing Manhole Cover"},
    {"issue_id": 9, "issue_type": "Bridge or Overpass Deterioration"},
    {"issue_id": 10, "issue_type": "Illegal Parking"},
    {"issue_id": 11, "issue_type": "Speed Bumps"},
    {"issue_id": 12, "issue_type": "Traffic Congestion"},
  ],
  2: [
    {"issue_id": 13, "issue_type": "Track Defect"},
    {"issue_id": 14, "issue_type": "Signal Failure"},
    {"issue_id": 15, "issue_type": "Track Obstruction"},
    {"issue_id": 16, "issue_type": "Station Platform"},
  ],
  3: [
    {"issue_id": 17, "issue_type": "Delayed Transport"},
    {"issue_id": 18, "issue_type": "Broken Shelters"},
    {"issue_id": 19, "issue_type": "Faulty Ticketing"},
    {"issue_id": 20, "issue_type": "Overcrowding"},
    {"issue_id": 21, "issue_type": "Route Disruptions"},
  ],
  4: [
    {"issue_id": 22, "issue_type": "Power Outages"},
    {"issue_id": 23, "issue_type": "Flickering Lights"},
    {"issue_id": 24, "issue_type": "Exposed Wires"},
    {"issue_id": 25, "issue_type": "Transformer Issues"},
    {"issue_id": 26, "issue_type": "Downed Power Lines"},
    {"issue_id": 27, "issue_type": "Voltage Fluctuations"},
  ],
  5: [
    {"issue_id": 28, "issue_type": "Leaking Pipes"},
    {"issue_id": 29, "issue_type": "Corroded Pipes"},
    {"issue_id": 30, "issue_type": "Pipeline Blockages"},
    {"issue_id": 31, "issue_type": "Pipeline Bursts"},
  ],
  6: [
    {"issue_id": 32, "issue_type": "Blocked Sewers"},
    {"issue_id": 33, "issue_type": "Drainage Overflows"},
    {"issue_id": 34, "issue_type": "Broken Manholes"},
    {"issue_id": 35, "issue_type": "Foul Smells"},
    {"issue_id": 36, "issue_type": "Drainage Leakage"},
  ],
  7: [
    {"issue_id": 37, "issue_type": "Clogged Storm Drains"},
    {"issue_id": 38, "issue_type": "Erosion"},
    {"issue_id": 39, "issue_type": "Damaged Retention Ponds"},
    {"issue_id": 40, "issue_type": "Blocked Culverts"},
    {"issue_id": 41, "issue_type": "Flooded Areas"},
  ],
  8: [
    {"issue_id": 42, "issue_type": "Missed Waste Collection"},
    {"issue_id": 43, "issue_type": "Overflowing Dumpsters"},
    {"issue_id": 44, "issue_type": "Illegal Dumping"},
    {"issue_id": 45, "issue_type": "Damaged Vehicles"},
    {"issue_id": 46, "issue_type": "Hazardous Waste"},
  ],
  9: [
    {"issue_id": 47, "issue_type": "Damaged Playground Equipment"},
    {"issue_id": 48, "issue_type": "Overgrown Landscaping"},
    {"issue_id": 49, "issue_type": "Broken Park Benches"},
    {"issue_id": 50, "issue_type": "Vandalism"},
    {"issue_id": 51, "issue_type": "Park Flooding"},
  ],
};

// Function to get issues based on infrastructure type
List<Map<String, dynamic>> getIssuesForInfrastructure(int infrastructureId) {
  return infrastructureIssueMap[infrastructureId] ?? [];
}

// List of infrastructure types
List<Map<String, dynamic>> infrastructureTypes = [
  {"infrastructure_id": 1, "infrastructure_type": "Roads"},
  {"infrastructure_id": 2, "infrastructure_type": "Railways"},
  {"infrastructure_id": 3, "infrastructure_type": "Public Transit System"},
  {"infrastructure_id": 4, "infrastructure_type": "Electric Grids"},
  {"infrastructure_id": 5, "infrastructure_type": "Pipelines"},
  {"infrastructure_id": 6, "infrastructure_type": "Drainage System"},
  {"infrastructure_id": 7, "infrastructure_type": "Stormwater Management"},
  {"infrastructure_id": 8, "infrastructure_type": "Waste Management"},
  {"infrastructure_id": 9, "infrastructure_type": "Parks"},
];

// Submit report function (as needed)
class DataService {
  static const String baseUrl =
      'https://darkgoldenrod-goose-321756.hostingersite.com';

  static Future<Map<String, dynamic>> submitReport(
      Map<String, dynamic> data) async {
    final String url = '$baseUrl/report_issue.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit report');
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}
