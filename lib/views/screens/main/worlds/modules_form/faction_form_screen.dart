import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/faction_model.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';

class FactionFormScreen extends ConsumerStatefulWidget {
  final String? factionLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const FactionFormScreen({
    super.key,
    this.factionLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<FactionFormScreen> createState() => _FactionFormScreenState();
}

class _FactionFormScreenState extends ConsumerState<FactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeController = TextEditingController();
  final _symbolController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // Details
  final _economicSystemController = TextEditingController();
  final _technologyController = TextEditingController();
  final _historyController = TextEditingController();
  List<String> _goals = [];

  // Relationships (Raw)
  List<String> _rawAllies = [];
  List<String> _rawEnemies = [];

  // Links (Raw)
  List<ModuleLink> _rawCharacters = [];
  List<ModuleLink> _rawLocations = [];
  List<ModuleLink> _rawHeadquarters = [];
  List<ModuleLink> _rawTerritory = [];
  List<ModuleLink> _rawEvents = [];
  List<ModuleLink> _rawItems = [];
  List<ModuleLink> _rawStories = [];
  List<ModuleLink> _rawReligions = [];
  List<ModuleLink> _rawTechnologies = [];
  List<ModuleLink> _rawLanguages = [];
  List<ModuleLink> _rawPowerSystems = [];

  List<ModuleLink> _updateLinksList(List<String> newNames, List<ModuleLink> currentLinks) {
    final currentMap = {for (var e in currentLinks) e.name: e};
    return newNames.map((name) {
      if (currentMap.containsKey(name)) {
        return currentMap[name]!;
      }
      return ModuleLink(id: '', name: name);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadFaction();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _symbolController.dispose();
    _customNotesController.dispose();
    _economicSystemController.dispose();
    _technologyController.dispose();
    _historyController.dispose();
    super.dispose();
  }

  Future<void> _loadFaction() async {
    if (widget.factionLocalId != null) {
      final faction = await ref
          .read(factionRepositoryProvider)
          .getFaction(widget.factionLocalId!);

      if (faction != null) {
        _nameController.text = faction.name;
        _descriptionController.text = faction.description ?? '';
        _typeController.text = faction.type ?? '';
        _symbolController.text = faction.symbol ?? '';
        _customNotesController.text = faction.customNotes ?? '';
        _tagColor = faction.tagColor;

        _economicSystemController.text = faction.economicSystem ?? '';
        _technologyController.text = faction.technology ?? '';
        _historyController.text = faction.history ?? '';
        _goals = faction.goals;

        if (faction.rawAllies.isNotEmpty) {
          _rawAllies = faction.rawAllies;
        } else if (faction.alliesJson != null) {
          final List<dynamic> list = jsonDecode(faction.alliesJson!);
          _rawAllies = list.map((e) => FactionRelation.fromJson(e).name).toList();
        }

        if (faction.rawEnemies.isNotEmpty) {
          _rawEnemies = faction.rawEnemies;
        } else if (faction.enemiesJson != null) {
          final List<dynamic> list = jsonDecode(faction.enemiesJson!);
          _rawEnemies = list.map((e) => FactionRelation.fromJson(e).name).toList();
        }

        _rawCharacters = faction.rawCharacters;
        _rawLocations = faction.rawLocations;
        _rawHeadquarters = faction.rawHeadquarters;
        _rawTerritory = faction.rawTerritory;
        _rawEvents = faction.rawEvents;
        _rawItems = faction.rawItems;
        _rawStories = faction.rawStories;
        _rawReligions = faction.rawReligions;
        _rawTechnologies = faction.rawTechnologies;
        _rawLanguages = faction.rawLanguages;
        _rawPowerSystems = faction.rawPowerSystems;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveFaction() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = FactionsCompanion(
      localId: widget.factionLocalId != null 
          ? drift.Value(widget.factionLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      type: drift.Value(_typeController.text.isEmpty ? null : _typeController.text),
      symbol: drift.Value(_symbolController.text.isEmpty ? null : _symbolController.text),
      economicSystem: drift.Value(_economicSystemController.text.isEmpty ? null : _economicSystemController.text),
      technology: drift.Value(_technologyController.text.isEmpty ? null : _technologyController.text),
      goals: drift.Value(_goals),
      history: drift.Value(_historyController.text.isEmpty ? null : _historyController.text),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      rawAllies: drift.Value(_rawAllies),
      rawEnemies: drift.Value(_rawEnemies),
      rawCharacters: drift.Value(_rawCharacters),
      rawLocations: drift.Value(_rawLocations),
      rawHeadquarters: drift.Value(_rawHeadquarters),
      rawTerritory: drift.Value(_rawTerritory),
      rawEvents: drift.Value(_rawEvents),
      rawItems: drift.Value(_rawItems),
      rawStories: drift.Value(_rawStories),
      rawReligions: drift.Value(_rawReligions),
      rawTechnologies: drift.Value(_rawTechnologies),
      rawLanguages: drift.Value(_rawLanguages),
      rawPowerSystems: drift.Value(_rawPowerSystems),
    );

    try {
      if (widget.factionLocalId != null) {
        await ref.read(factionRepositoryProvider).updateFaction(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Faction updated successfully')),
          );
        }
      } else {
        await ref.read(factionRepositoryProvider).createFaction(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Faction created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving faction: $e')),
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
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.factionLocalId != null ? 'Edit Faction' : 'New Faction'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveFaction,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Details'),
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
              _buildDetailsTab(),
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
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _symbolController,
                  decoration: const InputDecoration(labelText: 'Symbol', border: OutlineInputBorder()),
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

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _economicSystemController,
            decoration: const InputDecoration(labelText: 'Economic System', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _technologyController,
            decoration: const InputDecoration(labelText: 'Technology Level', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Goals',
            initialValues: _goals,
            onChanged: (values) => _goals = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a goal...',
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
            controller: _historyController,
            decoration: const InputDecoration(labelText: 'History', border: OutlineInputBorder()),
            maxLines: 10,
          ),
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
            label: 'Allies',
            initialValues: _rawAllies,
            onChanged: (values) => _rawAllies = values,
            searchFunction: (q) => _search(q, 'faction'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Enemies',
            initialValues: _rawEnemies,
            onChanged: (values) => _rawEnemies = values,
            searchFunction: (q) => _search(q, 'faction'),
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
            label: 'Characters',
            initialValues: _rawCharacters.map((e) => e.name).toList(),
            onChanged: (values) => _rawCharacters = _updateLinksList(values, _rawCharacters),
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Locations',
            initialValues: _rawLocations.map((e) => e.name).toList(),
            onChanged: (values) => _rawLocations = _updateLinksList(values, _rawLocations),
            searchFunction: (q) => _search(q, 'location'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Headquarters',
            initialValues: _rawHeadquarters.map((e) => e.name).toList(),
            onChanged: (values) => _rawHeadquarters = _updateLinksList(values, _rawHeadquarters),
            searchFunction: (q) => _search(q, 'location'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Territory',
            initialValues: _rawTerritory.map((e) => e.name).toList(),
            onChanged: (values) => _rawTerritory = _updateLinksList(values, _rawTerritory),
            searchFunction: (q) => _search(q, 'location'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Events',
            initialValues: _rawEvents.map((e) => e.name).toList(),
            onChanged: (values) => _rawEvents = _updateLinksList(values, _rawEvents),
            searchFunction: (q) => _search(q, 'event'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Items',
            initialValues: _rawItems.map((e) => e.name).toList(),
            onChanged: (values) => _rawItems = _updateLinksList(values, _rawItems),
            searchFunction: (q) => _search(q, 'item'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Stories',
            initialValues: _rawStories.map((e) => e.name).toList(),
            onChanged: (values) => _rawStories = _updateLinksList(values, _rawStories),
            searchFunction: (q) => _search(q, 'story'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Religions',
            initialValues: _rawReligions.map((e) => e.name).toList(),
            onChanged: (values) => _rawReligions = _updateLinksList(values, _rawReligions),
            searchFunction: (q) => _search(q, 'religion'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Technologies',
            initialValues: _rawTechnologies.map((e) => e.name).toList(),
            onChanged: (values) => _rawTechnologies = _updateLinksList(values, _rawTechnologies),
            searchFunction: (q) => _search(q, 'technology'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Languages',
            initialValues: _rawLanguages.map((e) => e.name).toList(),
            onChanged: (values) => _rawLanguages = _updateLinksList(values, _rawLanguages),
            searchFunction: (q) => _search(q, 'language'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Power Systems',
            initialValues: _rawPowerSystems.map((e) => e.name).toList(),
            onChanged: (values) => _rawPowerSystems = _updateLinksList(values, _rawPowerSystems),
            searchFunction: (q) => _search(q, 'powersystem'),
          ),
        ],
      ),
    );
  }
}