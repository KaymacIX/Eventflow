import 'package:eventflow/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventflow/providers/event_provider.dart';
import 'package:eventflow/widgets/app_bar.dart';
import 'package:eventflow/widgets/event_tiles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Appbar(title: 'Search'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            final searchResults = eventProvider.searchEvents(eventProvider.searchQuery);
            return Column(
              children: [
                const SizedBox(height: 20),
                SearchTextField(),
                const SizedBox(height: 20),
                Expanded(
                  child: searchResults.isEmpty
                      ? const Center(
                          child: Text(
                            'No events found. Try a different search term.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            // Simulate refresh
                            await Future.delayed(const Duration(seconds: 1));
                          },
                          child: ListView(
                            children: [
                              EventTiles(eventModel: searchResults),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
