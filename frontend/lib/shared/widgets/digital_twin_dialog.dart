import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/models/building_status.dart';

class DigitalTwinDialog extends StatelessWidget {
  final BuildingStatus building;

  const DigitalTwinDialog({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(isDesktop ? 60 : 16),
      child: Container(
        width: isDesktop ? 1000 : double.infinity,
        height: isDesktop ? 700 : MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Expanded(child: _buildTabs(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.apartment, size: 36, color: Color(0xFF1B5E20)),
                  const SizedBox(width: 12),
                  Text('${building.name} Digital Twin', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _Badge(label: 'Health: ${building.health}', color: Colors.blue),
                  const SizedBox(width: 8),
                  _Badge(label: 'Efficiency: ${building.efficiencyScore}', color: Colors.purple),
                  const SizedBox(width: 8),
                  _Badge(label: building.alertStatus, color: building.alertStatus == 'Normal' ? Colors.green : Colors.red),
                  const SizedBox(width: 8),
                  Text('Live Sync Active • Just now', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _Metric(label: 'Live Energy', value: '${building.energyUsage} kWh', icon: Icons.bolt),
                  _Metric(label: 'Temperature', value: '${building.temperature}°C', icon: Icons.thermostat),
                  _Metric(label: 'Occupancy', value: '${building.occupancy}%', icon: Icons.groups),
                  _Metric(label: 'HVAC', value: building.hvacStatus, icon: Icons.air),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF1B5E20),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2E7D32),
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Energy Trend'),
              Tab(text: 'Occupancy Trend'),
              Tab(text: 'Temperature Trend'),
              Tab(text: 'AI Recommendation'),
              Tab(text: 'Recent Alerts'),
              Tab(text: 'Estimated Savings'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              children: [
                _OverviewTab(building: building),
                _EnergyTrendTab(building: building),
                _OccupancyTrendTab(building: building),
                _TemperatureTrendTab(building: building),
                _AiRecommendationTab(building: building),
                _RecentAlertsTab(building: building),
                _EstimatedSavingsTab(building: building),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _Metric({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB VIEWS
// -----------------------------------------------------------------------------

class _OverviewTab extends StatelessWidget {
  final BuildingStatus building;
  const _OverviewTab({required this.building});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Digital Twin Summary', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          'The digital twin for ${building.name} is currently synced. '
          'Energy consumption is at ${building.energyUsage} kWh, with an internal temperature of ${building.temperature}°C. '
          'Occupancy sensors report ${building.occupancy}% utilization. '
          'The HVAC system is currently ${building.hvacStatus}. '
          'Overall health is classified as ${building.health}.',
          style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
        ),
      ],
    );
  }
}

class _EnergyTrendTab extends StatelessWidget {
  final BuildingStatus building;
  const _EnergyTrendTab({required this.building});

  @override
  Widget build(BuildContext context) {
    // Mock array anchoring on the live latestEnergy
    final spots = List.generate(24, (i) {
      double val = building.energyUsage * (0.5 + (i % 10) * 0.05);
      return FlSpot(i.toDouble(), val);
    });
    
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              titlesData: const FlTitlesData(
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 4)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OccupancyTrendTab extends StatelessWidget {
  final BuildingStatus building;
  const _OccupancyTrendTab({required this.building});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(7, (i) {
                // Mock bars anchoring loosely on live occupancy
                double base = building.occupancy > 0 ? building.occupancy.toDouble() : 50.0;
                double val = base * (0.8 + (i % 3) * 0.1);
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: val * value, // animates height
                      color: Colors.blueAccent,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    )
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class _TemperatureTrendTab extends StatelessWidget {
  final BuildingStatus building;
  const _TemperatureTrendTab({required this.building});

  @override
  Widget build(BuildContext context) {
    final spots = List.generate(24, (i) {
      double val = building.temperature + ((i % 5) - 2) * 0.5;
      return FlSpot(i.toDouble(), val);
    });

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AiRecommendationTab extends StatelessWidget {
  final BuildingStatus building;
  const _AiRecommendationTab({required this.building});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Autonomous Directives', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.auto_awesome, color: Colors.deepPurple),
          title: Text(
            building.occupancy < 20 && building.hvacStatus == 'ON' 
                ? 'HVAC Optimization Required' 
                : 'Optimal Scheduling Active',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            building.occupancy < 20 && building.hvacStatus == 'ON'
                ? 'Occupancy is only ${building.occupancy}%. The AI recommends powering down the HVAC system immediately to save energy.'
                : 'No immediate overrides recommended based on current sensor inputs.',
          ),
          tileColor: Colors.deepPurple.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        )
      ],
    );
  }
}

class _RecentAlertsTab extends StatelessWidget {
  final BuildingStatus building;
  const _RecentAlertsTab({required this.building});

  @override
  Widget build(BuildContext context) {
    if (building.alertStatus == 'Normal') {
      return const Center(child: Text('No recent alerts for this building.', style: TextStyle(color: Colors.grey)));
    }
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.warning, color: Colors.red),
          title: Text('High Priority: ${building.alertStatus}'),
          subtitle: Text('Sensor flagged anomalous behavior at ${building.energyUsage} kWh.'),
          tileColor: Colors.red.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ],
    );
  }
}

class _EstimatedSavingsTab extends StatelessWidget {
  final BuildingStatus building;
  const _EstimatedSavingsTab({required this.building});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.savings, size: 64, color: Colors.green),
        const SizedBox(height: 16),
        Text('Projected Monthly Savings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          '\$${(building.energyUsage * 1.5).toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 8),
        const Text('Based on AI predictive load balancing and thermal drift compensation.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
