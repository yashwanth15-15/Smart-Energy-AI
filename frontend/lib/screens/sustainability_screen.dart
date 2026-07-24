import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/section_header.dart';
import 'package:frontend/shared/widgets/kpi_card.dart';

class SustainabilityScreen extends StatelessWidget {
  const SustainabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sustainability & ESG')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Environmental Impact'),
            const SizedBox(height: 16),
            _buildEnvironmentalGrid(context),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Social Governance'),
            const SizedBox(height: 16),
            _buildSocialGrid(context),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Operational Governance'),
            const SizedBox(height: 16),
            _buildGovernanceGrid(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentalGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: const [
        KpiCard(title: 'Electricity Consumed', value: '12,500', unit: 'kWh', icon: Icons.bolt),
        KpiCard(title: 'CO₂ Emissions', value: '4,200', unit: 'kg', icon: Icons.cloud),
        KpiCard(title: 'Energy Saved (AI)', value: '850.5', unit: 'kWh', icon: Icons.eco),
        KpiCard(title: 'Renewable Source', value: '15.2', unit: '%', icon: Icons.solar_power),
      ],
    );
  }

  Widget _buildSocialGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: const [
        KpiCard(title: 'Occupant Engagement', value: '85', unit: '%', icon: Icons.group),
        KpiCard(title: 'Alerts Resolved', value: '12', unit: '', icon: Icons.check_circle),
        KpiCard(title: 'Energy Awareness', value: '92', unit: '/100', icon: Icons.psychology),
      ],
    );
  }

  Widget _buildGovernanceGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: const [
        KpiCard(title: 'Buildings Connected', value: '9', unit: '', icon: Icons.business),
        KpiCard(title: 'Reports Generated', value: '24', unit: '', icon: Icons.picture_as_pdf),
        KpiCard(title: 'Avg Response Time', value: '15', unit: 'mins', icon: Icons.timer),
        KpiCard(title: 'Compliance Score', value: '98', unit: '/100', icon: Icons.verified),
      ],
    );
  }
}
