import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/models/api_models/search_result_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/character_detail_screen.dart';

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