import 'package:flutter/material.dart';

import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/widgets/app_bar.dart';
import 'package:eventflow/widgets/event_tiles.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<EventModel> allEvents = [];
  List<EventModel> favouriteEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    allEvents = EventModel.getEvents();
    // For demo purposes, mark some events as favourites
    // In a real app, this would come from persistent storage or state management
    favouriteEvents = allEvents.where((event) => event.boxIsSelected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Favourites'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: favouriteEvents.isEmpty
            ? Center(
                child: Text(
                  'No favourite events yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView(
                children: [
                  EventTiles(eventModel: favouriteEvents),
                  SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}