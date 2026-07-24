class DashboardRecommendation {
  final String title;
  final String saving;

  DashboardRecommendation({
    required this.title,
    required this.saving,
  });

  factory DashboardRecommendation.fromJson(Map<String, dynamic> json) {
    return DashboardRecommendation(
      title: json['title']?.toString() ?? 'Unknown',
      saving: json['saving']?.toString() ?? '0%',
    );
  }
}

class DashboardData {
  final double energyUsage;
  final String energyUnit;
  final int sustainabilityScore;
  final String prediction;
  final List<DashboardRecommendation> recommendations;
  final int campusHealthScore;
  final double co2Saved;
  final double costSaved;
  final int buildingsOnline;
  final int activeAlerts;
  final double predictionAccuracy;

  DashboardData({
    required this.energyUsage,
    required this.energyUnit,
    required this.sustainabilityScore,
    required this.prediction,
    required this.recommendations,
    required this.campusHealthScore,
    required this.co2Saved,
    required this.costSaved,
    required this.buildingsOnline,
    required this.activeAlerts,
    required this.predictionAccuracy,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final recsJson = json['recommendations'] as List<dynamic>? ?? [];
    return DashboardData(
      energyUsage: (json['energy_usage'] as num?)?.toDouble() ?? 0.0,
      energyUnit: json['energy_unit']?.toString() ?? 'kWh',
      sustainabilityScore: (json['sustainability_score'] as num?)?.toInt() ?? 0,
      prediction: json['prediction']?.toString() ?? 'Unknown',
      recommendations: recsJson
          .map((e) => DashboardRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      campusHealthScore: (json['campus_health_score'] as num?)?.toInt() ?? 0,
      co2Saved: (json['co2_saved'] as num?)?.toDouble() ?? 0.0,
      costSaved: (json['cost_saved'] as num?)?.toDouble() ?? 0.0,
      buildingsOnline: (json['buildings_online'] as num?)?.toInt() ?? 0,
      activeAlerts: (json['active_alerts'] as num?)?.toInt() ?? 0,
      predictionAccuracy: (json['prediction_accuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
