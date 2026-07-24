import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String? actionLabel;

  const SectionHeader({
    super.key,
    required this.title,
    this.onTap,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (onTap != null && actionLabel != null)
          TextButton(
            onPressed: onTap,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}
