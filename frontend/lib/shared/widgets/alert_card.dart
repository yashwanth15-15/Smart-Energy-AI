import 'package:flutter/material.dart';
import 'package:frontend/models/alert_model.dart';

class AlertCard extends StatelessWidget {
  final AlertData alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    Color severityColor;
    switch (alert.severity.toLowerCase()) {
      case 'critical':
        severityColor = Colors.redAccent;
        break;
      case 'high':
        severityColor = Colors.orangeAccent;
        break;
      case 'medium':
        severityColor = Colors.yellowAccent;
        break;
      default:
        severityColor = Colors.greenAccent;
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(Icons.notifications, color: severityColor, size: 32),
            title: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.message),
                const SizedBox(height: 4),
                if (alert.recommendation.isNotEmpty)
                  Text('Recommendation: ${alert.recommendation}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                if (alert.estimatedSavings.isNotEmpty)
                  Text('Savings: ${alert.estimatedSavings}', style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            trailing: Text(
              alert.severity.toUpperCase(),
              style: TextStyle(color: severityColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
