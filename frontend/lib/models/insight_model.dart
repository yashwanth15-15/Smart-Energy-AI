class InsightData {
  final String summary;
  final String forecast;
  final String recommendedAction;
  final String expectedSavingsKwh;
  final String expectedCostReduction;
  final String riskLevel;

  InsightData({
    required this.summary,
    required this.forecast,
    required this.recommendedAction,
    required this.expectedSavingsKwh,
    required this.expectedCostReduction,
    required this.riskLevel,
  });

  factory InsightData.fromJson(Map<String, dynamic> json) {
    return InsightData(
      summary: json['summary']?.toString() ?? '',
      forecast: json['forecast']?.toString() ?? '',
      recommendedAction: json['recommended_action']?.toString() ?? '',
      expectedSavingsKwh: json['expected_savings_kwh']?.toString() ?? '',
      expectedCostReduction: json['expected_cost_reduction']?.toString() ?? '',
      riskLevel: json['risk_level']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'forecast': forecast,
        'recommended_action': recommendedAction,
        'expected_savings_kwh': expectedSavingsKwh,
        'expected_cost_reduction': expectedCostReduction,
        'risk_level': riskLevel,
      };
}
