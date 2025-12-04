import 'package:flutter/material.dart';
import 'package:worldorganizer_app/core/services/home_service.dart';

class ActivityTile extends StatelessWidget {
  final RecentActivityItem item;

  const ActivityTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          backgroundColor: _getColorForType(item.type).withOpacity(0.2),
          child: Icon(
            _getIconForType(item.type),
            color: _getColorForType(item.type),
            size: 20,
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${item.type} • ${_formatDate(item.updatedAt)}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        onTap: () {
          // TODO: Navigate to specific item detail
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigate to ${item.type}: ${item.name}')),
          );
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Character': return Icons.person;
      case 'Item': return Icons.backpack;
      case 'Location': return Icons.map;
      default: return Icons.article;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Character': return Colors.blue;
      case 'Item': return Colors.amber;
      case 'Location': return Colors.green;
      default: return Colors.grey;
    }
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
