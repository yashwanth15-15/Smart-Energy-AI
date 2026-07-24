class TimelineEvent {
  final String id;
  final DateTime timestamp;
  final String title;
  final String description;
  final String severity;

  TimelineEvent({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.severity,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      id: json['id']?.toString() ?? '',
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ?? DateTime.now(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      severity: json['severity']?.toString() ?? 'info',
    );
  }
}

class TimelineData {
  final List<TimelineEvent> events;

  TimelineData({required this.events});

  factory TimelineData.fromJson(Map<String, dynamic> json) {
    final list = (json['events'] as List<dynamic>? ?? [])
        .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
        .toList();
    return TimelineData(events: list);
  }
}
