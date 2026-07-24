import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = [
      {'title': 'Campus Energy Report', 'icon': Icons.bolt, 'desc': 'Daily power consumption summary'},
      {'title': 'Monthly Sustainability Report', 'icon': Icons.eco, 'desc': 'ESG compliance and CO2 reduction'},
      {'title': 'Building Performance Report', 'icon': Icons.business, 'desc': 'Detailed breakdown per building'},
      {'title': 'AI Recommendation Report', 'icon': Icons.psychology, 'desc': 'AI Insights and predicted savings'},
      {'title': 'ESG Summary Report', 'icon': Icons.assignment, 'desc': 'Governance and social metrics'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Reports Center')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final r = reports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F9F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(r['icon'] as IconData, color: const Color(0xFF2E7D32)),
              ),
              title: Text(r['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(r['desc'] as String),
              ),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Generating PDF for ${r['title']} (Mock Demo)'),
                      backgroundColor: const Color(0xFF43A047),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                label: const Text('Generate'),
              ),
            ),
          );
        },
      ),
    );
  }
}
