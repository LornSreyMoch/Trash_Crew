import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trash_crew/models/activity_model.dart';
import 'package:trash_crew/models/point_model.dart';

import 'package:trash_crew/models/schedule_model.dart';
import 'package:trash_crew/models/user_model.dart';
import 'package:trash_crew/services/storage_service.dart';
import 'package:trash_crew/models/point_model.dart';

class ApiService {
  static const String baseUrl = 'https://pay1.jetdev.life';
  final StorageService _storageService = StorageService();

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
        throw Exception('Login failed: ${response.body}');

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

  // Future<PickupRequest?> schedulePickup(String data, String wasteTypes, String estimatedWeight) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/api/account/schedule'),
  //     body: jsonEncode({
  //       'date': data,
  //       'wasteTypes': [wasteTypes],
  //       'estimatedWeight': estimatedWeight,
  //     }),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //   if (response.statusCode == 200) {
  //     final pickup = PickupRequest.fromJson(jsonDecode(response.body));
  //     if (pickup.token != null) {
  //       await _storageService.saveToken(pickup.token!); // Save token
  //     }
  //     return pickup;
  //   }
  // }
  // Create new schedule
  Future<List<PickupRequest>>
    schedulePickup({
    int limit = 20,
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
      "wasteTypes": wasteTypes.isNotEmpty ? wasteTypes : [],
      "estimateWeight": estimateWeight,
      "recurring": recurring,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/pickup/schedule?limit=$limit'),
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
      throw Exception('Failed to create schedule');
    }
  }

  Future<List<Activity>> fetchActivities({int limit = 20}) async {
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }
  }
  
  // Fetch points
  Future<List<Points>> fetchPoints() async {
  try {
    // Replace with actual token retrieval method
      final token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNvcGhlYWtAZ21haWwuY29tIiwiZ2l2ZW5fbmFtZSI6InNvcGhlYWsiLCJzdWIiOiJhNjM0ZDBiMy02YzIzLTQ4ZGEtOTdhNy01ZTU4MTIxYzYyN2YiLCJpZCI6ImE2MzRkMGIzLTZjMjMtNDhkYS05N2E3LTVlNTgxMjFjNjI3ZiIsIm5iZiI6MTc0MzA0MjQwNCwiZXhwIjoxNzQzNjQ3MjA0LCJpYXQiOjE3NDMwNDI0MDQsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTI0NiIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTI0NiJ9.6Ws38D0BqI5Z9mFaAwYyDx5H7G4Mb9VfPrNLYoHHmrkkmuKLK8bQSD2jKTnY3PswRcXnNwtCknE9sZ64z9NTVg";

    if (token.isEmpty) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/account/points'), // Updated endpoint for user profile
      headers: {'Authorization': 'Bearer $token'},
    );

 
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
            print("------------ ${jsonResponse}");


      if (jsonResponse is List) {
        // Response is a list of users
        return jsonResponse.map((json) => Points.fromJson(json)).toList();
      } else if (jsonResponse is Map<String, dynamic>) {
        // Response is a single user object
        return [Points.fromJson(jsonResponse)];
      } else {
        throw Exception('Unexpected data format received');
      }
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching profile: $e');
    return [];
  }
}
}


    final response = await http.get(
      Uri.parse('$baseUrl/api/account/activity?limit=$limit'),
      headers: {'Authorization': 'Bearer $token'}, // Use token
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Activity.fromJson(json)).toList();
    }
    return [];
  }
}