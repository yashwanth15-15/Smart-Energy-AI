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
import 'package:frontend/screens/settings_screen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/screens/notifications_screen.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/theme/theme_provider.dart';
import 'package:frontend/shared/widgets/responsive_shell.dart';

class NavItem {
  const NavItem(this.label, this.icon, this.routeName);
  final String label;
  final IconData icon;
  final String routeName;
}

final List<NavItem> navItems = const [
  NavItem('Dashboard', Icons.dashboard, 'dashboard'),
  NavItem('Copilot', Icons.psychology, 'copilot'),
  NavItem('Buildings', Icons.location_city, 'buildings'),
  NavItem('Prediction', Icons.auto_graph, 'prediction'),
  NavItem('Analytics', Icons.analytics, 'analytics'),
];

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final String location = state.uri.toString();
        
        return Consumer(
          builder: (context, ref, _) {
            return ResponsiveShell(
              currentLocation: location,
              onThemeToggle: () => ref.read(themeProvider.notifier).toggleTheme(),
              child: child,
            );
          },
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
        _fadeRoute('/settings', 'settings', const SettingsScreen()),
        _fadeRoute('/profile', 'profile', const ProfileScreen()),
        _fadeRoute('/notifications', 'notifications', const NotificationsScreen()),
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

