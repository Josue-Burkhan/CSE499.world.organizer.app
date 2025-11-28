import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/models/api_models/search_result_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/character_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/ability_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/creature_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/economy_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/event_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/faction_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/item_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/language_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/location_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/powersystem_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/race_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/religion_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/story_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/technology_detail_screen.dart';

final searchResultsProvider = StateProvider<AsyncValue<List<SearchResult>>>(
  (ref) => const AsyncValue.data([])
);

class WorldSearchScreen extends ConsumerStatefulWidget {
  final String worldServerId;

  const WorldSearchScreen({super.key, required this.worldServerId});

  @override
  ConsumerState<WorldSearchScreen> createState() => _WorldSearchScreenState();
}

class _WorldSearchScreenState extends ConsumerState<WorldSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length < 2) {
        ref.read(searchResultsProvider.notifier).state = const AsyncValue.data([]);
        return;
      }
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    ref.read(searchResultsProvider.notifier).state = const AsyncValue.loading();
    try {
      final results = await ref
          .read(worldSyncServiceProvider)
          .searchInWorld(widget.worldServerId, query);
      ref.read(searchResultsProvider.notifier).state = AsyncValue.data(results);
    } catch (e, st) {
      ref.read(searchResultsProvider.notifier).state = AsyncValue.error(e, st);
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'character': return Icons.people;
      case 'location': return Icons.map;
      case 'faction': return Icons.group_work;
      case 'item': return Icons.shield;
      case 'event': return Icons.event;
      case 'language': return Icons.language;
      case 'ability': return Icons.star;
      case 'technology': return Icons.memory;
      case 'powersystem': return Icons.flash_on;
      case 'creature': return Icons.adb;
      case 'religion': return Icons.book;
      case 'story': return Icons.auto_stories;
      case 'race': return Icons.face;
      case 'economy': return Icons.monetization_on;
      case 'world': return Icons.public;
      default: return Icons.category;
    }
  }

  void _navigateToResult(SearchResult result) {
    switch (result.type.toLowerCase()) {
      case 'character':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CharacterDetailScreen(
              characterServerId: result.id,
            ),
          ),
        );
        break;
      case 'ability':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AbilityDetailScreen(
              abilityServerId: result.id,
            ),
          ),
        );
        break;
      case 'location':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LocationDetailScreen(
              locationServerId: result.id,
            ),
          ),
        );
        break;
      case 'faction':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FactionDetailScreen(
              factionServerId: result.id,
            ),
          ),
        );
        break;
      case 'item':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ItemDetailScreen(
              itemServerId: result.id,
            ),
          ),
        );
        break;
      case 'event':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              eventServerId: result.id,
            ),
          ),
        );
        break;
      case 'language':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LanguageDetailScreen(
              languageServerId: result.id,
            ),
          ),
        );
        break;
      case 'technology':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TechnologyDetailScreen(
              technologyServerId: result.id,
            ),
          ),
        );
        break;
      case 'powersystem':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PowerSystemDetailScreen(
              powerSystemServerId: result.id,
            ),
          ),
        );
        break;
      case 'creature':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreatureDetailScreen(
              creatureServerId: result.id,
            ),
          ),
        );
        break;
      case 'religion':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReligionDetailScreen(
              religionServerId: result.id,
            ),
          ),
        );
        break;
      case 'story':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(
              storyServerId: result.id,
            ),
          ),
        );
        break;
      case 'race':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RaceDetailScreen(
              raceServerId: result.id,
            ),
          ),
        );
        break;
      case 'economy':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EconomyDetailScreen(
              economyServerId: result.id,
            ),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigation for ${result.type} is not implemented.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search in this world...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              _onSearchChanged('');
            },
          )
        ],
      ),
      body: searchState.when(
        data: (results) {
          if (_controller.text.length < 2) {
            return const Center(
              child: Text('Enter at least 2 characters to search.'),
            );
          }
          if (results.isEmpty) {
            return const Center(
              child: Text('No results found.'),
            );
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                leading: Icon(_getTypeIcon(result.type)),
                title: Text(result.name),
                subtitle: Text(result.type),
                onTap: () {
                  _navigateToResult(result);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 60, color: Colors.grey[600]),
                const SizedBox(height: 16),
                const Text(
                  'Search Failed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}