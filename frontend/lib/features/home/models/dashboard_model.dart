class Recommendation {
  final String title;
  final String saving;

  Recommendation({required this.title, required this.saving});

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      title: json['title'] as String? ?? '',
      saving: json['saving'] as String? ?? '',
    );
  }
}

class DashboardModel {
  final double energyUsage;
  final String energyUnit;
  final int sustainabilityScore;
  final String prediction;
  final List<Recommendation> recommendations;

  DashboardModel({
    required this.energyUsage,
    required this.energyUnit,
    required this.sustainabilityScore,
    required this.prediction,
    required this.recommendations,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    var recList = json['recommendations'] as List? ?? [];
    return DashboardModel(
      energyUsage: (json['energy_usage'] as num?)?.toDouble() ?? 0.0,
      energyUnit: json['energy_unit'] as String? ?? '',
      sustainabilityScore: json['sustainability_score'] as int? ?? 0,
      prediction: json['prediction'] as String? ?? '',
      recommendations: recList.map((e) => Recommendation.fromJson(e)).toList(),
    );
  }
}
