class AlertData {
  final String title;
  final String message;
  final String severity;
  final DateTime timestamp;
  final String recommendation;
  final String estimatedSavings;

  AlertData({
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    required this.recommendation,
    required this.estimatedSavings,
  });

  factory AlertData.fromJson(Map<String, dynamic> json) {
    return AlertData(
      title: json['title']?.toString() ?? 'Unknown',
      message: json['message']?.toString() ?? 'Unknown',
      severity: json['severity']?.toString() ?? 'Unknown',
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ?? DateTime.now(),
      recommendation: json['recommendation']?.toString() ?? '',
      estimatedSavings: json['estimated_savings']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        'severity': severity,
        'timestamp': timestamp.toIso8601String(),
        'recommendation': recommendation,
        'estimated_savings': estimatedSavings,
      };
}
