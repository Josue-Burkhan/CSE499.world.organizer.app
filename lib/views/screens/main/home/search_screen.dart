import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/world_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/character_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/item_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/location_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/ability_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/creature_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/economy_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/event_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/faction_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/language_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/powersystem_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/race_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/religion_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/story_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/technology_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String initialQuery;

  const SearchScreen({super.key, required this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  List<dynamic> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      _performSearch(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final results = await apiService.search(query);
      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _results = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching: $e')),
        );
      }
    }
  }

  void _navigateToDetail(dynamic item) {
    final type = item['type'].toString().toLowerCase();
    final id = item['_id'] ?? item['id']; 
    
    switch (type) {
      case 'character':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => CharacterDetailScreen(characterServerId: id)));
        break;
      case 'item':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemDetailScreen(itemServerId: id)));
        break;
      case 'location':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => LocationDetailScreen(locationServerId: id)));
        break;
      case 'ability':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => AbilityDetailScreen(abilityServerId: id)));
        break;
      case 'creature':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreatureDetailScreen(creatureServerId: id)));
        break;
      case 'economy':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => EconomyDetailScreen(economyServerId: id)));
        break;
      case 'event':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailScreen(eventServerId: id)));
        break;
      case 'faction':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => FactionDetailScreen(factionServerId: id)));
        break;
      case 'language':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => LanguageDetailScreen(languageServerId: id)));
        break;
      case 'powersystem':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => PowerSystemDetailScreen(powerSystemServerId: id)));
        break;
      case 'race':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => RaceDetailScreen(raceServerId: id)));
        break;
      case 'religion':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReligionDetailScreen(religionServerId: id)));
        break;
      case 'story':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => StoryDetailScreen(storyServerId: id)));
        break;
      case 'technology':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => TechnologyDetailScreen(technologyServerId: id)));
        break;
      case 'world':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => WorldDetailScreen(localWorldId: id))); 
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigation for $type is not implemented yet.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onChanged: _onSearchChanged,
          onSubmitted: _performSearch,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final item = _results[index];
                    return ListTile(
                      title: Text(item['name'] ?? 'Unknown'),
                      subtitle: Text(item['type'] ?? 'Unknown Type'),
                      onTap: () => _navigateToDetail(item),
                    );
                  },
                ),
    );
  }
}
