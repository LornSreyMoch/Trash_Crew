import 'package:trash_crew/models/schedule_model.dart';
import 'package:trash_crew/services/api_service.dart';

class SchedulePickupController {
  final ApiService _apiService = ApiService();


    Future<List<PickupRequest>> schedulePickup({
    required String userId,
    required String date,
    required List<String> wasteTypes,
    required double estimateWeight,
    required bool recurring,
  }) async {
    return await _apiService.schedulePickup(
      userId: userId,
      date: date,
      wasteTypes: wasteTypes.isNotEmpty ? wasteTypes : [],
      estimateWeight: estimateWeight,
      recurring: recurring,
    );
  }
}
