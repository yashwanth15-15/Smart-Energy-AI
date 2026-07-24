class PredictionPoint {
  final int hour;
  final double predictedUsage;

  PredictionPoint({
    required this.hour,
    required this.predictedUsage,
  });

  factory PredictionPoint.fromJson(Map<String, dynamic> json) {
    return PredictionPoint(
      hour: json['hour'] as int? ?? 0,
      predictedUsage: (json['predicted_usage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PredictionData {
  final List<PredictionPoint> forecast;
  final String peakDemandHour;
  final double confidencePercent;
  final double predictedEnergyUsage;
  final String aiExplanation;
  final String estimatedSavings;

  PredictionData({
    required this.forecast,
    required this.peakDemandHour,
    required this.confidencePercent,
    required this.predictedEnergyUsage,
    required this.aiExplanation,
    required this.estimatedSavings,
  });

  factory PredictionData.fromJson(Map<String, dynamic> json) {
    final list = json['forecast'] as List<dynamic>? ?? [];
    return PredictionData(
      forecast: list.map((e) => PredictionPoint.fromJson(e as Map<String, dynamic>)).toList(),
      peakDemandHour: json['peak_demand_hour']?.toString() ?? '',
      confidencePercent: (json['confidence_percent'] as num?)?.toDouble() ?? 0.0,
      predictedEnergyUsage: (json['predicted_energy_usage'] as num?)?.toDouble() ?? 0.0,
      aiExplanation: json['ai_explanation']?.toString() ?? '',
      estimatedSavings: json['estimated_savings']?.toString() ?? '',
    );
  }
}
