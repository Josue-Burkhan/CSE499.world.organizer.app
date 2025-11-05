import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Worlds'),
        actions: [
          // This button will eventually open a settings modal
          // or screen where the user can log in if they are offline.
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings/login functionality
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to your Home Screen!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement "Create New World" logic
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}