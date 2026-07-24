import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/analytics_model.dart';
import 'package:frontend/repositories/dashboard_repository.dart';
import 'package:frontend/shared/widgets/kpi_card.dart';
import 'package:frontend/shared/widgets/section_header.dart';
import 'package:frontend/shared/widgets/loading_widget.dart';
import 'package:frontend/shared/widgets/error_display.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/shared/widgets/fade_slide_animate.dart';

// Provider for analytics data
final analyticsProvider = FutureProvider<AnalyticsData>((ref) async {
  final repo = DashboardRepository();
  return await repo.fetchAnalytics();
});

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAnalytics = ref.watch(analyticsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(analyticsProvider),
        child: asyncAnalytics.when(
          data: (data) => _buildContent(context, data),
          loading: () => const LoadingWidget(),
          error: (e, _) => ErrorDisplay(message: e.toString()),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AnalyticsData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Grid
          _KpiGrid(data: data),
          const SizedBox(height: 24),
          // Daily Trend
          const SectionHeader(title: 'Daily Energy Trend (24h)'),
          const SizedBox(height: 16),
          _AnimatedTrendChart(
            baseline: data.todayTotalEnergy / 24,
            points: 24,
            intervalX: 4,
            labelX: 'Hour',
          ),
          const SizedBox(height: 24),
          // Weekly Trend
          const SectionHeader(title: 'Weekly Energy Trend (7d)'),
          const SizedBox(height: 16),
          _AnimatedTrendChart(
            baseline: data.weeklyTotalEnergy / 7,
            points: 7,
            intervalX: 1,
            labelX: 'Day',
          ),
          const SizedBox(height: 24),
          // Monthly Trend
          const SectionHeader(title: 'Monthly Energy Trend (30d)'),
          const SizedBox(height: 16),
          _AnimatedTrendChart(
            baseline: data.monthlyTotalEnergy / 30,
            points: 30,
            intervalX: 5,
            labelX: 'Date',
          ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  final AnalyticsData data;
  const _KpiGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 800 ? 3 : 2;
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        KpiCard(
          title: "Today's Energy",
          value: data.todayTotalEnergy.toStringAsFixed(1),
          unit: 'kWh',
          icon: Icons.bolt,
        ),
        KpiCard(
          title: "Weekly Energy",
          value: data.weeklyTotalEnergy.toStringAsFixed(1),
          unit: 'kWh',
          icon: Icons.calendar_view_week,
        ),
        KpiCard(
          title: "Monthly Energy",
          value: data.monthlyTotalEnergy.toStringAsFixed(1),
          unit: 'kWh',
          icon: Icons.calendar_month,
        ),
        KpiCard(
          title: "Today's Cost",
          value: data.todayCost.toStringAsFixed(2),
          unit: '₹',
          icon: Icons.attach_money,
        ),
        KpiCard(
          title: "CO₂ Emissions",
          value: data.todayCo2.toStringAsFixed(1),
          unit: 'kg',
          icon: Icons.cloud,
        ),
        KpiCard(
          title: "Campus Avg",
          value: data.campusAverageEnergy.toStringAsFixed(1),
          unit: 'kWh',
          icon: Icons.speed,
        ),
        KpiCard(
          title: "Highest Consuming",
          value: data.highestConsumingBuilding,
          unit: '',
          icon: Icons.trending_up,
        ),
        KpiCard(
          title: "Lowest Consuming",
          value: data.lowestConsumingBuilding,
          unit: '',
          icon: Icons.trending_down,
        ),
        KpiCard(
          title: "Active Alerts",
          value: data.totalActiveAlerts.toString(),
          unit: '',
          icon: Icons.notifications_active,
        ),
      ],
    );
  }
}

class _AnimatedTrendChart extends StatelessWidget {
  final double baseline;
  final int points;
  final double intervalX;
  final String labelX;

  const _AnimatedTrendChart({
    required this.baseline,
    required this.points,
    required this.intervalX,
    required this.labelX,
  });

  @override
  Widget build(BuildContext context) {
    // Generate realistic mock trend anchored on the live backend average
    final double safeBaseline = baseline > 0 ? baseline : 100.0;
    
    final spots = List.generate(points, (i) {
      double variance;
      if (points == 24) {
        if (i < 6) {
          variance = 0.4 + (i * 0.05);
        } else if (i < 10) {
          variance = 0.7 + ((i - 6) * 0.2);
        } else if (i < 18) {
          variance = 1.5 - ((i - 10) * 0.02);
        } else {
          variance = 1.3 - ((i - 18) * 0.15);
        }
      } else if (points == 7) {
        variance = (i == 5 || i == 6) ? 0.6 : 1.1 + (i % 2) * 0.1;
      } else {
        variance = ((i % 7) == 5 || (i % 7) == 6) ? 0.6 : 1.0 + ((i % 3) * 0.1);
      }
      return FlSpot(i.toDouble(), safeBaseline * variance);
    });

    final primaryColor = Theme.of(context).colorScheme.primary;

    return FadeSlideAnimate(
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 280,
        padding: const EdgeInsets.only(right: 24, left: 12, top: 24, bottom: 12),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: safeBaseline * 0.2,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1),
                    getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text(labelX, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: intervalX,
                        getTitlesWidget: (val, meta) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(val.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text('kWh', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withValues(alpha: 0.2))),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: primaryColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: points <= 10), // Show dots only if few points
                      belowBarData: BarAreaData(
                        show: true,
                        color: primaryColor.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
    );
  }
}
