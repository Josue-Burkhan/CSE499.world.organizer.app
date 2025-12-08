import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/faction_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/character_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/location_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/event_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/item_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/story_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/religion_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/technology_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/language_detail_screen.dart';

final factionDetailStreamProvider =
    StreamProvider.family.autoDispose<FactionEntity?, String>((ref, serverId) {
  return ref.watch(factionRepositoryProvider).watchFactionByServerId(serverId);
});

final factionDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(factionSyncServiceProvider);
  await syncService.fetchAndMergeSingleFaction(serverId);
});

class FactionDetailScreen extends ConsumerWidget {
  final String factionServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const FactionDetailScreen({
    super.key,
    required this.factionServerId,
  });

  String? _getImageUrl(FactionEntity char) {
    if (char.images.isEmpty) return null;
    String path = char.images.first;
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
    final asyncFaction = ref.watch(factionDetailStreamProvider(factionServerId));

    ref.listen(factionDetailSyncProvider(factionServerId), (prev, next) {
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

    return asyncFaction.when(
      data: (faction) {
        if (faction == null) {
          return ref.watch(factionDetailSyncProvider(factionServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load faction: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Faction not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, faction);
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

  Widget _buildDetailScaffold(BuildContext context, FactionEntity faction) {
    final imageUrl = _getImageUrl(faction);
    final tagColor = _getTagColor(faction.tagColor);

    List<FactionRelation> allies = [];
    final alliesJson = faction.alliesJson;
    if (alliesJson != null) {
      allies = (jsonDecode(alliesJson) as List)
          .map((i) => FactionRelation.fromJson(i))
          .toList();
    }
    List<FactionRelation> enemies = [];
    final enemiesJson = faction.enemiesJson;
    if (enemiesJson != null) {
      enemies = (jsonDecode(enemiesJson) as List)
          .map((i) => FactionRelation.fromJson(i))
          .toList();
    }
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(faction.name),
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
              _buildBasicInfo(faction),
              _buildRelationships(context, 'Relationships', allies, enemies),
              _buildGoals(faction),
              _buildHistory(faction.history),
              _buildCustomNotes(faction.customNotes),
              _buildLinkList(context, 'Characters', faction.rawCharacters),
              _buildLinkList(context, 'Locations', faction.rawLocations),
              _buildLinkList(context, 'Headquarters', faction.rawHeadquarters),
              _buildLinkList(context, 'Territory', faction.rawTerritory),
              _buildLinkList(context, 'Events', faction.rawEvents),
              _buildLinkList(context, 'Items', faction.rawItems),
              _buildLinkList(context, 'Stories', faction.rawStories),
              _buildLinkList(context, 'Religions', faction.rawReligions),
              _buildLinkList(context, 'Technologies', faction.rawTechnologies),
              _buildLinkList(context, 'Languages', faction.rawLanguages),
              _buildLinkList(context, 'Power Systems', faction.rawPowerSystems),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(FactionEntity faction) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(faction.description?.isEmpty == true ? 'No description.' : faction.description ?? 'No description.'),
            subtitle: const Text('Description'),
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(faction.type?.isEmpty == true ? 'Unknown' : faction.type ?? 'Unknown'),
            subtitle: const Text('Type'),
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: Text(faction.symbol?.isEmpty == true ? 'None' : faction.symbol ?? 'None'),
            subtitle: const Text('Symbol'),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_outlined),
            title: Text(faction.economicSystem?.isEmpty == true ? 'Unknown' : faction.economicSystem ?? 'Unknown'),
            subtitle: const Text('Economic System'),
          ),
          ListTile(
            leading: const Icon(Icons.science_outlined),
            title: Text(faction.technology?.isEmpty == true ? 'Unknown' : faction.technology ?? 'Unknown'),
            subtitle: const Text('Technology Level'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRelationships(
    BuildContext context,
    String title,
    List<FactionRelation> allies,
    List<FactionRelation> enemies,
  ) {
    if (allies.isEmpty && enemies.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildRelationChipList(context, 'Friends', allies),
            _buildRelationChipList(context, 'Enemies', enemies),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationChipList(BuildContext context, String title, List<FactionRelation> relations) {
    // FORCE VISIBILITY: Check if empty and show "None"
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4.0),
        relations.isEmpty 
          ? const Text('None')
          : Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: relations.map((rel) => ActionChip(
              label: Text(rel.name),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FactionDetailScreen(
                      factionServerId: rel.id,
                    ),
                  ),
                );
              },
            )).toList(),
          ),
      ],
    );
  }

    Widget _buildGoals(FactionEntity faction) {
    if (faction.goals.isEmpty) return const SizedBox.shrink();

    if (faction.goals.isEmpty) {
        return Card(
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const Text('Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                const Text('None'),
            ],
            ),
        ),
        );
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            ...faction.goals.map((goal) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(goal)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(String? history) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(history?.isEmpty==true ? 'No history available.' : history ?? 'No history available.'),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNotes(String? notes) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Custom Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(notes?.isEmpty==true ? 'No custom notes.' : notes ?? 'No custom notes.'),
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
      case 'Locations':
      case 'Headquarters':
      case 'Territory':
        screen = LocationDetailScreen(locationServerId: link.id);
        break;
      case 'Events':
        screen = EventDetailScreen(eventServerId: link.id);
        break;
      case 'Items':
        screen = ItemDetailScreen(itemServerId: link.id);
        break;
      case 'Stories':
        screen = StoryDetailScreen(storyServerId: link.id);
        break;
      case 'Religions':
        screen = ReligionDetailScreen(religionServerId: link.id);
        break;
      case 'Technologies':
        screen = TechnologyDetailScreen(technologyServerId: link.id);
        break;
      case 'Languages':
        screen = LanguageDetailScreen(languageServerId: link.id);
        break;
        // Power Systems?
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
}