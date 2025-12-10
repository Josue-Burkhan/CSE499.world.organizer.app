import 'dart:async';
import 'package:flutter/material.dart';

class AutocompleteChips extends StatefulWidget {
  final String label;
  final List<String> initialValues;
  final ValueChanged<List<String>> onChanged;
  final Future<List<String>> Function(String query) searchFunction;
  final String? hintText;

  const AutocompleteChips({
    super.key,
    required this.label,
    required this.initialValues,
    required this.onChanged,
    required this.searchFunction,
    this.hintText,
  });

  @override
  State<AutocompleteChips> createState() => _AutocompleteChipsState();
}

class _AutocompleteChipsState extends State<AutocompleteChips> {
  late List<String> _selectedValues;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialValues);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _addValue(String value) {
    if (value.isNotEmpty && !_selectedValues.contains(value)) {
      setState(() {
        _selectedValues.add(value);
      });
      widget.onChanged(_selectedValues);
      _textEditingController.clear();
    }
  }

  void _removeValue(String value) {
    setState(() {
      _selectedValues.remove(value);
    });
    widget.onChanged(_selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _selectedValues.map((value) {
            return Chip(
              label: Text(value),
              onDeleted: () => _removeValue(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            // Debounce could be handled here or inside searchFunction if needed
            // For simplicity, we call directly but the service usually handles it or we wait
            // Since Autocomplete expects a Future or Iterable, we can just await
            try {
              return await widget.searchFunction(textEditingValue.text);
            } catch (e) {
              return const Iterable<String>.empty();
            }
          },
          onSelected: (String selection) {
            _addValue(selection);
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Type to search or add...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _addValue(fieldTextEditingController.text);
                  },
                ),
              ),
              onSubmitted: (String value) {
                _addValue(value);
              },
            );
          },
        ),
      ],
    );
  }
}
