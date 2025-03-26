import 'package:trash_crew/models/activity_model.dart';
import 'package:trash_crew/services/api_service.dart';

class ActivityController {
  final ApiService _apiService = ApiService();

  Future<List<Activity>> fetchActivities() {
    return _apiService.fetchActivities();
  }
}
