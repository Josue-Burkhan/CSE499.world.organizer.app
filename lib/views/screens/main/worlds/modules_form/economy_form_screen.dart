import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/economy_model.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';

class EconomyFormScreen extends ConsumerStatefulWidget {
  final String? economyLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const EconomyFormScreen({
    super.key,
    this.economyLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<EconomyFormScreen> createState() => _EconomyFormScreenState();
}

class _EconomyFormScreenState extends ConsumerState<EconomyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _economicSystemController = TextEditingController();
  String _tagColor = 'neutral';

  // Currency
  final _currencyNameController = TextEditingController();
  final _currencySymbolController = TextEditingController();
  final _currencyValueBaseController = TextEditingController();

  // Lists
  List<String> _tradeGoods = [];
  List<String> _keyIndustries = [];

  // Links (Raw)
  List<ModuleLink> _rawCharacters = [];
  List<ModuleLink> _rawFactions = [];
  List<ModuleLink> _rawLocations = [];
  List<ModuleLink> _rawItems = [];
  List<ModuleLink> _rawRaces = [];
  List<ModuleLink> _rawStories = [];

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
    _loadEconomy();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _economicSystemController.dispose();
    _currencyNameController.dispose();
    _currencySymbolController.dispose();
    _currencyValueBaseController.dispose();
    super.dispose();
  }

  Future<void> _loadEconomy() async {
    if (widget.economyLocalId != null) {
      final economy = await ref
          .read(economyRepositoryProvider)
          .getEconomy(widget.economyLocalId!);

      if (economy != null) {
        _nameController.text = economy.name;
        _descriptionController.text = economy.description ?? '';
        _economicSystemController.text = economy.economicSystem;
        _tagColor = economy.tagColor;

        if (economy.currencyJson != null) {
          final currency = Currency.fromJson(jsonDecode(economy.currencyJson!));
          _currencyNameController.text = currency.name ?? '';
          _currencySymbolController.text = currency.symbol ?? '';
          _currencyValueBaseController.text = currency.valueBase ?? '';
        }

        _tradeGoods = economy.tradeGoods;
        _keyIndustries = economy.keyIndustries;

        _rawCharacters = economy.rawCharacters;
        _rawFactions = economy.rawFactions;
        _rawLocations = economy.rawLocations;
        _rawItems = economy.rawItems;
        _rawRaces = economy.rawRaces;
        _rawStories = economy.rawStories;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveEconomy() async {
    if (!_formKey.currentState!.validate()) return;

    final currency = Currency(
      name: _currencyNameController.text.isEmpty ? null : _currencyNameController.text,
      symbol: _currencySymbolController.text.isEmpty ? null : _currencySymbolController.text,
      valueBase: _currencyValueBaseController.text.isEmpty ? null : _currencyValueBaseController.text,
    );

    final companion = EconomiesCompanion(
      localId: widget.economyLocalId != null 
          ? drift.Value(widget.economyLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      currencyJson: drift.Value(jsonEncode(currency.toJson())),
      tradeGoods: drift.Value(_tradeGoods),
      keyIndustries: drift.Value(_keyIndustries),
      economicSystem: drift.Value(_economicSystemController.text),
      tagColor: drift.Value(_tagColor),
      rawCharacters: drift.Value(_rawCharacters),
      rawFactions: drift.Value(_rawFactions),
      rawLocations: drift.Value(_rawLocations),
      rawItems: drift.Value(_rawItems),
      rawRaces: drift.Value(_rawRaces),
      rawStories: drift.Value(_rawStories),
    );

    try {
      if (widget.economyLocalId != null) {
        await ref.read(economyRepositoryProvider).updateEconomy(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Economy updated successfully')),
          );
        }
      } else {
        await ref.read(economyRepositoryProvider).createEconomy(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Economy created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving economy: $e')),
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
          title: Text(widget.economyLocalId != null ? 'Edit Economy' : 'New Economy'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveEconomy,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Currency'),
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
              _buildCurrencyTab(),
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
          TextFormField(
            controller: _economicSystemController,
            decoration: const InputDecoration(labelText: 'Economic System', border: OutlineInputBorder()),
            validator: (value) => value == null || value.isEmpty ? 'Economic System is required' : null,
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
        ],
      ),
    );
  }

  Widget _buildCurrencyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _currencyNameController,
            decoration: const InputDecoration(labelText: 'Currency Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _currencySymbolController,
            decoration: const InputDecoration(labelText: 'Currency Symbol', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _currencyValueBaseController,
            decoration: const InputDecoration(labelText: 'Value Base', border: OutlineInputBorder()),
            maxLines: 2,
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
          AutocompleteChips(
            label: 'Trade Goods',
            initialValues: _tradeGoods,
            onChanged: (values) => _tradeGoods = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a trade good...',
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Key Industries',
            initialValues: _keyIndustries,
            onChanged: (values) => _keyIndustries = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add an industry...',
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
            label: 'Factions',
            initialValues: _rawFactions.map((e) => e.name).toList(),
            onChanged: (values) => _rawFactions = _updateLinksList(values, _rawFactions),
            searchFunction: (q) => _search(q, 'faction'),
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
            label: 'Items',
            initialValues: _rawItems.map((e) => e.name).toList(),
            onChanged: (values) => _rawItems = _updateLinksList(values, _rawItems),
            searchFunction: (q) => _search(q, 'item'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Races',
            initialValues: _rawRaces.map((e) => e.name).toList(),
            onChanged: (values) => _rawRaces = _updateLinksList(values, _rawRaces),
            searchFunction: (q) => _search(q, 'race'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Stories',
            initialValues: _rawStories.map((e) => e.name).toList(),
            onChanged: (values) => _rawStories = _updateLinksList(values, _rawStories),
            searchFunction: (q) => _search(q, 'story'),
          ),
        ],
      ),
    );
  }
}