import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/analytics_model.dart';
import 'package:frontend/repositories/dashboard_repository.dart';
import 'package:frontend/shared/widgets/kpi_card.dart';
import 'package:frontend/shared/widgets/loading_widget.dart';
import 'package:frontend/shared/widgets/error_display.dart';
import 'package:frontend/shared/widgets/chart_widgets.dart';
import 'package:frontend/services/export_service.dart';

final analyticsProvider = FutureProvider<AnalyticsData>((ref) async {
  final repo = DashboardRepository();
  return await repo.fetchAnalytics();
});

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncAnalytics = ref.watch(analyticsProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () {
              asyncAnalytics.whenData((data) {
                ExportService.generateAndPrintPdf(data);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            tooltip: 'Export Excel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel Export coming soon')));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(analyticsProvider.future),
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
          _KpiGrid(data: data),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.timeline), text: 'Energy Trends'),
                    Tab(icon: Icon(Icons.cloud_done), text: 'Carbon Savings'),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        EnergyLineChart(data: data.energyTrend),
                        CarbonBarChart(data: data.carbonTrend),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    final crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);
    
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.0,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        KpiCard(title: "Today's Energy", value: data.todayTotalEnergy.toStringAsFixed(1), unit: 'kWh', icon: Icons.bolt),
        KpiCard(title: "Weekly Energy", value: data.weeklyTotalEnergy.toStringAsFixed(1), unit: 'kWh', icon: Icons.calendar_view_week),
        KpiCard(title: "Today's Cost", value: data.todayCost.toStringAsFixed(2), unit: '\$', icon: Icons.attach_money),
        KpiCard(title: "CO₂ Emissions", value: data.todayCo2.toStringAsFixed(1), unit: 'kg', icon: Icons.cloud),
      ],
    );
  }
}
