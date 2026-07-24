class BuildingStatus {
  final String name;
  final double energyUsage;
  final String energyUnit;
  final int occupancy;
  final double temperature;
  final double co2Emissions;
  final String alertStatus;
  final String hvacStatus;
  final String health;
  final int efficiencyScore;

  BuildingStatus({
    required this.name,
    required this.energyUsage,
    required this.energyUnit,
    required this.occupancy,
    required this.temperature,
    required this.co2Emissions,
    required this.alertStatus,
    required this.hvacStatus,
    required this.health,
    required this.efficiencyScore,
  });

  factory BuildingStatus.fromJson(Map<String, dynamic> json) {
    return BuildingStatus(
      name: json['name']?.toString() ?? 'Unknown',
      energyUsage: (json['latest_energy'] as num?)?.toDouble() ?? 0.0,
      energyUnit: json['energy_unit']?.toString() ?? 'kWh',
      occupancy: (json['occupancy'] as num?)?.toInt() ?? 0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      co2Emissions: (json['co2_emissions'] as num?)?.toDouble() ?? 0.0,
      alertStatus: json['status']?.toString() ?? 'Normal',
      hvacStatus: json['hvac_status']?.toString() ?? 'OFF',
      health: json['health']?.toString() ?? 'Good',
      efficiencyScore: (json['efficiency_score'] as num?)?.toInt() ?? 85,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'latest_energy': energyUsage,
        'energy_unit': energyUnit,
        'occupancy': occupancy,
        'temperature': temperature,
        'co2_emissions': co2Emissions,
        'status': alertStatus,
        'hvac_status': hvacStatus,
        'health': health,
        'efficiency_score': efficiencyScore,
      };
}
