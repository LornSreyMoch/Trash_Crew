import 'package:trash_crew/models/point_model.dart';
import 'package:trash_crew/services/api_service.dart';

class PointController {
  final ApiService _apiService = ApiService();

Future<List<Points>> fetchPoints() {
    return _apiService.fetchPoints();
  }
}