import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../features/home/models/dashboard_model.dart';
import '../features/home/models/prediction_model.dart';

class DashboardService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    // Android emulator alias for host loopback, otherwise fallback to localhost
    return defaultTargetPlatform == TargetPlatform.android 
        ? 'http://10.0.2.2:8000' 
        : 'http://localhost:8000';
  }

  Future<DashboardModel> fetchDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      return DashboardModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load dashboard data: ${response.statusCode}');
    }
  }

  Future<PredictionModel> fetchPrediction() async {
    final response = await http.get(
      Uri.parse('$baseUrl/prediction'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      return PredictionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load prediction data: ${response.statusCode}');
    }
  }
}
