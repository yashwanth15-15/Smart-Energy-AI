import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/dashboard_service.dart';
import '../models/dashboard_model.dart';
import '../models/prediction_model.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

final dashboardFutureProvider = FutureProvider.autoDispose<DashboardModel>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  return await service.fetchDashboard();
});

final predictionFutureProvider = FutureProvider.autoDispose<PredictionModel>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  return await service.fetchPrediction();
});
