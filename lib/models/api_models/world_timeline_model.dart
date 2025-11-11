class Activity {
  final String id;
  final String description;
  final DateTime createdAt;

  Activity({
    required this.id,
    required this.description,
    required this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'],
      description: json['description'] ?? 'No description',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
