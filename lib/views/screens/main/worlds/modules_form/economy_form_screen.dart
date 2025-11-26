import 'package:flutter/material.dart';


class EconomyFormScreen extends StatelessWidget {
  final String? economyLocalId;
  final String worldLocalId;
  
  const EconomyFormScreen({
    super.key, 
    this.economyLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = economyLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Economy' : 'New Economy'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $economyLocalId' 
            : 'Form for new economy in $worldLocalId'
        ),
      ),
    );
  }
}