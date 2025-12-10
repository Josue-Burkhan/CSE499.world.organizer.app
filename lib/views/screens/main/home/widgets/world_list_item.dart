import 'package:flutter/material.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/world_detail_screen.dart';

class WorldListItem extends StatelessWidget {
  final WorldEntity world;

  const WorldListItem({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorldDetailScreen(localWorldId: world.localId),
            ),
          );
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.public,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
        ),
        title: Text(
          world.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (world.description.isNotEmpty)
              Text(
                world.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildSyncStatus(context, world.syncStatus),
                const SizedBox(width: 12),
                Text(
                  'Edited ${_formatDate(world.updatedAt ?? DateTime.now())}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildSyncStatus(BuildContext context, SyncStatus status) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case SyncStatus.synced:
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'Synced';
        break;
      case SyncStatus.created:
      case SyncStatus.edited:
        color = Colors.orange;
        icon = Icons.sync;
        label = 'Pending';
        break;
      case SyncStatus.deleted:
        color = Colors.red;
        icon = Icons.delete;
        label = 'Deleted';
        break;
    }

    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
