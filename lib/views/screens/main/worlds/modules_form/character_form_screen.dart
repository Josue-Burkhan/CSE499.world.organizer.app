import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/character_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';

class CharacterFormScreen extends ConsumerStatefulWidget {
  final String? characterLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const CharacterFormScreen({
    super.key,
    this.characterLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<CharacterFormScreen> createState() => _CharacterFormScreenState();
}

class _CharacterFormScreenState extends ConsumerState<CharacterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // Appearance
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _eyeColorController = TextEditingController();
  final _hairColorController = TextEditingController();
  final _clothingStyleController = TextEditingController();

  // Personality
  List<String> _traits = [];
  List<String> _strengths = [];
  List<String> _weaknesses = [];

  // History
  final _birthplaceController = TextEditingController();

  // Relationships (Raw)
  List<String> _rawFamily = [];
  List<String> _rawFriends = [];
  List<String> _rawEnemies = [];
  List<String> _rawRomance = [];

  // Links (Raw)
  List<String> _rawAbilities = [];
  List<String> _rawItems = [];
  List<String> _rawLanguages = [];
  List<String> _rawRaces = [];
  List<String> _rawFactions = [];
  List<String> _rawLocations = [];
  List<String> _rawPowerSystems = [];
  List<String> _rawReligions = [];
  List<String> _rawCreatures = [];
  List<String> _rawEconomies = [];
  List<String> _rawStories = [];
  List<String> _rawTechnologies = [];

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _nicknameController.dispose();
    _customNotesController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _eyeColorController.dispose();
    _hairColorController.dispose();
    _clothingStyleController.dispose();
    _birthplaceController.dispose();
    super.dispose();
  }

  Future<void> _loadCharacter() async {
    if (widget.characterLocalId != null) {
      final character = await ref
          .read(characterRepositoryProvider)
          .getCharacter(widget.characterLocalId!);

      if (character != null) {
        _nameController.text = character.name;
        _ageController.text = character.age?.toString() ?? '';
        _genderController.text = character.gender ?? '';
        _nicknameController.text = character.nickname ?? '';
        _customNotesController.text = character.customNotes ?? '';
        _tagColor = character.tagColor;

        if (character.appearanceJson != null) {
          final appearance = Appearance.fromJson(jsonDecode(character.appearanceJson!));
          _heightController.text = appearance.height?.toString() ?? '';
          _weightController.text = appearance.weight?.toString() ?? '';
          _eyeColorController.text = appearance.eyeColor ?? '';
          _hairColorController.text = appearance.hairColor ?? '';
          _clothingStyleController.text = appearance.clothingStyle ?? '';
        }

        if (character.personalityJson != null) {
          final personality = Personality.fromJson(jsonDecode(character.personalityJson!));
          _traits = personality.traits;
          _strengths = personality.strengths;
          _weaknesses = personality.weaknesses;
        }

        if (character.historyJson != null) {
          final history = History.fromJson(jsonDecode(character.historyJson!));
          _birthplaceController.text = history.birthplace ?? '';
        }

        if (character.rawFamily.isNotEmpty) {
          _rawFamily = character.rawFamily;
        } else if (character.familyJson != null) {
           final List<dynamic> list = jsonDecode(character.familyJson!);
           _rawFamily = list.map((e) => CharacterRelation.fromJson(e).name).toList();
        }

        if (character.rawFriends.isNotEmpty) {
          _rawFriends = character.rawFriends;
        } else if (character.friendsJson != null) {
           final List<dynamic> list = jsonDecode(character.friendsJson!);
           _rawFriends = list.map((e) => CharacterRelation.fromJson(e).name).toList();
        }

        if (character.rawEnemies.isNotEmpty) {
          _rawEnemies = character.rawEnemies;
        } else if (character.enemiesJson != null) {
           final List<dynamic> list = jsonDecode(character.enemiesJson!);
           _rawEnemies = list.map((e) => CharacterRelation.fromJson(e).name).toList();
        }

        if (character.rawRomance.isNotEmpty) {
          _rawRomance = character.rawRomance;
        } else if (character.romanceJson != null) {
           final List<dynamic> list = jsonDecode(character.romanceJson!);
           _rawRomance = list.map((e) => CharacterRelation.fromJson(e).name).toList();
        }

        _rawAbilities = character.rawAbilities;
        _rawItems = character.rawItems;
        _rawLanguages = character.rawLanguages;
        _rawRaces = character.rawRaces;
        _rawFactions = character.rawFactions;
        _rawLocations = character.rawLocations;
        _rawPowerSystems = character.rawPowerSystems;
        _rawReligions = character.rawReligions;
        _rawCreatures = character.rawCreatures;
        _rawEconomies = character.rawEconomies;
        _rawStories = character.rawStories;
        _rawTechnologies = character.rawTechnologies;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;

    final appearance = Appearance(
      height: num.tryParse(_heightController.text),
      weight: num.tryParse(_weightController.text),
      eyeColor: _eyeColorController.text.isEmpty ? null : _eyeColorController.text,
      hairColor: _hairColorController.text.isEmpty ? null : _hairColorController.text,
      clothingStyle: _clothingStyleController.text.isEmpty ? null : _clothingStyleController.text,
    );

    final personality = Personality(
      traits: _traits,
      strengths: _strengths,
      weaknesses: _weaknesses,
    );

    final history = History(
      birthplace: _birthplaceController.text.isEmpty ? null : _birthplaceController.text,
      events: [],
    );

    final companion = CharactersCompanion(
      localId: widget.characterLocalId != null 
          ? drift.Value(widget.characterLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      age: drift.Value(int.tryParse(_ageController.text)),
      gender: drift.Value(_genderController.text.isEmpty ? null : _genderController.text),
      nickname: drift.Value(_nicknameController.text.isEmpty ? null : _nicknameController.text),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      appearanceJson: drift.Value(jsonEncode(appearance.toJson())),
      personalityJson: drift.Value(jsonEncode(personality.toJson())),
      historyJson: drift.Value(jsonEncode(history.toJson())),
      rawFamily: drift.Value(_rawFamily),
      rawFriends: drift.Value(_rawFriends),
      rawEnemies: drift.Value(_rawEnemies),
      rawRomance: drift.Value(_rawRomance),
      rawAbilities: drift.Value(_rawAbilities),
      rawItems: drift.Value(_rawItems),
      rawLanguages: drift.Value(_rawLanguages),
      rawRaces: drift.Value(_rawRaces),
      rawFactions: drift.Value(_rawFactions),
      rawLocations: drift.Value(_rawLocations),
      rawPowerSystems: drift.Value(_rawPowerSystems),
      rawReligions: drift.Value(_rawReligions),
      rawCreatures: drift.Value(_rawCreatures),
      rawEconomies: drift.Value(_rawEconomies),
      rawStories: drift.Value(_rawStories),
      rawTechnologies: drift.Value(_rawTechnologies),
    );

    try {
      if (widget.characterLocalId != null) {
        await ref.read(characterRepositoryProvider).updateCharacter(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Character updated successfully')),
          );
        }
      } else {
        await ref.read(characterRepositoryProvider).createCharacter(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Character created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving character: $e')),
        );
      }
    }
  }

  Future<List<String>> _search(String query, String type) async {
    if (widget.worldServerId == null) return [];
    try {
      final results = await ref
          .read(worldSyncServiceProvider)
          .searchInWorld(widget.worldServerId!, query, type: type);
      return results.map((r) => r.name).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.characterLocalId != null ? 'Edit Character' : 'New Character'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveCharacter,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Appearance'),
              Tab(text: 'Personality'),
              Tab(text: 'History'),
              Tab(text: 'Relationships'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildAppearanceTab(),
              _buildPersonalityTab(),
              _buildHistoryTab(),
              _buildRelationshipsTab(),
              _buildLinksTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nicknameController,
            decoration: const InputDecoration(labelText: 'Nickname', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _tagColor,
            decoration: const InputDecoration(labelText: 'Tag Color', border: OutlineInputBorder()),
            items: ['neutral', 'blue', 'purple', 'green', 'red', 'amber', 'lime', 'black']
                .map((color) => DropdownMenuItem(value: color, child: Text(color)))
                .toList(),
            onChanged: (value) => setState(() => _tagColor = value!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _customNotesController,
            decoration: const InputDecoration(labelText: 'Custom Notes', border: OutlineInputBorder()),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Height', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _eyeColorController,
            decoration: const InputDecoration(labelText: 'Eye Color', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _hairColorController,
            decoration: const InputDecoration(labelText: 'Hair Color', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _clothingStyleController,
            decoration: const InputDecoration(labelText: 'Clothing Style', border: OutlineInputBorder()),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AutocompleteChips(
            label: 'Traits',
            initialValues: _traits,
            onChanged: (values) => _traits = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a trait...',
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Strengths',
            initialValues: _strengths,
            onChanged: (values) => _strengths = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a strength...',
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Weaknesses',
            initialValues: _weaknesses,
            onChanged: (values) => _weaknesses = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a weakness...',
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _birthplaceController,
            decoration: const InputDecoration(labelText: 'Birthplace', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          const Text('Events implementation coming soon...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRelationshipsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AutocompleteChips(
            label: 'Family',
            initialValues: _rawFamily,
            onChanged: (values) => _rawFamily = values,
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Friends',
            initialValues: _rawFriends,
            onChanged: (values) => _rawFriends = values,
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Enemies',
            initialValues: _rawEnemies,
            onChanged: (values) => _rawEnemies = values,
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Romance',
            initialValues: _rawRomance,
            onChanged: (values) => _rawRomance = values,
            searchFunction: (q) => _search(q, 'character'),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AutocompleteChips(
            label: 'Abilities',
            initialValues: _rawAbilities,
            onChanged: (values) => _rawAbilities = values,
            searchFunction: (q) => _search(q, 'ability'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Items',
            initialValues: _rawItems,
            onChanged: (values) => _rawItems = values,
            searchFunction: (q) => _search(q, 'item'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Factions',
            initialValues: _rawFactions,
            onChanged: (values) => _rawFactions = values,
            searchFunction: (q) => _search(q, 'faction'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Locations',
            initialValues: _rawLocations,
            onChanged: (values) => _rawLocations = values,
            searchFunction: (q) => _search(q, 'location'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Races',
            initialValues: _rawRaces,
            onChanged: (values) => _rawRaces = values,
            searchFunction: (q) => _search(q, 'race'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Languages',
            initialValues: _rawLanguages,
            onChanged: (values) => _rawLanguages = values,
            searchFunction: (q) => _search(q, 'language'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Power Systems',
            initialValues: _rawPowerSystems,
            onChanged: (values) => _rawPowerSystems = values,
            searchFunction: (q) => _search(q, 'powersystem'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Religions',
            initialValues: _rawReligions,
            onChanged: (values) => _rawReligions = values,
            searchFunction: (q) => _search(q, 'religion'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Creatures',
            initialValues: _rawCreatures,
            onChanged: (values) => _rawCreatures = values,
            searchFunction: (q) => _search(q, 'creature'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Economies',
            initialValues: _rawEconomies,
            onChanged: (values) => _rawEconomies = values,
            searchFunction: (q) => _search(q, 'economy'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Stories',
            initialValues: _rawStories,
            onChanged: (values) => _rawStories = values,
            searchFunction: (q) => _search(q, 'story'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Technologies',
            initialValues: _rawTechnologies,
            onChanged: (values) => _rawTechnologies = values,
            searchFunction: (q) => _search(q, 'technology'),
          ),
        ],
      ),
    );
  }
}