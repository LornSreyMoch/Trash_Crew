class SchedulePickup {
  final String date;
  final String time;
  final List<String> wasteTypes;

  SchedulePickup({
    required this.date,
    required this.time,
    required this.wasteTypes,
  });

  // Implementing toJson() method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'wasteTypes': wasteTypes, // Waste types is a list
    };
  }

  // Optional: Factory constructor to create a SchedulePickup from JSON (useful for parsing API responses)
  factory SchedulePickup.fromJson(Map<String, dynamic> json) {
    return SchedulePickup(
      date: json['date'],
      time: json['date'].substring(11, 16), // Extracting time from date
      wasteTypes: List<String>.from(json['wasteTypes']),
    );
  }
}
