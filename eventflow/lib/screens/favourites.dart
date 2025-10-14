import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/providers/event_provider.dart';
import 'package:eventflow/widgets/app_bar.dart';
import 'package:eventflow/widgets/event_tiles.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Favourites'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            final favouriteEvents = eventProvider.favouriteEvents;
            return favouriteEvents.isEmpty
                ? const Center(
                    child: Text(
                      'No favourite events yet.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      // Simulate refresh
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView(
                      children: [
                        EventTiles(eventModel: favouriteEvents),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}