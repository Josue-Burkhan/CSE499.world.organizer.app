import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'character_detail_screen.dart';
import 'ability_detail_screen.dart';
import 'event_detail_screen.dart';
import 'item_detail_screen.dart';
import 'powersystem_detail_screen.dart';
import 'race_detail_screen.dart';
import 'religion_detail_screen.dart';
import 'story_detail_screen.dart';
import 'technology_detail_screen.dart';
import 'location_detail_screen.dart';
import 'faction_detail_screen.dart';

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
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: tagColor.withOpacity(0.5)),
                        errorWidget: (context, url, error) => Container(color: tagColor.withOpacity(0.5)),
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
              _buildCustomNotes(creature.customNotes),
              _buildLinkList(context, 'Characters', creature.rawCharacters, 'character'),
              _buildLinkList(context, 'Abilities', creature.rawAbilities, 'ability'),
              _buildLinkList(context, 'Factions', creature.rawFactions, 'faction'),
              _buildLinkList(context, 'Events', creature.rawEvents, 'event'),
              _buildLinkList(context, 'Stories', creature.rawStories, 'story'),
              _buildLinkList(context, 'Locations', creature.rawLocations, 'location'),
              _buildLinkList(context, 'Power Systems', creature.rawPowerSystems, 'powersystem'),
              _buildLinkList(context, 'Religions', creature.rawReligions, 'religion'),
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
            title: Text(creature.speciesType?.isEmpty == true ? 'Unknown' : creature.speciesType ?? 'Unknown'),
            subtitle: const Text('Species Type'),
          ),
          ListTile(
            leading: const Icon(Icons.landscape_outlined),
            title: Text(creature.habitat.isEmpty ? 'Unknown' : creature.habitat),
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
    if (creature.description.isEmpty) {
      return _buildEmptyStateCard('Description', Icons.description_outlined);
    }
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

  Widget _buildCustomNotes(String? notes) {
    if (notes == null || notes.isEmpty) {
      return _buildEmptyStateCard('Custom Notes', Icons.note_outlined);
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(notes!),
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

  Widget _buildLinkList(BuildContext context, String title, List<ModuleLink> links, String type) {
    if (links.isEmpty) return const SizedBox.shrink();

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
              children: links.map((link) => ActionChip(
                label: Text(link.name),
                onPressed: () => _navigateToModule(context, type, link.id),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToModule(BuildContext context, String type, String id) {
    if (id.isEmpty) return;
    
    switch (type) {
        case 'character':
          Navigator.push(context, MaterialPageRoute(builder: (_) => CharacterDetailScreen(characterServerId: id)));
          break;
        case 'ability':
          Navigator.push(context, MaterialPageRoute(builder: (_) => AbilityDetailScreen(abilityServerId: id)));
          break;
        case 'faction':
           Navigator.push(context, MaterialPageRoute(builder: (_) => FactionDetailScreen(factionServerId: id)));
          break;
        case 'event':
          Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(eventServerId: id)));
          break;
        case 'story':
          Navigator.push(context, MaterialPageRoute(builder: (_) => StoryDetailScreen(storyServerId: id)));
          break;
        case 'location':
           Navigator.push(context, MaterialPageRoute(builder: (_) => LocationDetailScreen(locationServerId: id)));
          break;
        case 'powersystem':
          Navigator.push(context, MaterialPageRoute(builder: (_) => PowerSystemDetailScreen(powerSystemServerId: id)));
          break;
        case 'religion':
          Navigator.push(context, MaterialPageRoute(builder: (_) => ReligionDetailScreen(religionServerId: id)));
          break;
    }
  }
  Widget _buildEmptyStateCard(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      elevation: 0,
      color: Colors.grey.withOpacity(0.05),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "No information available.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
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
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
          ),
        ),
      ),
    );
  }
}