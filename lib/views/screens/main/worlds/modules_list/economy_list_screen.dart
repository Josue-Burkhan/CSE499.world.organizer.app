import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/economy_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/economy_detail_screen.dart';

final economyListStreamProvider = StreamProvider.family
    .autoDispose<List<EconomyEntity>, String>((ref, worldLocalId) {
      return ref
          .watch(economyRepositoryProvider)
          .watchEconomiesInWorld(worldLocalId);
    });

final economySyncProvider = FutureProvider.autoDispose
    .family<void, ({String worldLocalId, String? worldServerId})>((
      ref,
      ids,
    ) async {
      if (ids.worldServerId != null) {
        final syncService = ref.watch(economySyncServiceProvider);
        await syncService.syncDirtyEconomies();
        await syncService.fetchAndMergeEconomies(
          ids.worldLocalId,
          ids.worldServerId!,
        );
      }
    });

class EconomyListScreen extends ConsumerWidget {
  final String worldLocalId;
  final String? worldServerId;
  final String worldName;

  const EconomyListScreen({
    super.key,
    required this.worldLocalId,
    this.worldServerId,
    required this.worldName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSync = ref.watch(
      economySyncProvider((
        worldLocalId: worldLocalId,
        worldServerId: worldServerId,
      )),
    );

    final asyncEconomies = ref.watch(economyListStreamProvider(worldLocalId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Economies in $worldName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EconomyFormScreen(
                    worldLocalId: worldLocalId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: asyncEconomies.when(
        data: (economies) {
          if (economies.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await ref.refresh(
                  economySyncProvider((
                    worldLocalId: worldLocalId,
                    worldServerId: worldServerId,
                  )).future,
                );
              },
              child: ListView.builder(
                itemCount: economies.length,
                itemBuilder: (context, index) {
                  final economy = economies[index];
                  return _buildEconomyCard(context, ref, economy);
                },
              ),
            );
          }

          return asyncSync.when(
            data: (_) {
              return _buildEmptyView(context);
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (e, st) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Failed to load economies: $e'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Failed to read local database: $e'),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'No economies yet.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Create your first economy to populate your world!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create an Economy'),
              onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EconomyFormScreen(
                        worldLocalId: worldLocalId,
                      ),
                    ),
                  );
                },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEconomyCard(
    BuildContext context,
    WidgetRef ref,
    EconomyEntity economy,
  ) {
    final color = _getTagColor(economy.tagColor);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Dismissible(
        key: Key(economy.localId),
        background: _buildSwipeAction(
          context,
          'Delete',
          Icons.delete,
          Colors.red,
          Alignment.centerLeft,
        ),
        secondaryBackground: _buildSwipeAction(
          context,
          'Edit',
          Icons.edit,
          Colors.blue,
          Alignment.centerRight,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            return await _showDeleteConfirmation(context, economy.name);
            } else if (direction == DismissDirection.endToStart) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EconomyFormScreen(
                    worldLocalId: worldLocalId,
                    economyLocalId: economy.localId,
                  ),
                ),
              );
              return false;
            }
          return false;
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            try {
              ref
                  .read(economyRepositoryProvider)
                  .deleteEconomy(economy.localId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"${economy.name}" was deleted.')),
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: color, width: 4)),
          ),
        child: ListTile(
          leading: Icon(
            Icons.attach_money,
            color: color,
          ),
          title: Text(economy.name),
          subtitle: Text(
            economy.economicSystem,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            if (economy.serverId != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EconomyDetailScreen(
                    economyServerId: economy.serverId!,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This economy has not been synced yet.'),
                  backgroundColor: Colors.orange,
                )
              );
            }
          },
        ),
        ),
      ),
    );
  }

  Color _getTagColor(String tagColor) {
    switch (tagColor) {
      case 'blue':
        return Colors.blue.shade400;
      case 'purple':
        return Colors.purple.shade400;
      case 'green':
        return Colors.green.shade400;
      case 'red':
        return Colors.red.shade400;
      case 'amber':
        return Colors.amber.shade400;
      case 'lime':
        return Colors.lime.shade400;
      case 'black':
        return Colors.black87;
      case 'neutral':
      default:
        return Colors.grey.shade400;
    }
  }

  Widget _buildSwipeAction(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    Alignment alignment,
  ) {
    final bool isLeft = alignment == Alignment.centerLeft;
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeft) Icon(icon, color: Colors.white),
          if (isLeft) const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
          if (!isLeft) const SizedBox(width: 8),
          if (!isLeft) Icon(icon, color: Colors.white),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    String name,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Economy'),
        content: Text(
          'Are you sure you want to delete "$name"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}