import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text('Admin User', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('System Administrator', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
