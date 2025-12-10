import 'package:flutter/material.dart';

class SyncStatusWidget extends StatelessWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Connect to real sync status provider
    // For now, we'll mock it or use a placeholder
    final pendingChanges = 0; 

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: pendingChanges > 0 ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              pendingChanges > 0 ? Icons.sync_problem : Icons.check_circle,
              color: pendingChanges > 0 ? Colors.orange : Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pendingChanges > 0 ? 'Sync Required' : 'All Synced',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  pendingChanges > 0 
                      ? '$pendingChanges changes pending' 
                      : 'Your data is up to date',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (pendingChanges > 0)
            TextButton(
              onPressed: () {
                // Trigger sync
              },
              child: const Text('Sync Now'),
            ),
        ],
      ),
    );
  }
}
