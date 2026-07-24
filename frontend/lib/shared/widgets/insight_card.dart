import 'package:flutter/material.dart';
import 'package:frontend/models/insight_model.dart';

class InsightCard extends StatelessWidget {
  final InsightData insight;

  const InsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    Color riskColor = Colors.blue;
    if (insight.riskLevel.toLowerCase() == 'high') {
      riskColor = Colors.red;
    } else if (insight.riskLevel.toLowerCase() == 'medium') {
      riskColor = Colors.orange;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                const Text('Operational Insight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: riskColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text('Risk: ${insight.riskLevel}', style: TextStyle(color: riskColor, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
            const Divider(height: 32),
            const Text('SUMMARY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
            const SizedBox(height: 8),
            Text(insight.summary, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            const Text('ACTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
            const SizedBox(height: 8),
            Text(insight.recommendedAction, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
