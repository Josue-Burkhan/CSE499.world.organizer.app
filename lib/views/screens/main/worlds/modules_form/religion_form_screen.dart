import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';

class ReligionFormScreen extends ConsumerStatefulWidget {
  final String? religionLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const ReligionFormScreen({
    super.key,
    this.religionLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<ReligionFormScreen> createState() => _ReligionFormScreenState();
}

class _ReligionFormScreenState extends ConsumerState<ReligionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // Beliefs & Origin
  List<String> _deityNames = [];
  final _originStoryController = TextEditingController();

  // Practices & Traditions
  List<String> _practices = [];
  List<String> _taboos = [];
  List<String> _festivals = [];

  // Sacred Elements
  List<String> _sacredTexts = [];
  List<String> _symbols = [];

  // Links (Raw)
  // Links (Raw)
  List<ModuleLink> _rawCharacters = [];
  List<ModuleLink> _rawFactions = [];
  List<ModuleLink> _rawLocations = [];
  List<ModuleLink> _rawCreatures = [];
  List<ModuleLink> _rawEvents = [];
  List<ModuleLink> _rawPowerSystems = [];
  List<ModuleLink> _rawStories = [];
  List<ModuleLink> _rawTechnologies = [];

  @override
  void initState() {
    super.initState();
    _loadReligion();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _customNotesController.dispose();
    _originStoryController.dispose();
    super.dispose();
  }

  Future<void> _loadReligion() async {
    if (widget.religionLocalId != null) {
      final religion = await ref
          .read(religionRepositoryProvider)
          .getReligion(widget.religionLocalId!);

      if (religion != null) {
        _nameController.text = religion.name;
        _descriptionController.text = religion.description ?? '';
        _customNotesController.text = religion.customNotes ?? '';
        _tagColor = religion.tagColor;
        _deityNames = religion.deityNames;
        _originStoryController.text = religion.originStory ?? '';
        _practices = religion.practices;
        _taboos = religion.taboos;
        _festivals = religion.festivals;
        _sacredTexts = religion.sacredTexts;
        _symbols = religion.symbols;
        
        _rawCharacters = religion.rawCharacters;
        _rawFactions = religion.rawFactions;
        _rawLocations = religion.rawLocations;
        _rawCreatures = religion.rawCreatures;
        _rawEvents = religion.rawEvents;
        _rawPowerSystems = religion.rawPowerSystems;
        _rawStories = religion.rawStories;
        _rawTechnologies = religion.rawTechnologies;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveReligion() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = ReligionsCompanion(
      localId: widget.religionLocalId != null 
          ? drift.Value(widget.religionLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      deityNames: drift.Value(_deityNames),
      originStory: drift.Value(_originStoryController.text.isEmpty ? null : _originStoryController.text),
      practices: drift.Value(_practices),
      taboos: drift.Value(_taboos),
      festivals: drift.Value(_festivals),
      sacredTexts: drift.Value(_sacredTexts),
      symbols: drift.Value(_symbols),
      rawCharacters: drift.Value(_rawCharacters),
      rawFactions: drift.Value(_rawFactions),
      rawLocations: drift.Value(_rawLocations),
      rawCreatures: drift.Value(_rawCreatures),
      rawEvents: drift.Value(_rawEvents),
      rawPowerSystems: drift.Value(_rawPowerSystems),
      rawStories: drift.Value(_rawStories),
      rawTechnologies: drift.Value(_rawTechnologies),
    );

    try {
      if (widget.religionLocalId != null) {
        await ref.read(religionRepositoryProvider).updateReligion(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Religion updated successfully')),
          );
        }
      } else {
        await ref.read(religionRepositoryProvider).createReligion(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Religion created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving religion: $e')),
        );
      }
    }
  }

  List<ModuleLink> _updateLinksList(List<ModuleLink> currentList, List<String> newNames) {
    final Map<String, ModuleLink> existingMap = {
      for (var item in currentList) item.name: item,
    };
    
    return newNames.map((name) {
      if (existingMap.containsKey(name)) {
        return existingMap[name]!;
      }
      return ModuleLink(id: '', name: name);
    }).toList();
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
          title: Text(widget.religionLocalId != null ? 'Edit Religion' : 'New Religion'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveReligion,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Beliefs & Origin'),
              Tab(text: 'Practices'),
              Tab(text: 'Sacred Elements'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildBeliefsTab(),
              _buildPracticesTab(),
              _buildSacredElementsTab(),
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
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            maxLines: 5,
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

  Widget _buildBeliefsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AutocompleteChips(
            label: 'Deity Names',
            initialValues: _deityNames,
            onChanged: (values) => _deityNames = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a deity...',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _originStoryController,
            decoration: const InputDecoration(labelText: 'Origin Story', border: OutlineInputBorder()),
            maxLines: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildPracticesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AutocompleteChips(
            label: 'Practices',
            initialValues: _practices,
            onChanged: (values) => _practices = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a practice...',
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Taboos',
            initialValues: _taboos,
            onChanged: (values) => _taboos = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a taboo...',
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Festivals',
            initialValues: _festivals,
            onChanged: (values) => _festivals = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a festival...',
          ),
        ],
      ),
    );
  }

  Widget _buildSacredElementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AutocompleteChips(
            label: 'Sacred Texts',
            initialValues: _sacredTexts,
            onChanged: (values) => _sacredTexts = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a sacred text...',
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Symbols',
            initialValues: _symbols,
            onChanged: (values) => _symbols = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a symbol...',
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
            onChanged: (values) => _rawCharacters = _updateLinksList(_rawCharacters, values),
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Factions',
            initialValues: _rawFactions.map((e) => e.name).toList(),
            onChanged: (values) => _rawFactions = _updateLinksList(_rawFactions, values),
            searchFunction: (q) => _search(q, 'faction'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Locations',
            initialValues: _rawLocations.map((e) => e.name).toList(),
            onChanged: (values) => _rawLocations = _updateLinksList(_rawLocations, values),
            searchFunction: (q) => _search(q, 'location'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Creatures',
            initialValues: _rawCreatures.map((e) => e.name).toList(),
            onChanged: (values) => _rawCreatures = _updateLinksList(_rawCreatures, values),
            searchFunction: (q) => _search(q, 'creature'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Events',
            initialValues: _rawEvents.map((e) => e.name).toList(),
            onChanged: (values) => _rawEvents = _updateLinksList(_rawEvents, values),
            searchFunction: (q) => _search(q, 'event'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Power Systems',
            initialValues: _rawPowerSystems.map((e) => e.name).toList(),
            onChanged: (values) => _rawPowerSystems = _updateLinksList(_rawPowerSystems, values),
            searchFunction: (q) => _search(q, 'powersystem'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Stories',
            initialValues: _rawStories.map((e) => e.name).toList(),
            onChanged: (values) => _rawStories = _updateLinksList(_rawStories, values),
            searchFunction: (q) => _search(q, 'story'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Technologies',
            initialValues: _rawTechnologies.map((e) => e.name).toList(),
            onChanged: (values) => _rawTechnologies = _updateLinksList(_rawTechnologies, values),
            searchFunction: (q) => _search(q, 'technology'),
          ),
        ],
      ),
    );
  }
}