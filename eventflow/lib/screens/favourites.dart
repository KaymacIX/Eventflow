import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eventflow/providers/favorites_provider.dart';
import 'package:eventflow/widgets/app_bar.dart';
import 'package:eventflow/widgets/event_tiles.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load favorites when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      if (favoritesProvider.favorites.isEmpty && !favoritesProvider.isLoading) {
        favoritesProvider.loadFavorites();
      }
    });

    return Scaffold(
      appBar: const Appbar(title: 'Favourites'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            final favorites = favoritesProvider.favorites;
            return RefreshIndicator(
              onRefresh: () async {
                await favoritesProvider.loadFavorites();
              },
              child: favoritesProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : favorites.isEmpty
                      ? const Center(
                          child: Text(
                            'No favourite events yet.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView(
                          children: [
                            EventTiles(eventModel: favorites),
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