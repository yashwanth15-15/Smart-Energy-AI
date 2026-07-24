import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/shared/widgets/loading_widget.dart';
import 'package:frontend/shared/widgets/error_display.dart';
import 'package:frontend/shared/widgets/insight_card.dart';
import 'package:frontend/repositories/dashboard_repository.dart';
import 'package:frontend/models/insight_model.dart';


final _insightsProvider = FutureProvider<InsightData>((ref) async {
  final repo = DashboardRepository();
  return await repo.fetchInsights();
});

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_insightsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: async.when(
        data: (insight) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              InsightCard(insight: insight),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorDisplay(message: e.toString()),
      ),
    );
  }
}
