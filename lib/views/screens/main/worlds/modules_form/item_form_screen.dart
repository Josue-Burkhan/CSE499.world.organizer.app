import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';

class ItemFormScreen extends ConsumerStatefulWidget {
  final String? itemLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const ItemFormScreen({
    super.key,
    this.itemLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeController = TextEditingController();
  final _originController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // Physical Properties
  final _materialController = TextEditingController();
  final _weightController = TextEditingController();
  final _valueController = TextEditingController();
  final _rarityController = TextEditingController();

  // Properties & Effects
  List<String> _magicalProperties = [];
  List<String> _technologicalFeatures = [];
  List<String> _customEffects = [];

  // Status
  bool _isUnique = false;
  bool _isDestroyed = false;

  // Links (Raw)
  List<String> _rawCreatedBy = [];
  List<String> _rawUsedBy = [];
  List<String> _rawCurrentOwnerCharacter = [];
  List<String> _rawFactions = [];
  List<String> _rawEvents = [];
  List<String> _rawStories = [];
  List<String> _rawLocations = [];
  List<String> _rawReligions = [];
  List<String> _rawTechnologies = [];
  List<String> _rawPowerSystems = [];
  List<String> _rawLanguages = [];
  List<String> _rawAbilities = [];

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _originController.dispose();
    _customNotesController.dispose();
    _materialController.dispose();
    _weightController.dispose();
    _valueController.dispose();
    _rarityController.dispose();
    super.dispose();
  }

  Future<void> _loadItem() async {
    if (widget.itemLocalId != null) {
      final item = await ref
          .read(itemRepositoryProvider)
          .getItem(widget.itemLocalId!);

      if (item != null) {
        _nameController.text = item.name;
        _descriptionController.text = item.description ?? '';
        _typeController.text = item.type ?? '';
        _originController.text = item.origin ?? '';
        _customNotesController.text = item.customNotes ?? '';
        _tagColor = item.tagColor;

        _materialController.text = item.material ?? '';
        _weightController.text = item.weight?.toString() ?? '';
        _valueController.text = item.value ?? '';
        _rarityController.text = item.rarity ?? '';

        _magicalProperties = item.magicalProperties;
        _technologicalFeatures = item.technologicalFeatures;
        _customEffects = item.customEffects;

        _isUnique = item.isUnique;
        _isDestroyed = item.isDestroyed;

        _rawCreatedBy = item.rawCreatedBy;
        _rawUsedBy = item.rawUsedBy;
        _rawCurrentOwnerCharacter = item.rawCurrentOwnerCharacter;
        _rawFactions = item.rawFactions;
        _rawEvents = item.rawEvents;
        _rawStories = item.rawStories;
        _rawLocations = item.rawLocations;
        _rawReligions = item.rawReligions;
        _rawTechnologies = item.rawTechnologies;
        _rawPowerSystems = item.rawPowerSystems;
        _rawLanguages = item.rawLanguages;
        _rawAbilities = item.rawAbilities;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = ItemsCompanion(
      localId: widget.itemLocalId != null 
          ? drift.Value(widget.itemLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      type: drift.Value(_typeController.text.isEmpty ? null : _typeController.text),
      origin: drift.Value(_originController.text.isEmpty ? null : _originController.text),
      material: drift.Value(_materialController.text.isEmpty ? null : _materialController.text),
      weight: drift.Value(num.tryParse(_weightController.text) as double?),
      value: drift.Value(_valueController.text.isEmpty ? null : _valueController.text),
      rarity: drift.Value(_rarityController.text.isEmpty ? null : _rarityController.text),
      magicalProperties: drift.Value(_magicalProperties),
      technologicalFeatures: drift.Value(_technologicalFeatures),
      customEffects: drift.Value(_customEffects),
      isUnique: drift.Value(_isUnique),
      isDestroyed: drift.Value(_isDestroyed),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      rawCreatedBy: drift.Value(_rawCreatedBy),
      rawUsedBy: drift.Value(_rawUsedBy),
      rawCurrentOwnerCharacter: drift.Value(_rawCurrentOwnerCharacter),
      rawFactions: drift.Value(_rawFactions),
      rawEvents: drift.Value(_rawEvents),
      rawStories: drift.Value(_rawStories),
      rawLocations: drift.Value(_rawLocations),
      rawReligions: drift.Value(_rawReligions),
      rawTechnologies: drift.Value(_rawTechnologies),
      rawPowerSystems: drift.Value(_rawPowerSystems),
      rawLanguages: drift.Value(_rawLanguages),
      rawAbilities: drift.Value(_rawAbilities),
    );

    try {
      if (widget.itemLocalId != null) {
        await ref.read(itemRepositoryProvider).updateItem(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully')),
          );
        }
      } else {
        await ref.read(itemRepositoryProvider).createItem(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving item: $e')),
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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.itemLocalId != null ? 'Edit Item' : 'New Item'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveItem,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Properties'),
              Tab(text: 'Effects'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildPropertiesTab(),
              _buildEffectsTab(),
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
                  controller: _originController,
                  decoration: const InputDecoration(labelText: 'Origin', border: OutlineInputBorder()),
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

  Widget _buildPropertiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _materialController,
            decoration: const InputDecoration(labelText: 'Material', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _valueController,
                  decoration: const InputDecoration(labelText: 'Value', border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _rarityController,
            decoration: const InputDecoration(labelText: 'Rarity', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Is Unique'),
            value: _isUnique,
            onChanged: (value) => setState(() => _isUnique = value),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Is Destroyed'),
            value: _isDestroyed,
            onChanged: (value) => setState(() => _isDestroyed = value),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildEffectsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AutocompleteChips(
            label: 'Magical Properties',
            initialValues: _magicalProperties,
            onChanged: (values) => _magicalProperties = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a magical property...',
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Technological Features',
            initialValues: _technologicalFeatures,
            onChanged: (values) => _technologicalFeatures = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a technological feature...',
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Custom Effects',
            initialValues: _customEffects,
            onChanged: (values) => _customEffects = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a custom effect...',
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
            label: 'Created By',
            initialValues: _rawCreatedBy,
            onChanged: (values) => _rawCreatedBy = values,
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Used By',
            initialValues: _rawUsedBy,
            onChanged: (values) => _rawUsedBy = values,
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Current Owner',
            initialValues: _rawCurrentOwnerCharacter,
            onChanged: (values) => _rawCurrentOwnerCharacter = values,
            searchFunction: (q) => _search(q, 'character'),
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
            label: 'Religions',
            initialValues: _rawReligions,
            onChanged: (values) => _rawReligions = values,
            searchFunction: (q) => _search(q, 'religion'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Technologies',
            initialValues: _rawTechnologies,
            onChanged: (values) => _rawTechnologies = values,
            searchFunction: (q) => _search(q, 'technology'),
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
            label: 'Languages',
            initialValues: _rawLanguages,
            onChanged: (values) => _rawLanguages = values,
            searchFunction: (q) => _search(q, 'language'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Abilities',
            initialValues: _rawAbilities,
            onChanged: (values) => _rawAbilities = values,
            searchFunction: (q) => _search(q, 'ability'),
          ),
        ],
      ),
    );
  }
}