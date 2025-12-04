import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String initialQuery;

  const SearchScreen({super.key, required this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  List<dynamic> _results = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _performSearch(widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final results = await apiService.search(query);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _results = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: false,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: _performSearch,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final item = _results[index];
                    return ListTile(
                      title: Text(item['name'] ?? 'Unknown'),
                      subtitle: Text(item['type'] ?? 'Unknown Type'),
                      // TODO: Navigate to detail screen on tap
                      onTap: () {
                         // Implement navigation based on type
                      },
                    );
                  },
                ),
    );
  }
}
