class Points {
  final int totalPoints;
  final double cashEquivalent;

  Points({
    required this.totalPoints,
    required this.cashEquivalent,
  });

  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(
      totalPoints: json['totalPoints'],
      cashEquivalent: (json['cashEquivalent'] as num ).toDouble(),
    );
  } 

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'cashEquivalent': cashEquivalent,
    };
  }
}