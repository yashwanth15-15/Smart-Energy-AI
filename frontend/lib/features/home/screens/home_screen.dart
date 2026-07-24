import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/dashboard_provider.dart';
import '../models/dashboard_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsyncValue = ref.watch(dashboardFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Energy AI Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(dashboardFutureProvider);
              ref.invalidate(predictionFutureProvider);
            },
          ),
        ],
      ),
      body: dashboardAsyncValue.when(
        data: (dashboardData) => _buildDashboard(context, dashboardData),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error loading dashboard:\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(dashboardFutureProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardModel data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeCard(context),
              const SizedBox(height: 16.0),
              isDesktop 
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildCurrentEnergyUsage(data)),
                      const SizedBox(width: 16.0),
                      Expanded(child: _buildSustainabilityScore(data)),
                    ],
                  )
                : Column(
                    children: [
                      _buildCurrentEnergyUsage(data),
                      const SizedBox(height: 16.0),
                      _buildSustainabilityScore(data),
                    ],
                  ),
              const SizedBox(height: 16.0),
              isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildEnergyPrediction(data)),
                      const SizedBox(width: 16.0),
                      Expanded(child: _buildAIRecommendations(data)),
                    ],
                  )
                : Column(
                    children: [
                      _buildEnergyPrediction(data),
                      const SizedBox(height: 16.0),
                      _buildAIRecommendations(data),
                    ],
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Here is the latest overview of your energy optimization system.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentEnergyUsage(DashboardModel data) {
    return _DashboardCard(
      title: 'Current Energy Usage',
      icon: Icons.electric_bolt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${data.energyUsage} ${data.energyUnit}',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSustainabilityScore(DashboardModel data) {
    return _DashboardCard(
      title: 'Sustainability Score',
      icon: Icons.eco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${data.sustainabilityScore} / 100',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 8),
          const Text('Excellent efficiency!', style: TextStyle(color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildEnergyPrediction(DashboardModel data) {
    return _DashboardCard(
      title: 'Energy Prediction',
      icon: Icons.show_chart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.prediction,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, child) {
              final predictionAsyncValue = ref.watch(predictionFutureProvider);
              return predictionAsyncValue.when(
                data: (predictionData) {
                  return SizedBox(
                    height: 150,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: predictionData.forecast
                                .map((p) => FlSpot(p.hour.toDouble(), p.predictedUsage))
                                .toList(),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withValues(alpha: 0.2),
                            ),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => SizedBox(
                  height: 150,
                  child: Center(
                    child: Text('Error loading prediction:\n$error', style: const TextStyle(color: Colors.red)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendations(DashboardModel data) {
    return _DashboardCard(
      title: 'AI Recommendations',
      icon: Icons.psychology,
      child: Column(
        children: data.recommendations.map((rec) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lightbulb, color: Colors.orange),
            title: Text(rec.title),
            subtitle: Text('Potential saving: ${rec.saving}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          );
        }).toList(),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
