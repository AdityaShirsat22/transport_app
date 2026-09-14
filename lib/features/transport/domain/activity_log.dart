class ActivityLog {
  final String id;
  final String transportId;
  final String title;
  final String description;
  final String performedBy;
  final DateTime timestamp;

  const ActivityLog({
    required this.id,
    required this.transportId,
    required this.title,
    required this.description,
    this.performedBy = 'Super Admin',
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transportId': transportId,
      'title': title,
      'description': description,
      'performedBy': performedBy,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String,
      transportId: json['transportId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      performedBy: json['performedBy'] as String? ?? 'Super Admin',
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
