import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trash_crew/models/activity_model.dart';
import 'package:trash_crew/models/user_model.dart';
import 'package:trash_crew/models/schedule_model.dart'; // Ensure you have this model
import 'package:trash_crew/services/storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://pay1.jetdev.life';
  final StorageService _storageService = StorageService();

  // Login function
  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/account/login'),
        body: jsonEncode({'username': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);

        if (user.token != null) {
          await _storageService.saveToken(user.token!);
        }
        return user;
      } else {
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // Register function
  Future<bool> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/account/register'),
        body: jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

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
          'Authorization': 'Bearer YOUR_API_TOKEN', // Replace with actual token
        },
        body: json.encode(data),
      );

      // Check if the response was successful
      if (response.statusCode == 200) {
        print("Pickup Scheduled Successfully!");
        print("Response Body: ${response.body}");
      } else {
        print("Failed to schedule pickup: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during HTTP request: $e");
    }
  }

  Future<List<Activity>> fetchActivities() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/activities'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((activity) => Activity.fromJson(activity)).toList();
      } else {
        print('Error fetching activities: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error during fetching activities: $e');
      return [];
    }
  }
}



