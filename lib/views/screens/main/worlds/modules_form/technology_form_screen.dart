import 'package:flutter/material.dart';


class TechnologyFormScreen extends StatelessWidget {
  final String? technologyLocalId;
  final String worldLocalId;
  
  const TechnologyFormScreen({
    super.key, 
    this.technologyLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = technologyLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Technology' : 'New Technology'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $technologyLocalId' 
            : 'Form for new technology in $worldLocalId'
        ),
      ),
    );
  }
}