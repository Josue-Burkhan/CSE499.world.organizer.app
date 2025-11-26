import 'package:flutter/material.dart';


class ItemFormScreen extends StatelessWidget {
  final String? itemLocalId;
  final String worldLocalId;
  
  const ItemFormScreen({
    super.key, 
    this.itemLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = itemLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'New Item'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $itemLocalId' 
            : 'Form for new item in $worldLocalId'
        ),
      ),
    );
  }
}