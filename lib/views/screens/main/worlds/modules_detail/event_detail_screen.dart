import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/event_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/character_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/faction_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/location_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/item_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/ability_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/story_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/creature_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/religion_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/technology_detail_screen.dart';

final eventDetailStreamProvider =
    StreamProvider.family.autoDispose<EventEntity?, String>((ref, serverId) {
  return ref.watch(eventRepositoryProvider).watchEventByServerId(serverId);
});

final eventDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(eventSyncServiceProvider);
  await syncService.fetchAndMergeSingleEvent(serverId);
});

class EventDetailScreen extends ConsumerWidget {
  final String eventServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const EventDetailScreen({
    super.key,
    required this.eventServerId,
  });

  String? _getImageUrl(EventEntity event) {
    if (event.images.isEmpty) return null;
    String path = event.images.first;
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
    final asyncEvent = ref.watch(eventDetailStreamProvider(eventServerId));

    ref.listen(eventDetailSyncProvider(eventServerId), (prev, next) {
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

    return asyncEvent.when(
      data: (event) {
        if (event == null) {
          return ref.watch(eventDetailSyncProvider(eventServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load event: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Event not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, event);
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

  Widget _buildDetailScaffold(BuildContext context, EventEntity event) {
    final imageUrl = _getImageUrl(event);
    final tagColor = _getTagColor(event.tagColor);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(event.name),
              background: GestureDetector(
                onTap: imageUrl != null 
                  ? () => _openFullScreenImage(context, imageUrl) 
                  : null,
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) => 
                          Container(color: tagColor.withOpacity(0.5)),
                        placeholder: (context, url) => Container(color: tagColor.withOpacity(0.5)),
                      )
                    : Container(color: tagColor.withOpacity(0.5)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildBasicInfo(event),
              _buildDescription(event),
              _buildCustomNotes(event),
              _buildLinkList(context, 'Characters', event.rawCharacters),
              _buildLinkList(context, 'Factions', event.rawFactions),
              _buildLinkList(context, 'Locations', event.rawLocations),
              _buildLinkList(context, 'Items', event.rawItems),
              _buildLinkList(context, 'Abilities', event.rawAbilities),
              _buildLinkList(context, 'Stories', event.rawStories),
              _buildLinkList(context, 'Power Systems', event.rawPowerSystems),
              _buildLinkList(context, 'Creatures', event.rawCreatures),
              _buildLinkList(context, 'Religions', event.rawReligions),
              _buildLinkList(context, 'Technologies', event.rawTechnologies),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(EventEntity event) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: Text(event.date ?? 'Unknown'),
            subtitle: const Text('Date'),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(EventEntity event) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(event.description?.isEmpty == true ? 'No description available.' : event.description ?? 'No description available.'),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNotes(EventEntity event) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Custom Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(event.customNotes?.isEmpty == true ? 'No custom notes.' : event.customNotes ?? 'No custom notes.'),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkList(BuildContext context, String title, List<ModuleLink> links) {
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
                onPressed: link.id.isEmpty ? null : () => _navigateToModule(context, link, title),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToModule(BuildContext context, ModuleLink link, String type) {
    if (link.id.isEmpty) return;

    Widget? screen;
    switch (type) {
      case 'Characters':
        screen = CharacterDetailScreen(characterServerId: link.id);
        break;
      case 'Factions':
        screen = FactionDetailScreen(factionServerId: link.id);
        break;
      case 'Locations':
        screen = LocationDetailScreen(locationServerId: link.id);
        break;
      case 'Items':
        screen = ItemDetailScreen(itemServerId: link.id);
        break;
      case 'Abilities':
        screen = AbilityDetailScreen(abilityServerId: link.id);
        break;
      case 'Stories':
        screen = StoryDetailScreen(storyServerId: link.id);
        break;
        // Need to check if PowerSystemDetailScreen exists? 
        // Assuming patterns. If not, default to nothing.
      case 'Creatures':
          screen = CreatureDetailScreen(creatureServerId: link.id);
          break;
      case 'Religions':
          screen = ReligionDetailScreen(religionServerId: link.id);
          break;
      case 'Technologies':
          screen = TechnologyDetailScreen(technologyServerId: link.id);
          break;
    }

    if (screen != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen!));
    }
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
          child: CachedNetworkImage(imageUrl: imageUrl, placeholder: (c, u) => const CircularProgressIndicator(),),
        ),
      ),
    );
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