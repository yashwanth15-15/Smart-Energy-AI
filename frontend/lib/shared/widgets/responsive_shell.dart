import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/router/app_router.dart';

class ResponsiveShell extends StatelessWidget {
  final Widget child;
  final String currentLocation;
  final VoidCallback onThemeToggle;
  
  const ResponsiveShell({
    super.key, 
    required this.child,
    required this.currentLocation,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final isTablet = screenWidth > 600 && screenWidth <= 900;

    int selectedIndex = navItems.indexWhere((item) => currentLocation.startsWith('/${item.routeName}'));
    selectedIndex = selectedIndex >= 0 ? selectedIndex : 0;

    return Scaffold(
      appBar: isDesktop ? null : _buildMobileAppBar(context),
      drawer: isDesktop || isTablet ? null : _buildMobileDrawer(context),
      body: Row(
        children: [
          if (isDesktop) _buildDesktopSidebar(context, selectedIndex),
          if (isTablet) _buildTabletRail(context, selectedIndex),
          Expanded(
            child: Column(
              children: [
                if (isDesktop) _buildDesktopHeader(context),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: (isDesktop || isTablet) ? null : _buildBottomNav(context, selectedIndex),
    );
  }

  AppBar _buildMobileAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Smart Energy AI'),
      actions: [
        IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: onThemeToggle,
        ),
        IconButton(icon: const Icon(Icons.notifications), onPressed: () => context.go('/notifications')),
      ],
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.eco, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text('Smart Energy AI', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...navItems.map((item) => ListTile(
            leading: Icon(item.icon),
            title: Text(item.label),
            onTap: () {
              context.pop();
              context.go('/${item.routeName}');
            },
          )),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () { context.pop(); context.go('/settings'); }),
          ListTile(leading: const Icon(Icons.person), title: const Text('Profile'), onTap: () { context.pop(); context.go('/profile'); }),
        ],
      ),
    );
  }

  Widget _buildDesktopSidebar(BuildContext context, int selectedIndex) {
    return Container(
      width: 250,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco, color: Theme.of(context).colorScheme.primary, size: 32),
              const SizedBox(width: 12),
              Text('Smart Energy AI', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = index == selectedIndex;
                return ListTile(
                  leading: Icon(item.icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
                  title: Text(item.label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).colorScheme.primary : null)),
                  selected: isSelected,
                  selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  onTap: () => context.go('/${item.routeName}'),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () => context.go('/settings')),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabletRail(BuildContext context, int selectedIndex) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => context.go('/${navItems[index].routeName}'),
      destinations: navItems.map((item) => NavigationRailDestination(
        icon: Icon(item.icon),
        label: Text(item.label),
      )).toList(),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Icon(Icons.eco, color: Theme.of(context).colorScheme.primary, size: 32),
      ),
      trailing: IconButton(icon: const Icon(Icons.settings), onPressed: () => context.go('/settings')),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          const Spacer(),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: onThemeToggle,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.go('/notifications'),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () => context.go('/profile'),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, int selectedIndex) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => context.go('/${navItems[index].routeName}'),
      destinations: navItems.map((item) => NavigationDestination(icon: Icon(item.icon), label: item.label)).toList(),
    );
  }
}
