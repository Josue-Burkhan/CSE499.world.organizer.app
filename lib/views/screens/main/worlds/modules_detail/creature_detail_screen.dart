import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final creatureDetailStreamProvider =
    StreamProvider.family.autoDispose<CreatureEntity?, String>((ref, serverId) {
  return ref.watch(creatureRepositoryProvider).watchCreatureByServerId(serverId);
});

final creatureDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(creatureSyncServiceProvider);
  await syncService.fetchAndMergeSingleCreature(serverId);
});

class CreatureDetailScreen extends ConsumerWidget {
  final String creatureServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const CreatureDetailScreen({
    super.key,
    required this.creatureServerId,
  });

  String? _getImageUrl(CreatureEntity creature) {
    if (creature.images.isEmpty) return null;
    String path = creature.images.first;
    if (path.startsWith('/')) {
      return '$_imageBaseUrl$path';
    }
    return path;
  }

  Color _getTagColor(String tagColor) {
    switch (tagColor) {
      case 'blue': return Colors.blue.shade400;
      case 'purple': return Colors.purple.shade400;
      case 'green': return Colors.green.shade400;
      case 'red': return Colors.red.shade400;
      case 'amber': return Colors.amber.shade400;
      case 'lime': return Colors.lime.shade400;
      case 'black': return Colors.black87;
      case 'neutral': default: return Colors.grey.shade400;
    }
  }

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCreature = ref.watch(creatureDetailStreamProvider(creatureServerId));

    ref.listen(creatureDetailSyncProvider(creatureServerId), (prev, next) {
      if (prev is AsyncLoading && next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sync details: ${next.error}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    return asyncCreature.when(
      data: (creature) {
        if (creature == null) {
          return ref.watch(creatureDetailSyncProvider(creatureServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load creature: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Creature not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, creature);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error reading local DB: $e')),
      ),
    );
  }

  Widget _buildDetailScaffold(BuildContext context, CreatureEntity creature) {
    final imageUrl = _getImageUrl(creature);
    final tagColor = _getTagColor(creature.tagColor);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(creature.name),
              background: GestureDetector(
                onTap: imageUrl != null 
                  ? () => _openFullScreenImage(context, imageUrl) 
                  : null,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                          Container(color: tagColor.withOpacity(0.5)),
                      )
                    : Container(color: tagColor.withOpacity(0.5)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildBasicInfo(creature),
              _buildDescription(creature),
              _buildWeaknesses(creature),
              _buildRawList('Characters', creature.rawCharacters),
              _buildRawList('Abilities', creature.rawAbilities),
              _buildRawList('Factions', creature.rawFactions),
              _buildRawList('Events', creature.rawEvents),
              _buildRawList('Stories', creature.rawStories),
              _buildRawList('Locations', creature.rawLocations),
              _buildRawList('Power Systems', creature.rawPowerSystems),
              _buildRawList('Religions', creature.rawReligions),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(CreatureEntity creature) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(creature.speciesType ?? 'Unknown'),
            subtitle: const Text('Species Type'),
          ),
          ListTile(
            leading: const Icon(Icons.landscape_outlined),
            title: Text(creature.habitat),
            subtitle: const Text('Habitat'),
          ),
          ListTile(
            leading: const Icon(Icons.pets_outlined),
            title: Text(creature.domesticated == true ? 'Yes' : creature.domesticated == false ? 'No' : 'Unknown'),
            subtitle: const Text('Domesticated'),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(CreatureEntity creature) {
    if (creature.description.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(creature.description),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaknesses(CreatureEntity creature) {
    if (creature.weaknesses.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Weaknesses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: creature.weaknesses.map((item) => Chip(
                label: Text(item),
                backgroundColor: Colors.red.shade100,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRawList(String title, List<String> rawList) {
    if (rawList.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: rawList.map((item) => Chip(label: Text(item))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}