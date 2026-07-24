class PredictionPoint {
  final int hour;
  final double predictedUsage;

  PredictionPoint({required this.hour, required this.predictedUsage});

  factory PredictionPoint.fromJson(Map<String, dynamic> json) {
    return PredictionPoint(
      hour: json['hour'] as int? ?? 0,
      predictedUsage: (json['predicted_usage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PredictionModel {
  final List<PredictionPoint> forecast;

  PredictionModel({required this.forecast});

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    var forecastList = json['forecast'] as List? ?? [];
    return PredictionModel(
      forecast: forecastList.map((e) => PredictionPoint.fromJson(e)).toList(),
    );
  }
}
