import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/alert_model.dart';
import 'package:frontend/repositories/dashboard_repository.dart';
import 'package:frontend/shared/widgets/alert_card.dart';
import 'package:frontend/shared/widgets/loading_widget.dart';
import 'package:frontend/shared/widgets/error_display.dart';
import 'package:frontend/shared/widgets/empty_state.dart';

final alertsProvider = FutureProvider<List<AlertData>>((ref) async {
  final repo = DashboardRepository();
  return await repo.fetchAlerts();
});

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(alertsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(alertsProvider),
          ),
        ],
      ),
      body: async.when(
        data: (alerts) {
          if (alerts.isEmpty) {
            return const EmptyState(message: 'There are no active alerts at this time. The campus grid is operating normally.');
          }
          // Sort newest first
          final sortedAlerts = List<AlertData>.from(alerts)
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
            
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(alertsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: sortedAlerts.length,
              itemBuilder: (context, index) {
                return AlertCard(alert: sortedAlerts[index]);
              },
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorDisplay(message: e.toString()),
      ),
    );
  }
}
