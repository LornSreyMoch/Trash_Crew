import 'dart:convert'; // For JSON encoding
import 'package:http/http.dart' as http;
import 'package:trash_crew/models/schedule_model.dart';

class SchedulePickupController {
  // Example: Save data to a list (can connect to API later)
  List<SchedulePickup> pickups = [];

  // Add Pickup to list (can be saved to an API)
  void addPickup(SchedulePickup pickup) {
    pickups.add(pickup);
    print("Pickup Scheduled: ${pickup.toJson()}");

    // Call the API when adding a new pickup
    _postPickup(pickup);
  }

  // Method to send a POST request to the API
  Future<void> _postPickup(SchedulePickup pickup) async {
    const String url = 'https://pay1.jetdev.life/api/pickup/schedule'; 

    try {
      // Convert the pickup object to JSON
      final Map<String, dynamic> data = pickup.toJson();

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_TOKEN', // Replace with your actual token
        },
        body: json.encode(data),
      );

      // Check if the response was successful
      if (response.statusCode == 200) {
        print("Pickup Scheduled Successfully!");
      } else {
        print("Failed to schedule pickup: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during HTTP request: $e");
    }
  }
}
