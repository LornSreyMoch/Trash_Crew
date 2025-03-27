// Model Class
class ScheduledPickup {
  final int pickupId;
  final DateTime date;
  final List<String> wasteTypes;
  final int estimateWeight;
  final String status;

  ScheduledPickup({
    required this.pickupId,
    required this.date,
    required this.wasteTypes,
    required this.estimateWeight,
    required this.status,
  });

  factory ScheduledPickup.fromJson(Map<String, dynamic> json) {
    return ScheduledPickup(
      pickupId: json['pickupId'],
      date: DateTime.parse(json['date']),
      wasteTypes: List<String>.from(json['wasteTypes']),
      estimateWeight: json['estimateWeight'],
      status: json['status'],
    );
  }
}