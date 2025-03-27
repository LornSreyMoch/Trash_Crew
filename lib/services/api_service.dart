import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trash_crew/models/activity_model.dart';
import 'package:trash_crew/models/point_model.dart';
import 'package:trash_crew/models/schedule_model.dart';
import 'package:trash_crew/models/user_model.dart';
import 'package:trash_crew/services/storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://pay1.jetdev.life';
  final StorageService _storageService = StorageService();

  // Login
  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/account/login'),
      body: jsonEncode({'username': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      if (user.token != null) {
        await _storageService.saveToken(user.token!); // Save token
      }
      return user;
    }
    return null;
  }

  // Register
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

  // Schedule Pickup
  Future<List<PickupRequest>> schedulePickup({
    required String userId,
    required String date,
    required List<String> wasteTypes,
    required double estimateWeight,
    required bool recurring,
  }) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final requestBody = {
      "userId": userId,
      "date": date,
      "wasteTypes": wasteTypes,
      "estimateWeight": estimateWeight,
      "recurring": recurring,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/pickup/schedule'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PickupRequest.fromJson(json)).toList();
    } else {
      throw Exception('Failed to create schedule: ${response.body}');
    }
  }

  // Fetch Activities
  Future<List<Activity>> fetchActivities({int limit = 20}) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/account/activity?limit=$limit'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load activities: ${response.body}');
    }
  }

  // Fetch Points
  Future<List<Points>> fetchPoints() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/account/points'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.map((json) => Points.fromJson(json)).toList();
      } else if (jsonResponse is Map<String, dynamic>) {
        return [Points.fromJson(jsonResponse)];
      } else {
        throw Exception('Unexpected data format received');
      }
    } else {
      throw Exception('Failed to load points: ${response.body}');
    }
  }
}