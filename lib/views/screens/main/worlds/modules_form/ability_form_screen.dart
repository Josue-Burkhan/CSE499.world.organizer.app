import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';

class AbilityFormScreen extends ConsumerStatefulWidget {
  final String? abilityLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const AbilityFormScreen({
    super.key,
    this.abilityLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<AbilityFormScreen> createState() => _AbilityFormScreenState();
}

class _AbilityFormScreenState extends ConsumerState<AbilityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeController = TextEditingController();
  final _elementController = TextEditingController();
  final _cooldownController = TextEditingController();
  final _costController = TextEditingController();
  final _levelController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _effectController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // Links (Raw)
  List<ModuleLink> _rawCharacters = [];
  List<ModuleLink> _rawPowerSystems = [];
  List<ModuleLink> _rawStories = [];
  List<ModuleLink> _rawEvents = [];
  List<ModuleLink> _rawItems = [];
  List<ModuleLink> _rawReligions = [];
  List<ModuleLink> _rawTechnologies = [];
  List<ModuleLink> _rawCreatures = [];
  List<ModuleLink> _rawRaces = [];

  List<ModuleLink> _updateLinksList(List<String> newNames, List<ModuleLink> currentLinks) {
    return newNames.map((name) {
      final existing = currentLinks.cast<ModuleLink?>().firstWhere(
        (link) => link?.name == name,
        orElse: () => null,
      );
      if (existing != null) return existing;
      return ModuleLink(id: '', name: name);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadAbility();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _elementController.dispose();
    _cooldownController.dispose();
    _costController.dispose();
    _levelController.dispose();
    _requirementsController.dispose();
    _effectController.dispose();
    _customNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadAbility() async {
    if (widget.abilityLocalId != null) {
      final ability = await ref
          .read(abilityRepositoryProvider)
          .getAbility(widget.abilityLocalId!);

      if (ability != null) {
        _nameController.text = ability.name;
        _descriptionController.text = ability.description ?? '';
        _typeController.text = ability.type ?? '';
        _elementController.text = ability.element ?? '';
        _cooldownController.text = ability.cooldown ?? '';
        _costController.text = ability.cost ?? '';
        _levelController.text = ability.level ?? '';
        _requirementsController.text = ability.requirements ?? '';
        _effectController.text = ability.effect ?? '';
        _customNotesController.text = ability.customNotes ?? '';
        _tagColor = ability.tagColor;

        _rawCharacters = ability.rawCharacters;
        _rawPowerSystems = ability.rawPowerSystems;
        _rawStories = ability.rawStories;
        _rawEvents = ability.rawEvents;
        _rawItems = ability.rawItems;
        _rawReligions = ability.rawReligions;
        _rawTechnologies = ability.rawTechnologies;
        _rawCreatures = ability.rawCreatures;
        _rawRaces = ability.rawRaces;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveAbility() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = AbilitiesCompanion(
      localId: widget.abilityLocalId != null 
          ? drift.Value(widget.abilityLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      type: drift.Value(_typeController.text.isEmpty ? null : _typeController.text),
      element: drift.Value(_elementController.text.isEmpty ? null : _elementController.text),
      cooldown: drift.Value(_cooldownController.text.isEmpty ? null : _cooldownController.text),
      cost: drift.Value(_costController.text.isEmpty ? null : _costController.text),
      level: drift.Value(_levelController.text.isEmpty ? null : _levelController.text),
      requirements: drift.Value(_requirementsController.text.isEmpty ? null : _requirementsController.text),
      effect: drift.Value(_effectController.text.isEmpty ? null : _effectController.text),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      rawCharacters: drift.Value(_rawCharacters),
      rawPowerSystems: drift.Value(_rawPowerSystems),
      rawStories: drift.Value(_rawStories),
      rawEvents: drift.Value(_rawEvents),
      rawItems: drift.Value(_rawItems),
      rawReligions: drift.Value(_rawReligions),
      rawTechnologies: drift.Value(_rawTechnologies),
      rawCreatures: drift.Value(_rawCreatures),
      rawRaces: drift.Value(_rawRaces),
    );

    try {
      if (widget.abilityLocalId != null) {
        await ref.read(abilityRepositoryProvider).updateAbility(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ability updated successfully')),
          );
        }
      } else {
        await ref.read(abilityRepositoryProvider).createAbility(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ability created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving ability: $e')),
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
          title: Text(widget.abilityLocalId != null ? 'Edit Ability' : 'New Ability'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveAbility,
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
                  controller: _elementController,
                  decoration: const InputDecoration(labelText: 'Element', border: OutlineInputBorder()),
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
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cooldownController,
                  decoration: const InputDecoration(labelText: 'Cooldown', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _costController,
                  decoration: const InputDecoration(labelText: 'Cost', border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _levelController,
            decoration: const InputDecoration(labelText: 'Level', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _requirementsController,
            decoration: const InputDecoration(labelText: 'Requirements', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _effectController,
            decoration: const InputDecoration(labelText: 'Effect', border: OutlineInputBorder()),
            maxLines: 4,
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
            label: 'Power Systems',
            initialValues: _rawPowerSystems.map((e) => e.name).toList(),
            onChanged: (values) => _rawPowerSystems = _updateLinksList(values, _rawPowerSystems),
            searchFunction: (q) => _search(q, 'powersystem'),
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
            label: 'Creatures',
            initialValues: _rawCreatures.map((e) => e.name).toList(),
            onChanged: (values) => _rawCreatures = _updateLinksList(values, _rawCreatures),
            searchFunction: (q) => _search(q, 'creature'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Races',
            initialValues: _rawRaces.map((e) => e.name).toList(),
            onChanged: (values) => _rawRaces = _updateLinksList(values, _rawRaces),
            searchFunction: (q) => _search(q, 'race'),
          ),
        ],
      ),
    );
  }
}