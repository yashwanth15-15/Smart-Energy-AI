import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/models/dashboard_model.dart';
import 'package:frontend/repositories/dashboard_repository.dart';
import 'package:frontend/shared/widgets/kpi_card.dart';
import 'package:frontend/shared/widgets/loading_widget.dart';
import 'package:frontend/shared/widgets/error_display.dart';
import 'package:frontend/shared/widgets/section_header.dart';
import 'package:frontend/shared/widgets/fade_slide_animate.dart';
import 'package:frontend/shared/widgets/operational_timeline.dart';

// Provide just the dashboard data for this command center
final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final repo = DashboardRepository();
  return await repo.fetchDashboard();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F4),
      appBar: AppBar(
        title: const Text('Executive Command Center', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: dashboardAsync.when(
            data: (dashboard) => _buildCommandCenter(context, dashboard),
            loading: () => const LoadingWidget(),
            error: (e, _) => ErrorDisplay(message: e.toString()),
          ),
        ),
      ),
    );
  }

  Widget _buildCommandCenter(BuildContext context, DashboardData dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ROW 1: Status Bar
        _StatusBar(dashboard: dashboard),
        const SizedBox(height: 24),
        
        // ROW 2: Operational Timeline
        const SectionHeader(title: 'Recent Activity'),
        const SizedBox(height: 16),
        const OperationalTimeline(maxEvents: 4),
        const SizedBox(height: 24),

        // ROW 3: KPI Grid
        const SectionHeader(title: 'Key Performance Indicators'),
        const SizedBox(height: 16),
        _KpiGrid(dashboard: dashboard),
        const SizedBox(height: 24),

        // ROW 3: AI Recommendation
        const SectionHeader(title: 'Autonomous AI Directives'),
        const SizedBox(height: 16),
        _LargeAiCard(dashboard: dashboard),
        const SizedBox(height: 24),

        // ROW 4: Mini Charts
        const SectionHeader(title: 'Real-Time Analytics'),
        const SizedBox(height: 16),
        _MiniChartsRow(dashboard: dashboard),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ---------------------------------------------------------
// Row 1: Status Bar
// ---------------------------------------------------------
class _StatusBar extends StatelessWidget {
  final DashboardData dashboard;
  const _StatusBar({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormatted = DateFormat('MMM d, yyyy').format(now);
    final timeFormatted = DateFormat('HH:mm:ss').format(now);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: isDesktop 
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusItem(label: 'Campus Status', value: 'Operations Nominal', icon: Icons.security, color: Colors.blueGrey),
                _StatusItem(label: 'Live Time', value: '$dateFormatted • $timeFormatted', icon: Icons.access_time, color: Colors.grey),
                _StatusItem(label: 'System Health', value: 'Online (${dashboard.campusHealthScore}/100)', icon: Icons.check_circle, color: Colors.green),
                _StatusItem(label: 'Active Alerts', value: '${dashboard.activeAlerts} Alerts', icon: Icons.warning_amber_rounded, color: dashboard.activeAlerts > 0 ? Colors.orange : Colors.grey),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatusItem(label: 'Status', value: 'Nominal', icon: Icons.security, color: Colors.blueGrey),
                    _StatusItem(label: 'Health', value: 'Online', icon: Icons.check_circle, color: Colors.green),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatusItem(label: 'Time', value: timeFormatted, icon: Icons.access_time, color: Colors.grey),
                    _StatusItem(label: 'Alerts', value: '${dashboard.activeAlerts}', icon: Icons.warning_amber, color: dashboard.activeAlerts > 0 ? Colors.orange : Colors.grey),
                  ],
                ),
              ],
            ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatusItem({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}

// ---------------------------------------------------------
// Row 2: KPI Grid
// ---------------------------------------------------------
class _KpiGrid extends StatelessWidget {
  final DashboardData dashboard;
  const _KpiGrid({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200 ? 4 : (width > 800 ? 3 : 2);
    
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        KpiCard(
          title: "Today's Energy",
          value: dashboard.energyUsage.toStringAsFixed(1),
          unit: dashboard.energyUnit,
          icon: Icons.bolt,
          statusText: 'vs Yesterday', trend: 'up', trendValue: '2.1%',
        ),
        KpiCard(
          title: 'Campus Health',
          value: dashboard.campusHealthScore.toString(),
          unit: '/100',
          icon: Icons.favorite,
          statusText: 'Excellent', trend: 'up', trendValue: '1.5%',
        ),
        KpiCard(
          title: 'Sustainability Score',
          value: dashboard.sustainabilityScore.toString(),
          unit: '/100',
          icon: Icons.eco,
          statusText: 'ESG Target Met', trend: 'neutral', trendValue: '0.0%',
        ),
        KpiCard(
          title: 'CO₂ Saved',
          value: dashboard.co2Saved.toStringAsFixed(1),
          unit: 'kg',
          icon: Icons.cloud,
          statusText: 'This Month', trend: 'up', trendValue: '12.4%',
        ),
        KpiCard(
          title: 'Cost Saved',
          value: dashboard.costSaved.toStringAsFixed(1),
          unit: '\$',
          icon: Icons.attach_money,
          statusText: 'This Month', trend: 'up', trendValue: '5.8%',
        ),
        KpiCard(
          title: 'Buildings Online',
          value: dashboard.buildingsOnline.toString(),
          unit: '',
          icon: Icons.business,
          statusText: 'All operational', trend: 'neutral', trendValue: '',
        ),
        KpiCard(
          title: 'Prediction Accuracy',
          value: dashboard.predictionAccuracy.toStringAsFixed(1),
          unit: '%',
          icon: Icons.check_circle_outline,
          statusText: 'Last 7 Days', trend: 'up', trendValue: '0.8%',
        ),
        const KpiCard(
          title: 'Renewable Energy',
          value: '15.2',
          unit: '%',
          icon: Icons.solar_power,
          statusText: 'Solar & Wind', trend: 'up', trendValue: '1.2%',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// Row 3: AI Recommendation Card
// ---------------------------------------------------------
class _LargeAiCard extends StatelessWidget {
  final DashboardData dashboard;
  const _LargeAiCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    if (dashboard.recommendations.isEmpty) return const SizedBox.shrink();
    
    final rec = dashboard.recommendations.first;
    return FadeSlideAnimate(
      child: Card(
        elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.psychology, color: Colors.white, size: 64),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI SYSTEM DIRECTIVE', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  Text(rec.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Estimated immediate savings: ${rec.saving}', style: const TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('EXECUTE DIRECTIVE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}

// ---------------------------------------------------------
// Row 4: Mini Charts
// ---------------------------------------------------------
class _MiniChartsRow extends StatelessWidget {
  final DashboardData dashboard;
  const _MiniChartsRow({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    
    final charts = [
      _ChartContainer(title: 'Hourly Energy (Last 7h)', child: _HourlyEnergyChart(dashboard: dashboard)),
      _ChartContainer(title: 'Alert Trend (7 Days)', child: _AlertTrendChart()),
      _ChartContainer(title: 'Load Distribution', child: _BuildingPieChart()),
    ];

    if (isDesktop) {
      return Row(
        children: charts.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16.0), child: c))).toList(),
      );
    } else {
      return Column(
        children: charts.map((c) => Padding(padding: const EdgeInsets.only(bottom: 16.0), child: c)).toList(),
      );
    }
  }
}

class _ChartContainer extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeSlideAnimate(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 16),
            SizedBox(height: 150, child: child),
          ],
        ),
      ),
    ),
    );
  }
}

// MOCK CHARTS FOR UI
class _HourlyEnergyChart extends StatelessWidget {
  final DashboardData dashboard;
  const _HourlyEnergyChart({required this.dashboard});
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(7, (i) => FlSpot(i.toDouble(), dashboard.energyUsage * (1 + (i*0.1)))),
            isCurved: true,
            color: const Color(0xFF2E7D32),
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertTrendChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: Colors.orange)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3, color: Colors.orange)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 7, color: Colors.orange)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 2, color: Colors.orange)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 4, color: Colors.orange)]),
        ],
      ),
    );
  }
}

class _BuildingPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 30,
        sections: [
          PieChartSectionData(value: 40, color: const Color(0xFF1B5E20), title: 'Eng', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
          PieChartSectionData(value: 30, color: const Color(0xFF2E7D32), title: 'Lib', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
          PieChartSectionData(value: 20, color: const Color(0xFF43A047), title: 'Host', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
          PieChartSectionData(value: 10, color: const Color(0xFF66BB6A), title: 'Oth', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
        ],
      ),
    );
  }
}
