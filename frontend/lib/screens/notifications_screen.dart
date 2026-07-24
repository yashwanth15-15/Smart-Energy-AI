import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Center')),
      body: const EmptyState(
        title: 'All caught up!',
        message: 'You have no new notifications right now.',
        icon: Icons.notifications_active_outlined,
      ),
    );
  }
}
