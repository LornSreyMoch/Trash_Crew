import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trash_crew/models/history_model.dart';
import 'package:trash_crew/services/storage_service.dart';

class PickupHistoryController {
  static const String apiUrl = "https://pay1.jetdev.life/api/pickup/history";
  final StorageService _storageService = StorageService();

  static Future<List<ScheduledPickup>> fetchScheduledPickups() async {
    try {
      final token = await StorageService().getToken(); // Retrieve token
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include token in headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ScheduledPickup.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching pickups: $e");
    }
  }
}