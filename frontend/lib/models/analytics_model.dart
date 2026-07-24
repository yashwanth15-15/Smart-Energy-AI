class AnalyticsData {
  final double todayTotalEnergy;
  final double weeklyTotalEnergy;
  final double monthlyTotalEnergy;
  final double todayCost;
  final double todayCo2;
  final double campusAverageEnergy;
  final String highestConsumingBuilding;
  final String lowestConsumingBuilding;
  final int totalActiveAlerts;

  AnalyticsData({
    required this.todayTotalEnergy,
    required this.weeklyTotalEnergy,
    required this.monthlyTotalEnergy,
    required this.todayCost,
    required this.todayCo2,
    required this.campusAverageEnergy,
    required this.highestConsumingBuilding,
    required this.lowestConsumingBuilding,
    required this.totalActiveAlerts,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      todayTotalEnergy: (json['todayTotalEnergy'] as num?)?.toDouble() ?? 0.0,
      weeklyTotalEnergy: (json['weeklyTotalEnergy'] as num?)?.toDouble() ?? 0.0,
      monthlyTotalEnergy: (json['monthlyTotalEnergy'] as num?)?.toDouble() ?? 0.0,
      todayCost: (json['todayCost'] as num?)?.toDouble() ?? 0.0,
      todayCo2: (json['todayCo2'] as num?)?.toDouble() ?? 0.0,
      campusAverageEnergy: (json['campusAverageEnergy'] as num?)?.toDouble() ?? 0.0,
      highestConsumingBuilding: json['highestConsumingBuilding']?.toString() ?? 'Unknown',
      lowestConsumingBuilding: json['lowestConsumingBuilding']?.toString() ?? 'Unknown',
      totalActiveAlerts: (json['totalActiveAlerts'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayTotalEnergy': todayTotalEnergy,
      'weeklyTotalEnergy': weeklyTotalEnergy,
      'monthlyTotalEnergy': monthlyTotalEnergy,
      'todayCost': todayCost,
      'todayCo2': todayCo2,
      'campusAverageEnergy': campusAverageEnergy,
      'highestConsumingBuilding': highestConsumingBuilding,
      'lowestConsumingBuilding': lowestConsumingBuilding,
      'totalActiveAlerts': totalActiveAlerts,
    };
  }
}
