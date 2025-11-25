import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/faction_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

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
    if (faction.alliesJson != null) {
      allies = (jsonDecode(faction.alliesJson!) as List)
          .map((i) => FactionRelation.fromJson(i))
          .toList();
    }
    List<FactionRelation> enemies = [];
    if (faction.enemiesJson != null) {
      enemies = (jsonDecode(faction.enemiesJson!) as List)
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
              _buildBasicInfo(faction),
              _buildRelationships(context, 'Relationships', allies, enemies),
              _buildGoals(faction),
              if (faction.history != null) _buildHistory(faction.history!),
              if (faction.customNotes != null) _buildCustomNotes(faction.customNotes!),
              _buildRawList('Characters', faction.rawCharacters),
              _buildRawList('Locations', faction.rawLocations),
              _buildRawList('Headquarters', faction.rawHeadquarters),
              _buildRawList('Territory', faction.rawTerritory),
              _buildRawList('Events', faction.rawEvents),
              _buildRawList('Items', faction.rawItems),
              _buildRawList('Stories', faction.rawStories),
              _buildRawList('Religions', faction.rawReligions),
              _buildRawList('Technologies', faction.rawTechnologies),
              _buildRawList('Languages', faction.rawLanguages),
              _buildRawList('Power Systems', faction.rawPowerSystems),
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
           if (faction.description != null)
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(faction.description!),
              subtitle: const Text('Description'),
            ),
          if (faction.type != null)
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: Text(faction.type!),
              subtitle: const Text('Type'),
            ),
          if (faction.symbol != null)
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(faction.symbol!),
              subtitle: const Text('Symbol'),
            ),
          if (faction.economicSystem != null)
            ListTile(
              leading: const Icon(Icons.attach_money_outlined),
              title: Text(faction.economicSystem!),
              subtitle: const Text('Economic System'),
            ),
          if (faction.technology != null)
            ListTile(
              leading: const Icon(Icons.science_outlined),
              title: Text(faction.technology!),
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
    if (relations.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4.0),
        Wrap(
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

  Widget _buildHistory(String history) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(history),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNotes(String notes) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Custom Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(notes),
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

  Widget _buildChipSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: items.map((item) => Chip(label: Text(item))).toList(),
        ),
      ],
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