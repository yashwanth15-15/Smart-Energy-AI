import 'package:frontend/models/dashboard_model.dart';
import 'package:frontend/models/building_status.dart';
import 'package:frontend/models/insight_model.dart';
import 'package:frontend/models/alert_model.dart';
import 'package:frontend/models/analytics_model.dart';
import 'package:frontend/models/prediction_model.dart';
import 'package:frontend/models/timeline_model.dart';
import 'package:frontend/core/network/api_client.dart';

class DashboardRepository {
  Future<DashboardData> fetchDashboard() async {
    final response = await ApiClient.get('/dashboard');
    return DashboardData.fromJson(response);
  }

  Future<List<BuildingStatus>> fetchBuildings() async {
    final response = await ApiClient.get('/buildings');
    return (response as List).map((e) => BuildingStatus.fromJson(e)).toList();
  }

  Future<InsightData> fetchInsights() async {
    final response = await ApiClient.get('/insights');
    return InsightData.fromJson(response);
  }

  Future<List<AlertData>> fetchAlerts() async {
    final response = await ApiClient.get('/alerts');
    return (response as List).map((e) => AlertData.fromJson(e)).toList();
  }

  Future<AnalyticsData> fetchAnalytics() async {
    final response = await ApiClient.get('/analytics');
    return AnalyticsData.fromJson(response);
  }

  Future<PredictionData> fetchPrediction() async {
    final response = await ApiClient.get('/prediction');
    return PredictionData.fromJson(response);
  }

  Future<TimelineData> fetchTimeline() async {
    final response = await ApiClient.get('/timeline');
    return TimelineData.fromJson(response);
  }
}
