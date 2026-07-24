import 'package:flutter/material.dart';

import 'package:frontend/shared/widgets/fade_slide_animate.dart';
import 'package:frontend/shared/widgets/hover_elevate_card.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final String statusText;
  final String trend; // "up", "down", or "neutral"
  final String trendValue;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.statusText = '',
    this.trend = 'neutral',
    this.trendValue = '',
  });

  @override
  Widget build(BuildContext context) {
    Color trendColor = Colors.grey;
    IconData trendIcon = Icons.remove;
    if (trend == 'up') {
      trendColor = Colors.green;
      trendIcon = Icons.arrow_drop_up;
    } else if (trend == 'down') {
      trendColor = Colors.red;
      trendIcon = Icons.arrow_drop_down;
    }

    return FadeSlideAnimate(
      child: HoverElevateCard(
        child: Card(
          elevation: 2,
          shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.2,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
              ],
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                      children: [
                        TextSpan(text: value),
                        if (unit.isNotEmpty)
                          TextSpan(
                            text: ' $unit',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (statusText.isNotEmpty || trendValue.isNotEmpty)
              Row(
                children: [
                  if (trendValue.isNotEmpty) ...[
                    Icon(trendIcon, size: 16, color: trendColor),
                    Text(
                      trendValue,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: trendColor),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      statusText,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ),
    ),
    );
  }
}
