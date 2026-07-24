import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(title: const Text('About Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroHeader(context),
            const SizedBox(height: 16),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProblemStatement(context),
                        const SizedBox(height: 16),
                        _buildTechStack(context),
                        const SizedBox(height: 16),
                        _buildAiFeatures(context),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildObjectives(context),
                        const SizedBox(height: 16),
                        _buildArchitecture(context),
                        const SizedBox(height: 16),
                        _buildFutureScope(context),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProblemStatement(context),
                  const SizedBox(height: 16),
                  _buildObjectives(context),
                  const SizedBox(height: 16),
                  _buildTechStack(context),
                  const SizedBox(height: 16),
                  _buildArchitecture(context),
                  const SizedBox(height: 16),
                  _buildAiFeatures(context),
                  const SizedBox(height: 16),
                  _buildFutureScope(context),
                ],
              ),
            const SizedBox(height: 24),
            _buildDeveloperSection(context),
            const SizedBox(height: 24),
            _buildFooter(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.eco, size: 72, color: Color(0xFF2E7D32)),
        const SizedBox(height: 16),
        Text('Smart Energy AI', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20))),
        const SizedBox(height: 8),
        Text('Enterprise Energy Intelligence Platform', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700])),
        const SizedBox(height: 16),
        Chip(
          label: const Text('Version 1.0', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: const Color(0xFF43A047),
          side: BorderSide.none,
        ),
      ],
    );
  }

  Widget _buildProblemStatement(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.report_problem, color: Colors.orange[800]),
                const SizedBox(width: 8),
                Text('Problem Statement', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Smart Energy AI is an enterprise energy intelligence platform designed for commercial buildings, campuses, hospitals, industrial facilities, and smart infrastructure.\n\n'
              'The platform combines real-time monitoring, predictive analytics, AI-assisted decision support, and operational intelligence to improve energy efficiency while reducing operating costs.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectives(BuildContext context) {
    final objectives = [
      'Monitor campus energy',
      'Predict future consumption',
      'Detect abnormal usage',
      'Reduce operational cost',
      'Improve sustainability',
      'Support smart campus initiatives',
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Core Objectives', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ...objectives.map((obj) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text(obj, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTechStack(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Technology Stack', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _TechChip(icon: Icons.phone_android, label: 'Flutter'),
            _TechChip(icon: Icons.api, label: 'FastAPI'),
            _TechChip(icon: Icons.storage, label: 'SQLite'),
            _TechChip(icon: Icons.water_drop, label: 'Riverpod'),
            _TechChip(icon: Icons.psychology, label: 'Machine Learning'),
            _TechChip(icon: Icons.settings_applications, label: 'Simulation Engine'),
            _TechChip(icon: Icons.design_services, label: 'Material 3'),
          ],
        ),
      ],
    );
  }

  Widget _buildArchitecture(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('System Architecture', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Column(
            children: [
              _ArchNode('Simulation Engine', 'Generates realistic real-time campus data', Icons.model_training, Colors.purple),
              _ArchArrow(),
              _ArchNode('FastAPI Backend', 'Processes data and orchestrates AI models', Icons.dns, Colors.blue),
              _ArchArrow(),
              _ArchNode('SQLite Database', 'Persists historical state and telemetry', Icons.storage, Colors.brown),
              _ArchArrow(),
              _ArchNode('REST APIs', 'Provides low-latency access to frontend clients', Icons.sync_alt, Colors.orange),
              _ArchArrow(),
              _ArchNode('Flutter Dashboard', 'Visualizes metrics in an enterprise UI', Icons.dashboard, Colors.green),
              _ArchArrow(),
              _ArchNode('AI Insights & Predictions', 'Analyzes patterns for optimization', Icons.psychology, Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAiFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AI Features', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 4.5,
          children: const [
            _FeatureCard(icon: Icons.online_prediction, title: 'Energy Prediction'),
            _FeatureCard(icon: Icons.lightbulb, title: 'Smart Recommendations'),
            _FeatureCard(icon: Icons.warning, title: 'Alert Detection'),
            _FeatureCard(icon: Icons.eco, title: 'Sustainability Monitoring'),
            _FeatureCard(icon: Icons.health_and_safety, title: 'Campus Health Analysis'),
          ],
        ),
      ],
    );
  }

  Widget _buildFutureScope(BuildContext context) {
    final scope = [
      'Live IoT Integration',
      'Renewable Energy Monitoring',
      'Predictive Maintenance',
      'Carbon Intelligence',
      'Multi-site Management',
      'AI Automation',
    ];

    return Card(
      elevation: 1,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.blue.shade100)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.rocket_launch, color: Colors.blue[800]),
                const SizedBox(width: 8),
                Text('Product Roadmap', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue[900])),
              ],
            ),
            const SizedBox(height: 16),
            ...scope.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_forward_ios, color: Colors.blue[400], size: 14),
                      const SizedBox(width: 12),
                      Text(s, style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Founder & Lead Developer', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('Bankapalli Yashwanth', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Software Engineer', style: TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        const Text('Smart Energy AI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 4),
        const Text('Enterprise Energy Intelligence Platform', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        const Text('Version 1.0', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterTag('Material 3'),
            const SizedBox(width: 8),
            _FooterTag('Responsive'),
            const SizedBox(width: 8),
            _FooterTag('Professional animations'),
          ],
        ),
      ],
    );
  }
}

class _TechChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TechChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
      padding: const EdgeInsets.all(8),
    );
  }
}

class _ArchNode extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const _ArchNode(this.label, this.description, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(description, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchArrow extends StatelessWidget {
  const _ArchArrow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Icon(Icons.arrow_downward, color: Colors.grey, size: 20),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.green.shade700, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
        ],
      ),
    );
  }
}

class _FooterTag extends StatelessWidget {
  final String text;
  const _FooterTag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey)),
    );
  }
}
