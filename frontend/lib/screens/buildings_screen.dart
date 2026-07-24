import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/building_status.dart';
import 'package:frontend/repositories/dashboard_repository.dart';
import 'package:frontend/shared/widgets/building_card.dart';
import 'package:frontend/shared/widgets/loading_widget.dart';
import 'package:frontend/shared/widgets/error_display.dart';
import 'package:frontend/shared/widgets/empty_state.dart';

final buildingsProvider = FutureProvider<List<BuildingStatus>>((ref) async {
  final repo = DashboardRepository();
  return await repo.fetchBuildings();
});

class BuildingsScreen extends ConsumerWidget {
  const BuildingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(buildingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buildings Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(buildingsProvider),
          ),
        ],
      ),
      body: async.when(
        data: (buildings) {
          if (buildings.isEmpty) {
            return const EmptyState(message: 'No buildings found.');
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(buildingsProvider),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 1000 ? 4 : (constraints.maxWidth > 600 ? 3 : 1);
                  return GridView.builder(
                    itemCount: buildings.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return BuildingCard(building: buildings[index]);
                    },
                  );
                },
              ),
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorDisplay(message: e.toString()),
      ),
    );
  }
}

