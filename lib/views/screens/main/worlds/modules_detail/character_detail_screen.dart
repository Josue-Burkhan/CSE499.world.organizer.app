import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/character_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final characterDetailStreamProvider =
    StreamProvider.family.autoDispose<CharacterEntity?, String>((ref, serverId) {
  return ref.watch(characterRepositoryProvider).watchCharacterByServerId(serverId);
});

final characterDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(characterSyncServiceProvider);
  await syncService.fetchAndMergeSingleCharacter(serverId);
});

class CharacterDetailScreen extends ConsumerWidget {
  final String characterServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const CharacterDetailScreen({
    super.key,
    required this.characterServerId,
  });

  String? _getImageUrl(CharacterEntity char) {
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
    final asyncCharacter = ref.watch(characterDetailStreamProvider(characterServerId));

    ref.listen(characterDetailSyncProvider(characterServerId), (prev, next) {
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

    return asyncCharacter.when(
      data: (character) {
        if (character == null) {
          return ref.watch(characterDetailSyncProvider(characterServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load character: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Character not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, character);
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

  Widget _buildDetailScaffold(BuildContext context, CharacterEntity character) {
    final imageUrl = _getImageUrl(character);
    final tagColor = _getTagColor(character.tagColor);

    Appearance? appearance;
    if (character.appearanceJson != null) {
      appearance = Appearance.fromJson(jsonDecode(character.appearanceJson!));
    }

    Personality? personality;
    if (character.personalityJson != null) {
      personality = Personality.fromJson(jsonDecode(character.personalityJson!));
    }
    
    List<CharacterRelation> family = [];
    if (character.familyJson != null) {
      family = (jsonDecode(character.familyJson!) as List)
          .map((i) => CharacterRelation.fromJson(i))
          .toList();
    }
    List<CharacterRelation> friends = [];
    if (character.friendsJson != null) {
      friends = (jsonDecode(character.friendsJson!) as List)
          .map((i) => CharacterRelation.fromJson(i))
          .toList();
    }
    List<CharacterRelation> enemies = [];
    if (character.enemiesJson != null) {
      enemies = (jsonDecode(character.enemiesJson!) as List)
          .map((i) => CharacterRelation.fromJson(i))
          .toList();
    }
    List<CharacterRelation> romance = [];
    if (character.romanceJson != null) {
      romance = (jsonDecode(character.romanceJson!) as List)
          .map((i) => CharacterRelation.fromJson(i))
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
              title: Text(character.name),
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
              _buildBasicInfo(character),
              _buildRelationships(context, 'Relationships', family, friends, enemies, romance),
              if (appearance != null) _buildAppearance(appearance),
              if (personality != null) _buildPersonality(personality),
              _buildRawList('Factions', character.rawFactions),
              _buildRawList('Races', character.rawRaces),
              _buildRawList('Abilities', character.rawAbilities),
              _buildRawList('Items', character.rawItems),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(CharacterEntity char) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.cake_outlined),
            title: Text(char.age?.toString() ?? 'Unknown'),
            subtitle: const Text('Age'),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(char.gender ?? 'Unknown'),
            subtitle: const Text('Gender'),
          ),
          ListTile(
            leading: const Icon(Icons.label_outline),
            title: Text(char.nickname ?? 'None'),
            subtitle: const Text('Nickname'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRelationships(
    BuildContext context,
    String title,
    List<CharacterRelation> family,
    List<CharacterRelation> friends,
    List<CharacterRelation> enemies,
    List<CharacterRelation> romance,
  ) {
    if (family.isEmpty && friends.isEmpty && enemies.isEmpty && romance.isEmpty) {
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
            _buildRelationChipList(context, 'Family', family),
            _buildRelationChipList(context, 'Friends', friends),
            _buildRelationChipList(context, 'Enemies', enemies),
            _buildRelationChipList(context, 'Romance', romance),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationChipList(BuildContext context, String title, List<CharacterRelation> relations) {
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
                  builder: (context) => CharacterDetailScreen(
                    characterServerId: rel.id,
                  ),
                ),
              );
            },
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildAppearance(Appearance appearance) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text(appearance.height?.toString() ?? 'Unknown'),
            subtitle: const Text('Height (cm)'),
          ),
          ListTile(
            title: Text(appearance.weight?.toString() ?? 'Unknown'),
            subtitle: const Text('Weight (kg)'),
          ),
          ListTile(
            title: Text(appearance.hairColor ?? 'Unknown'),
            subtitle: const Text('Hair Color'),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonality(Personality personality) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personality', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildChipSection('Traits', personality.traits),
            _buildChipSection('Strengths', personality.strengths),
            _buildChipSection('Weaknesses', personality.weaknesses),
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