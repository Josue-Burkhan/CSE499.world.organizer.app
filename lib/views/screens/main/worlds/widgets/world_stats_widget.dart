import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/models/api_models/world_stats_model.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/world_detail_screen.dart';

class WorldStatsWidget extends ConsumerWidget {
  final String worldId;

  const WorldStatsWidget({super.key, required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsyncValue = ref.watch(worldStatsProvider(worldId));

    return statsAsyncValue.when(
      data: (stats) => _buildStatsGrid(stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildStatsGrid(WorldStats stats) {
    final statsMap = {
      'Characters': stats.characters,
      'Locations': stats.locations,
      'Factions': stats.factions,
      'Items': stats.items,
      'Events': stats.events,
      'Languages': stats.languages,
      'Abilities': stats.abilities,
      'Technology': stats.technology,
      'Power Systems': stats.powerSystem,
      'Creatures': stats.creatures,
      'Religions': stats.religion,
      'Stories': stats.story,
      'Races': stats.races,
      'Economies': stats.economy,
      'Total Images': stats.totalImages,
    };

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
      ),
      itemCount: statsMap.length,
      itemBuilder: (context, index) {
        final entry = statsMap.entries.elementAt(index);
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                entry.value.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(entry.key),
            ],
          ),
        );
      },
    );
  }
}
