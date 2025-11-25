import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FactionListScreen extends ConsumerWidget {
  final String worldLocalId;
  final String? worldServerId;
  final String worldName;

  const FactionListScreen({
    super.key,
    required this.worldLocalId,
    this.worldServerId,
    required this.worldName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Factions in $worldName'),
      ),
      body: const Center(
        child: Text('Factions feature is temporarily disabled.'),
      ),
    );
  }
}