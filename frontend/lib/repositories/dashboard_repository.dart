import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/dashboard_model.dart';
import 'package:frontend/models/building_status.dart';
import 'package:frontend/models/insight_model.dart';
import 'package:frontend/models/alert_model.dart';
import 'package:frontend/models/analytics_model.dart';
import 'package:frontend/models/prediction_model.dart';
import 'package:frontend/models/timeline_model.dart';

class DashboardRepository {
  final String baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  Future<DashboardData> fetchDashboard() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard'));
    if (response.statusCode == 200) {
      debugPrint('RAW JSON [/dashboard]: ${response.body}');
      final json = jsonDecode(response.body);
      return DashboardData.fromJson(json);
    }
    throw Exception('Failed to load dashboard');
  }

  Future<List<BuildingStatus>> fetchBuildings() async {
    final response = await http.get(Uri.parse('$baseUrl/buildings'));
    if (response.statusCode == 200) {
      debugPrint('RAW JSON [/buildings]: ${response.body}');
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => BuildingStatus.fromJson(e)).toList();
    }
    throw Exception('Failed to load buildings');
  }

  Future<InsightData> fetchInsights() async {
    final response = await http.get(Uri.parse('$baseUrl/insights'));
    if (response.statusCode == 200) {
      debugPrint('RAW JSON [/insights]: ${response.body}');
      final json = jsonDecode(response.body);
      return InsightData.fromJson(json);
    }
    throw Exception('Failed to load insights');
  }

  Future<List<AlertData>> fetchAlerts() async {
    final response = await http.get(Uri.parse('$baseUrl/alerts'));
    if (response.statusCode == 200) {
      debugPrint('RAW JSON [/alerts]: ${response.body}');
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => AlertData.fromJson(e)).toList();
    }
    throw Exception('Failed to load alerts');
  }

  Future<AnalyticsData> fetchAnalytics() async {
    final response = await http.get(Uri.parse('$baseUrl/analytics'));
    if (response.statusCode == 200) {
      debugPrint('RAW JSON [/analytics]: ${response.body}');
      final json = jsonDecode(response.body);
      return AnalyticsData.fromJson(json);
    }
    throw Exception('Failed to load analytics');
  }

  Future<PredictionData> fetchPrediction() async {
    final response = await http.get(Uri.parse('$baseUrl/prediction'));
    if (response.statusCode == 200) {
      debugPrint('RAW JSON [/prediction]: ${response.body}');
      final json = jsonDecode(response.body);
      return PredictionData.fromJson(json);
    }
    throw Exception('Failed to load prediction');
  }

  Future<TimelineData> fetchTimeline() async {
    final response = await http.get(Uri.parse('$baseUrl/timeline'));
    if (response.statusCode == 200) {
      debugPrint('RAW JSON [/timeline]: ${response.body}');
      final json = jsonDecode(response.body);
      return TimelineData.fromJson(json);
    }
    throw Exception('Failed to load timeline');
  }
}
