import 'package:flutter/material.dart';


class PowerSystemFormScreen extends StatelessWidget {
  final String? powerSystemLocalId;
  final String worldLocalId;
  
  const PowerSystemFormScreen({
    super.key, 
    this.powerSystemLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = powerSystemLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Powersystem' : 'New Powersystem'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $powerSystemLocalId' 
            : 'Form for new power system in $worldLocalId'
        ),
      ),
    );
  }
}