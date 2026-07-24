import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/models/prediction_model.dart';
import 'package:frontend/repositories/dashboard_repository.dart';
import 'package:frontend/shared/widgets/loading_widget.dart';
import 'package:frontend/shared/widgets/error_display.dart';
import 'package:frontend/shared/widgets/kpi_card.dart';
import 'package:frontend/shared/widgets/fade_slide_animate.dart';

final predictionProvider = FutureProvider<PredictionData>((ref) async {
  final repo = DashboardRepository();
  return await repo.fetchPrediction();
});

class PredictionScreen extends ConsumerWidget {
  const PredictionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(predictionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Prediction Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(predictionProvider),
          ),
        ],
      ),
      body: asyncData.when(
        data: (data) => _buildContent(context, data),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorDisplay(message: e.toString()),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PredictionData data) {
    if (data.forecast.isEmpty) {
      return const Center(child: Text('No forecast data available.'));
    }

    // Calculate metrics
    double maxVal = 0;
    double minVal = double.infinity;
    double sum = 0;

    for (var point in data.forecast) {
      if (point.predictedUsage > maxVal) {
        maxVal = point.predictedUsage;
      }
      if (point.predictedUsage < minVal) {
        minVal = point.predictedUsage;
      }
      sum += point.predictedUsage;
    }
    double avg = sum / data.forecast.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metrics Grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  KpiCard(
                    title: 'Predicted Usage',
                    value: data.predictedEnergyUsage.toStringAsFixed(1),
                    unit: 'kWh',
                    icon: Icons.bolt,
                  ),
                  KpiCard(
                    title: 'Peak Hour',
                    value: data.peakDemandHour,
                    unit: '',
                    icon: Icons.access_time,
                  ),
                  KpiCard(
                    title: 'AI Confidence',
                    value: data.confidencePercent.toStringAsFixed(1),
                    unit: '%',
                    icon: Icons.psychology,
                  ),
                  KpiCard(
                    title: 'Est. Savings',
                    value: data.estimatedSavings,
                    unit: '',
                    icon: Icons.recycling,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Card(
            color: const Color(0xFFF4F9F4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFF66BB6A), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 8),
                      Text('AI Explanation', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(data.aiExplanation, style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '24 Hour Forecast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Chart
          FadeSlideAnimate(
            child: SizedBox(
              height: 280,
              child: Card(
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: (maxVal / 5).ceilToDouble(),
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.grey.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 3,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              meta: meta,
                              child: Text('${value.toInt()}:00', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    minX: 0,
                    maxX: 23,
                    minY: 0,
                    maxY: maxVal * 1.2,
                    lineBarsData: [
                      LineChartBarData(
                        spots: data.forecast.map((p) => FlSpot(p.hour.toDouble(), p.predictedUsage)).toList(),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: avg,
                          color: Colors.orange,
                          strokeWidth: 2,
                          dashArray: [5, 5],
                          label: HorizontalLineLabel(
                            show: true,
                            alignment: Alignment.topRight,
                            style: const TextStyle(color: Colors.orange, fontSize: 10),
                            labelResolver: (line) => 'Average: ${avg.toStringAsFixed(1)}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
