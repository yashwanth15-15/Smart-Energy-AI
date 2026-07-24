import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Screens
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/screens/buildings_screen.dart';
import 'package:frontend/screens/analytics_screen.dart';
import 'package:frontend/screens/insights_screen.dart';
import 'package:frontend/screens/alerts_screen.dart';
import 'package:frontend/screens/prediction_screen.dart';
import 'package:frontend/screens/sustainability_screen.dart';
import 'package:frontend/screens/map_screen.dart';
import 'package:frontend/screens/reports_screen.dart';
import 'package:frontend/screens/ai_copilot_screen.dart';
import 'package:frontend/screens/about_screen.dart';
import 'package:frontend/core/theme/app_theme.dart';

class _NavItem {
  const _NavItem(this.label, this.icon, this.routeName);
  final String label;
  final IconData icon;
  final String routeName;
}

final List<_NavItem> _navItems = const [
  _NavItem('Dashboard', Icons.dashboard, 'dashboard'),
  _NavItem('Copilot', Icons.psychology, 'copilot'),
  _NavItem('Buildings', Icons.location_city, 'buildings'),
  _NavItem('Prediction', Icons.auto_graph, 'prediction'),
  _NavItem('Analytics', Icons.analytics, 'analytics'),
];

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final String location = state.uri.toString();
        int selectedIndex = _navItems.indexWhere((item) => location.startsWith('/${item.routeName}'));
        selectedIndex = selectedIndex >= 0 ? selectedIndex : 0;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Smart Energy AI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
            actions: [
              IconButton(icon: const Icon(Icons.notifications), onPressed: () => context.go('/alerts')),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: _DemoBanner(),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF2E7D32)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.eco, color: Colors.white, size: 40),
                      SizedBox(height: 10),
                      Text('Smart Energy AI', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('Enterprise Energy Intelligence Platform', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'), onTap: () { context.pop(); context.go('/dashboard'); }),
                ListTile(leading: const Icon(Icons.psychology), title: const Text('AI Copilot'), onTap: () { context.pop(); context.go('/copilot'); }),
                ListTile(leading: const Icon(Icons.location_city), title: const Text('Buildings'), onTap: () { context.pop(); context.go('/buildings'); }),
                ListTile(leading: const Icon(Icons.map), title: const Text('Campus Map'), onTap: () { context.pop(); context.go('/map'); }),
                ListTile(leading: const Icon(Icons.auto_graph), title: const Text('AI Prediction'), onTap: () { context.pop(); context.go('/prediction'); }),
                ListTile(leading: const Icon(Icons.analytics), title: const Text('Analytics'), onTap: () { context.pop(); context.go('/analytics'); }),
                const Divider(),
                ListTile(leading: const Icon(Icons.eco), title: const Text('Sustainability (ESG)'), onTap: () { context.pop(); context.go('/sustainability'); }),
                ListTile(leading: const Icon(Icons.picture_as_pdf), title: const Text('Reports'), onTap: () { context.pop(); context.go('/reports'); }),
                ListTile(leading: const Icon(Icons.insights), title: const Text('AI Insights'), onTap: () { context.pop(); context.go('/insights'); }),
                ListTile(leading: const Icon(Icons.notifications), title: const Text('Smart Alerts'), onTap: () { context.pop(); context.go('/alerts'); }),
                const Divider(),
                ListTile(leading: const Icon(Icons.info), title: const Text('About Project'), onTap: () { context.pop(); context.go('/about'); }),
              ],
            ),
          ),
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              if (index != selectedIndex) context.go('/${_navItems[index].routeName}');
            },
            destinations: _navItems.map((item) => NavigationDestination(icon: Icon(item.icon, size: 32), label: item.label)).toList(),
          ),
        );
      },
      routes: [
        _fadeRoute('/dashboard', 'dashboard', const DashboardScreen()),
        _fadeRoute('/copilot', 'copilot', const AiCopilotScreen()),
        _fadeRoute('/buildings', 'buildings', const BuildingsScreen()),
        _fadeRoute('/analytics', 'analytics', const AnalyticsScreen()),
        _fadeRoute('/insights', 'insights', const InsightsScreen()),
        _fadeRoute('/alerts', 'alerts', const AlertsScreen()),
        _fadeRoute('/prediction', 'prediction', const PredictionScreen()),
        _fadeRoute('/sustainability', 'sustainability', const SustainabilityScreen()),
        _fadeRoute('/map', 'map', const MapScreen()),
        _fadeRoute('/reports', 'reports', const ReportsScreen()),
        _fadeRoute('/about', 'about', const AboutScreen()),
      ],
    ),
  ],
);

GoRoute _fadeRoute(String path, String name, Widget child) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Smart Campus',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _DemoBanner extends StatelessWidget {
  const _DemoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Card(
        elevation: 0,
        color: Colors.orange.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.orange.shade200),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade800),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Simulation Environment: This environment uses a realistic digital simulation engine to emulate live energy infrastructure and AI-driven operational insights.',
                  style: TextStyle(fontSize: 13, color: Colors.orange.shade900),
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const _SimulationInfoDialog(),
                  );
                },
                icon: Icon(Icons.help_outline, size: 18, color: Colors.orange.shade900),
                label: Text('Learn More', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimulationInfoDialog extends StatelessWidget {
  const _SimulationInfoDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.green),
          SizedBox(width: 8),
          Text('Simulation Environment', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoBullet('This deployment uses a high-fidelity digital simulation engine that reproduces realistic energy consumption, occupancy, HVAC activity, and operational events.'),
            _InfoBullet('The frontend and backend are identical to a real deployment and can connect to live IoT devices without architectural changes.'),
            const SizedBox(height: 24),
            const Center(
              child: Text('Version 1.0', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _InfoBullet extends StatelessWidget {
  final String text;
  const _InfoBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0, right: 8.0),
            child: Icon(Icons.circle, size: 6, color: Colors.green),
          ),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4))),
        ],
      ),
    );
  }
}

