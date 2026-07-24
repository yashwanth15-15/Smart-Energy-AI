import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/buildings_screen.dart'; // For buildingsProvider
import 'package:frontend/models/building_status.dart';
import 'package:frontend/shared/widgets/loading_widget.dart';
import 'package:frontend/shared/widgets/error_display.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingsAsync = ref.watch(buildingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Campus Map')),
      body: buildingsAsync.when(
        data: (buildings) => _buildMap(context, buildings),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorDisplay(message: e.toString()),
      ),
    );
  }

  Widget _buildMap(BuildContext context, List<BuildingStatus> buildings) {
    // We'll create a stylized conceptual grid/map
    return Container(
      width: double.infinity,
      color: const Color(0xFFF4F9F4),
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(50.0),
        minScale: 0.5,
        maxScale: 2.0,
        child: Center(
          child: Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: buildings.map((b) => _MapNode(building: b)).toList(),
          ),
        ),
      ),
    );
  }
}

class _MapNode extends StatelessWidget {
  final BuildingStatus building;

  const _MapNode({required this.building});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (building.alertStatus.toLowerCase() == 'critical') {
      statusColor = Colors.red;
    } else if (building.alertStatus.toLowerCase() == 'warning') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }

    return GestureDetector(
      onTap: () => context.go('/buildings/${building.name}'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
              border: Border.all(color: statusColor, width: 4),
            ),
            child: Icon(
              Icons.business,
              color: statusColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)
              ],
            ),
            child: Text(
              building.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
