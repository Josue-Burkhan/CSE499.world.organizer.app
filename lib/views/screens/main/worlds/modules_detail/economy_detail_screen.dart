import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/economy_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final economyDetailStreamProvider =
    StreamProvider.family.autoDispose<EconomyEntity?, String>((ref, serverId) {
  return ref.watch(economyRepositoryProvider).watchEconomyByServerId(serverId);
});

final economyDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(economySyncServiceProvider);
  await syncService.fetchAndMergeSingleEconomy(serverId);
});

class EconomyDetailScreen extends ConsumerWidget {
  final String economyServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const EconomyDetailScreen({
    super.key,
    required this.economyServerId,
  });

  String? _getImageUrl(EconomyEntity economy) {
    if (economy.images.isEmpty) return null;
    String path = economy.images.first;
    if (path.startsWith('/')) {
      return '$_imageBaseUrl$path';
    }
    return path;
  }

  Color _getTagColor(String tagColor) {
    switch (tagColor) {
      case 'blue': return Colors.blue.shade400;
      case 'purple': return Colors.purple.shade400;
      case 'green': return Colors.green.shade400;
      case 'red': return Colors.red.shade400;
      case 'amber': return Colors.amber.shade400;
      case 'lime': return Colors.lime.shade400;
      case 'black': return Colors.black87;
      case 'neutral': default: return Colors.grey.shade400;
    }
  }

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEconomy = ref.watch(economyDetailStreamProvider(economyServerId));

    ref.listen(economyDetailSyncProvider(economyServerId), (prev, next) {
      if (prev is AsyncLoading && next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sync details: ${next.error}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    return asyncEconomy.when(
      data: (economy) {
        if (economy == null) {
          return ref.watch(economyDetailSyncProvider(economyServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load economy: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Economy not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, economy);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error reading local DB: $e')),
      ),
    );
  }

  Widget _buildDetailScaffold(BuildContext context, EconomyEntity economy) {
    final imageUrl = _getImageUrl(economy);
    final tagColor = _getTagColor(economy.tagColor);

    Currency? currency;
    if (economy.currencyJson != null) {
      currency = Currency.fromJson(jsonDecode(economy.currencyJson!));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(economy.name),
              background: GestureDetector(
                onTap: imageUrl != null 
                  ? () => _openFullScreenImage(context, imageUrl) 
                  : null,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                          Container(color: tagColor.withOpacity(0.5)),
                      )
                    : Container(color: tagColor.withOpacity(0.5)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildBasicInfo(economy),
              if (economy.description != null && economy.description!.isNotEmpty)
                _buildDescription(economy),
              if (currency != null) _buildCurrency(currency),
              _buildRawList('Trade Goods', economy.tradeGoods),
              _buildRawList('Key Industries', economy.keyIndustries),
              _buildRawList('Characters', economy.rawCharacters),
              _buildRawList('Factions', economy.rawFactions),
              _buildRawList('Locations', economy.rawLocations),
              _buildRawList('Items', economy.rawItems),
              _buildRawList('Races', economy.rawRaces),
              _buildRawList('Stories', economy.rawStories),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(EconomyEntity economy) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: Text(economy.economicSystem),
            subtitle: const Text('Economic System'),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(EconomyEntity economy) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(economy.description!),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrency(Currency currency) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Currency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text(currency.name ?? 'Unknown'),
            subtitle: const Text('Name'),
          ),
          if (currency.symbol != null && currency.symbol!.isNotEmpty)
            ListTile(
              title: Text(currency.symbol!),
              subtitle: const Text('Symbol'),
            ),
          if (currency.valueBase != null && currency.valueBase!.isNotEmpty)
            ListTile(
              title: Text(currency.valueBase!),
              subtitle: const Text('Value Base'),
            ),
        ],
      ),
    );
  }

  Widget _buildRawList(String title, List<String> rawList) {
    if (rawList.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: rawList.map((item) => Chip(label: Text(item))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}