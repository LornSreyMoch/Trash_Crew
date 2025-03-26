class Activity {
  final int id;
  final String userId;
  final String? user;
  final String title;
  final String description;
  final DateTime date;
  final DateTime createdAt;

  Activity({
    required this.id,
    required this.userId,
    this.user,
    required this.title,
    required this.description,
    required this.date,
    required this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      userId: json['userId'],
      user: json['user'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user': user,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
