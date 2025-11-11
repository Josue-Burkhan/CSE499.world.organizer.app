import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/world_detail_screen.dart';

class WorldTimelineWidget extends ConsumerWidget {
  final String worldId;

  const WorldTimelineWidget({super.key, required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsyncValue = ref.watch(worldTimelineProvider(worldId));

    return timelineAsyncValue.when(
      data: (timeline) => ListView.builder(
        itemCount: timeline.length,
        itemBuilder: (context, index) {
          final activity = timeline[index];
          return ListTile(
            title: Text(activity.description),
            subtitle: Text(activity.createdAt.toString()),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
