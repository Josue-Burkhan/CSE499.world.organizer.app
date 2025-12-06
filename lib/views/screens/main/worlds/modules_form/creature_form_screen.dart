import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';

class CreatureFormScreen extends ConsumerStatefulWidget {
  final String? creatureLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const CreatureFormScreen({
    super.key,
    this.creatureLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<CreatureFormScreen> createState() => _CreatureFormScreenState();
}

class _CreatureFormScreenState extends ConsumerState<CreatureFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _speciesTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _habitatController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';
  bool? _domesticated;

  // Weaknesses
  List<String> _weaknesses = [];

  // Links (Raw)
  List<String> _rawCharacters = [];
  List<String> _rawAbilities = [];
  List<String> _rawFactions = [];
  List<String> _rawEvents = [];
  List<String> _rawStories = [];
  List<String> _rawLocations = [];
  List<String> _rawPowerSystems = [];
  List<String> _rawReligions = [];

  @override
  void initState() {
    super.initState();
    _loadCreature();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesTypeController.dispose();
    _descriptionController.dispose();
    _habitatController.dispose();
    _customNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadCreature() async {
    if (widget.creatureLocalId != null) {
      final creature = await ref
          .read(creatureRepositoryProvider)
          .getCreature(widget.creatureLocalId!);

      if (creature != null) {
        _nameController.text = creature.name;
        _speciesTypeController.text = creature.speciesType ?? '';
        _descriptionController.text = creature.description;
        _habitatController.text = creature.habitat;
        _customNotesController.text = creature.customNotes ?? '';
        _tagColor = creature.tagColor;
        _domesticated = creature.domesticated;
        _weaknesses = creature.weaknesses;

        _rawCharacters = creature.rawCharacters;
        _rawAbilities = creature.rawAbilities;
        _rawFactions = creature.rawFactions;
        _rawEvents = creature.rawEvents;
        _rawStories = creature.rawStories;
        _rawLocations = creature.rawLocations;
        _rawPowerSystems = creature.rawPowerSystems;
        _rawReligions = creature.rawReligions;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveCreature() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = CreaturesCompanion(
      localId: widget.creatureLocalId != null 
          ? drift.Value(widget.creatureLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      speciesType: drift.Value(_speciesTypeController.text.isEmpty ? null : _speciesTypeController.text),
      description: drift.Value(_descriptionController.text),
      habitat: drift.Value(_habitatController.text),
      weaknesses: drift.Value(_weaknesses),
      domesticated: drift.Value(_domesticated),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      rawCharacters: drift.Value(_rawCharacters),
      rawAbilities: drift.Value(_rawAbilities),
      rawFactions: drift.Value(_rawFactions),
      rawEvents: drift.Value(_rawEvents),
      rawStories: drift.Value(_rawStories),
      rawLocations: drift.Value(_rawLocations),
      rawPowerSystems: drift.Value(_rawPowerSystems),
      rawReligions: drift.Value(_rawReligions),
    );

    try {
      if (widget.creatureLocalId != null) {
        await ref.read(creatureRepositoryProvider).updateCreature(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Creature updated successfully')),
          );
        }
      } else {
        await ref.read(creatureRepositoryProvider).createCreature(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Creature created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving creature: $e')),
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.creatureLocalId != null ? 'Edit Creature' : 'New Creature'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveCreature,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Details'),
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
            controller: _speciesTypeController,
            decoration: const InputDecoration(labelText: 'Species Type', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            maxLines: 4,
            validator: (value) => value == null || value.isEmpty ? 'Description is required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _habitatController,
            decoration: const InputDecoration(labelText: 'Habitat', border: OutlineInputBorder()),
            maxLines: 2,
            validator: (value) => value == null || value.isEmpty ? 'Habitat is required' : null,
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
          DropdownButtonFormField<bool?>(
            value: _domesticated,
            decoration: const InputDecoration(labelText: 'Domesticated', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: null, child: Text('Unknown')),
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) => setState(() => _domesticated = value),
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

  Widget _buildLinksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AutocompleteChips(
            label: 'Characters',
            initialValues: _rawCharacters,
            onChanged: (values) => _rawCharacters = values,
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Abilities',
            initialValues: _rawAbilities,
            onChanged: (values) => _rawAbilities = values,
            searchFunction: (q) => _search(q, 'ability'),
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
            label: 'Events',
            initialValues: _rawEvents,
            onChanged: (values) => _rawEvents = values,
            searchFunction: (q) => _search(q, 'event'),
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
            label: 'Locations',
            initialValues: _rawLocations,
            onChanged: (values) => _rawLocations = values,
            searchFunction: (q) => _search(q, 'location'),
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
        ],
      ),
    );
  }
}