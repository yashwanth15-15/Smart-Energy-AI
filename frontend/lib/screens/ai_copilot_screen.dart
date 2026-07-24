import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/dashboard_model.dart';
import 'package:frontend/models/prediction_model.dart';
import 'package:frontend/models/insight_model.dart';
import 'package:frontend/models/alert_model.dart';
import 'package:frontend/repositories/dashboard_repository.dart';
import 'package:frontend/shared/widgets/loading_widget.dart';
import 'package:frontend/shared/widgets/error_display.dart';
import 'package:frontend/shared/widgets/section_header.dart';
import 'package:frontend/shared/widgets/operational_timeline.dart';
import 'package:frontend/shared/widgets/chat_widget.dart';

class CopilotData {
  final DashboardData dashboard;
  final PredictionData prediction;
  final InsightData insight;
  final List<AlertData> alerts;

  CopilotData(this.dashboard, this.prediction, this.insight, this.alerts);
}

final copilotProvider = FutureProvider<CopilotData>((ref) async {
  final repo = DashboardRepository();
  final results = await Future.wait([
    repo.fetchDashboard(),
    repo.fetchPrediction(),
    repo.fetchInsights(),
    repo.fetchAlerts(),
  ]);
  
  return CopilotData(
    results[0] as DashboardData,
    results[1] as PredictionData,
    results[2] as InsightData,
    results[3] as List<AlertData>,
  );
});

class AiCopilotScreen extends ConsumerWidget {
  const AiCopilotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(copilotProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(copilotProvider),
        child: asyncData.when(
          data: (data) => LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                // Desktop Split Layout
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: _buildDashboardContent(context, data),
                        ),
                      ),
                      const SizedBox(width: 24),
                      const Expanded(
                        flex: 4,
                        child: ChatWidget(),
                      ),
                    ],
                  ),
                );
              } else {
                // Mobile/Tablet Layout
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDashboardContent(context, data),
                      const SizedBox(height: 24),
                      const SectionHeader(title: 'Ask AI Copilot'),
                      const SizedBox(height: 16),
                      const SizedBox(height: 600, child: ChatWidget()),
                    ],
                  ),
                );
              }
            }
          ),
          loading: () => const LoadingWidget(),
          error: (e, _) => ErrorDisplay(message: e.toString()),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, CopilotData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.psychology, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Text('AI Campus Copilot', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text('Real-time AI analysis of Smart Energy Campus', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700])),
        const SizedBox(height: 24),
        _CampusSummaryCard(data: data),
        const SizedBox(height: 16),
        _RiskAssessment(data: data),
        const SizedBox(height: 16),
        const OperationalTimeline(maxEvents: 3),
        const SizedBox(height: 16),
        _ExecutiveBriefing(data: data),
        const SizedBox(height: 16),
        _PredictionSummary(data: data),
      ],
    );
  }
}

class _CampusSummaryCard extends StatelessWidget {
  final CopilotData data;
  const _CampusSummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Text('Current Operational Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data.insight.summary,
              style: TextStyle(fontSize: 16, height: 1.5, color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskAssessment extends StatelessWidget {
  final CopilotData data;
  const _RiskAssessment({required this.data});

  @override
  Widget build(BuildContext context) {
    final health = data.dashboard.campusHealthScore;
    final alertsCount = data.dashboard.activeAlerts;
    final conf = data.prediction.confidencePercent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Live Risk Assessment'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _RiskChip(
              title: 'Campus Health',
              value: '$health/100',
              status: health > 80 ? 'Low Risk' : (health > 50 ? 'Medium Risk' : 'High Risk'),
              color: health > 80 ? Colors.green : (health > 50 ? Colors.orange : Colors.red),
            ),
            _RiskChip(
              title: 'Active Alerts',
              value: '$alertsCount',
              status: alertsCount == 0 ? 'Optimal' : (alertsCount < 3 ? 'Monitor' : 'Action Required'),
              color: alertsCount == 0 ? Colors.green : (alertsCount < 3 ? Colors.orange : Colors.red),
            ),
            _RiskChip(
              title: 'Prediction Confidence',
              value: '${conf.toStringAsFixed(1)}%',
              status: conf > 90 ? 'High' : (conf > 70 ? 'Moderate' : 'Low'),
              color: conf > 90 ? Colors.green : (conf > 70 ? Colors.orange : Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}

class _RiskChip extends StatelessWidget {
  final String title;
  final String value;
  final String status;
  final Color color;

  const _RiskChip({required this.title, required this.value, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              Icon(Icons.circle, color: color, size: 12),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ExecutiveBriefing extends StatelessWidget {
  final CopilotData data;
  const _ExecutiveBriefing({required this.data});

  @override
  Widget build(BuildContext context) {
    final insight = data.insight;
    
    Color riskColor = Colors.blue;
    if (insight.riskLevel.toLowerCase() == 'high') {
      riskColor = Colors.red;
    } else if (insight.riskLevel.toLowerCase() == 'medium') {
      riskColor = Colors.orange;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Executive Operational Briefing'),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('FORECAST', insight.forecast, Icons.timeline, Colors.blue),
                const Divider(height: 32),
                _buildSection('RECOMMENDED ACTION', insight.recommendedAction, Icons.lightbulb, Colors.orange),
                const Divider(height: 32),
                const Text('EXPECTED RESULT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 24,
                  runSpacing: 16,
                  children: [
                    _buildResultItem('Daily Savings', insight.expectedSavingsKwh),
                    _buildResultItem('Cost Reduction', insight.expectedCostReduction),
                    _buildResultItem('Risk Level', insight.riskLevel, color: riskColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
          ],
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 15, height: 1.4)),
      ],
    );
  }

  Widget _buildResultItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
      ],
    );
  }
}

class _PredictionSummary extends StatelessWidget {
  final CopilotData data;
  const _PredictionSummary({required this.data});

  @override
  Widget build(BuildContext context) {
    final pred = data.prediction;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Forward Outlook'),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 500;
            return GridView.count(
              crossAxisCount: isDesktop ? 2 : 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3.0,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _OutlookCard(title: 'Predicted Usage', value: '${pred.predictedEnergyUsage} kWh', icon: Icons.trending_up),
                _OutlookCard(title: 'Peak Demand', value: pred.peakDemandHour, icon: Icons.access_time),
                _OutlookCard(title: 'Estimated Savings', value: pred.estimatedSavings, icon: Icons.savings),
                _OutlookCard(title: 'Model Confidence', value: '${pred.confidencePercent}%', icon: Icons.verified_user),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _OutlookCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _OutlookCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
