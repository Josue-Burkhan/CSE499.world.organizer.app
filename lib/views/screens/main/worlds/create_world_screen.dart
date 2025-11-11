import 'package:flutter/material.dart';

class CreateWorldScreen extends StatelessWidget {
  const CreateWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New World'),
      ),
      body: const Center(
        child: Text('World Creation Form Goes Here'),
      ),
    );
  }
}