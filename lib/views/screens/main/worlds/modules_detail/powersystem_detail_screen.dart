import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/character_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/ability_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/faction_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/event_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/story_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/creature_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/religion_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/technology_detail_screen.dart';

final powerSystemDetailStreamProvider =
    StreamProvider.family.autoDispose<PowerSystemEntity?, String>((ref, serverId) {
  return ref.watch(powerSystemRepositoryProvider).watchPowerSystemByServerId(serverId);
});

final powerSystemDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(powerSystemSyncServiceProvider);
  await syncService.fetchAndMergeSinglePowerSystem(serverId);
});

class PowerSystemDetailScreen extends ConsumerWidget {
  final String powerSystemServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const PowerSystemDetailScreen({
    super.key,
    required this.powerSystemServerId,
  });

  String? _getImageUrl(PowerSystemEntity ps) {
    if (ps.images.isEmpty) return null;
    String path = ps.images.first;
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
    final asyncPowerSystem = ref.watch(powerSystemDetailStreamProvider(powerSystemServerId));

    ref.listen(powerSystemDetailSyncProvider(powerSystemServerId), (prev, next) {
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

    return asyncPowerSystem.when(
      data: (powerSystem) {
        if (powerSystem == null) {
          return ref.watch(powerSystemDetailSyncProvider(powerSystemServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load power system: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Power system not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, powerSystem);
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

  Widget _buildDetailScaffold(BuildContext context, PowerSystemEntity powerSystem) {
    final imageUrl = _getImageUrl(powerSystem);
    final tagColor = _getTagColor(powerSystem.tagColor);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(powerSystem.name),
              background: GestureDetector(
                onTap: imageUrl != null 
                  ? () => _openFullScreenImage(context, imageUrl) 
                  : null,
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: tagColor.withOpacity(0.5)),
                        errorWidget: (context, url, error) => 
                          Container(color: tagColor.withOpacity(0.5)),
                      )
                    : Container(color: tagColor.withOpacity(0.5)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildDescription(powerSystem.description),
              _buildPowerSystemDetails(powerSystem),
              _buildCustomNotes(powerSystem.customNotes),
              _buildChipList('Classification Types', powerSystem.classificationTypes),
              _buildLinkList(context, 'Characters', powerSystem.rawCharacters),
              _buildLinkList(context, 'Abilities', powerSystem.rawAbilities),
              _buildLinkList(context, 'Factions', powerSystem.rawFactions),
              _buildLinkList(context, 'Events', powerSystem.rawEvents),
              _buildLinkList(context, 'Stories', powerSystem.rawStories),
              _buildLinkList(context, 'Creatures', powerSystem.rawCreatures),
              _buildLinkList(context, 'Religions', powerSystem.rawReligions),
              _buildLinkList(context, 'Technologies', powerSystem.rawTechnologies),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String? description) {
    if (description == null || description.isEmpty) {
      return _buildEmptyStateCard('Description', Icons.description_outlined);
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerSystemDetails(PowerSystemEntity ps) {
    // final hasSource = ps.sourceOfPower != null && ps.sourceOfPower!.isNotEmpty;
    // final hasRules = ps.rules != null && ps.rules!.isNotEmpty;
    // final hasLimitations = ps.limitations != null && ps.limitations!.isNotEmpty;
    // final hasSymbols = ps.symbolsOrMarks != null && ps.symbolsOrMarks!.isNotEmpty;

    // if (!hasSource && !hasRules && !hasLimitations && !hasSymbols) {
    //   return const SizedBox.shrink();
    // }

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Power System Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Source of Power', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(ps.sourceOfPower?.isEmpty == true ? 'Unknown' : ps.sourceOfPower ?? 'Unknown'),

            const SizedBox(height: 16),
            const Text('Rules', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(ps.rules?.isEmpty == true ? 'Unknown' : ps.rules ?? 'Unknown'),

            const SizedBox(height: 16),
            const Text('Limitations', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(ps.limitations?.isEmpty == true ? 'Unknown' : ps.limitations ?? 'Unknown'),

            const SizedBox(height: 16),
            const Text('Symbols or Marks', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(ps.symbolsOrMarks?.isEmpty == true ? 'Unknown' : ps.symbolsOrMarks ?? 'Unknown'),
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
            Text(notes),
          ],
        ),
      ),
    );
  }

  Widget _buildChipList(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
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
              children: items.map((item) => Chip(label: Text(item))).toList(),
            ),
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
                onPressed: () => _navigateToModule(context, link, title),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToModule(BuildContext context, ModuleLink link, String title) {
    if (link.id.isEmpty) return;

    Widget? page;
    switch (title) {
      case 'Characters': page = CharacterDetailScreen(characterServerId: link.id); break;
      case 'Abilities': page = AbilityDetailScreen(abilityServerId: link.id); break;
      case 'Factions': page = FactionDetailScreen(factionServerId: link.id); break;
      case 'Events': page = EventDetailScreen(eventServerId: link.id); break;
      case 'Stories': page = StoryDetailScreen(storyServerId: link.id); break;
      case 'Creatures': page = CreatureDetailScreen(creatureServerId: link.id); break;
      case 'Religions': page = ReligionDetailScreen(religionServerId: link.id); break;
      case 'Technologies': page = TechnologyDetailScreen(technologyServerId: link.id); break;
    }

    if (page != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page!));
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
          child: CachedNetworkImage(imageUrl: imageUrl),
        ),
      ),
    );
  }
}