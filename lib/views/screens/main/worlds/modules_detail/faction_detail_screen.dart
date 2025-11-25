import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FactionDetailScreen extends ConsumerWidget {
  final String factionServerId;

  const FactionDetailScreen({
    super.key,
    required this.factionServerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faction Details'),
      ),
      body: const Center(
        child: Text('Faction details are temporarily disabled.'),
      ),
    );
  }
}