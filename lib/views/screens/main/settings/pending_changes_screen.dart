import 'package:flutter/material.dart';

class PendingChangesScreen extends StatelessWidget {
  const PendingChangesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Changes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_queue, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No pending changes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
