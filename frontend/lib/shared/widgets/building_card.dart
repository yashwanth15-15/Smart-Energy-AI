import 'package:flutter/material.dart';
import 'package:frontend/models/building_status.dart';
import 'package:frontend/shared/widgets/digital_twin_dialog.dart';
import 'package:frontend/shared/widgets/fade_slide_animate.dart';
import 'package:frontend/shared/widgets/hover_elevate_card.dart';

class BuildingCard extends StatelessWidget {
  final BuildingStatus building;

  const BuildingCard({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    return FadeSlideAnimate(
      child: HoverElevateCard(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => DigitalTwinDialog(building: building),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                children: [
                  const Icon(Icons.business, color: Color(0xFF2E7D32)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      building.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoItem(label: 'Energy', value: '${building.energyUsage.toStringAsFixed(1)} ${building.energyUnit}', icon: Icons.bolt),
                  _InfoItem(label: 'Temp', value: '${building.temperature.toStringAsFixed(1)}°C', icon: Icons.thermostat),
                  _InfoItem(label: 'Occ.', value: '${building.occupancy}%', icon: Icons.groups),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoItem(label: 'HVAC', value: building.hvacStatus, icon: Icons.air),
                  _InfoItem(label: 'Health', value: building.health, icon: Icons.favorite),
                  _InfoItem(label: 'Efficiency', value: '${building.efficiencyScore}/100', icon: Icons.eco),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    building.alertStatus.toLowerCase() == 'normal' ? Icons.check_circle : Icons.warning,
                    color: building.alertStatus.toLowerCase() == 'normal' ? const Color(0xFF43A047) : const Color(0xFFD32F2F),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    building.alertStatus,
                    style: TextStyle(
                      color: building.alertStatus.toLowerCase() == 'normal' ? const Color(0xFF43A047) : const Color(0xFFD32F2F),
                      fontWeight: FontWeight.bold,
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

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}



