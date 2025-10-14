import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventflow/providers/event_provider.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        return TextField(
          controller: _controller,
          onChanged: (value) {
            eventProvider.updateSearchQuery(value);
          },
          decoration: InputDecoration(
            hintText: 'Search for Events...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      eventProvider.updateSearchQuery('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        );
      },
    );
  }
}
