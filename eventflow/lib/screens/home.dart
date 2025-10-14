import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eventflow/models/popular_event_model.dart';
import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/providers/event_provider.dart';

import 'package:eventflow/widgets/app_bar.dart';
// import 'package:eventflow/widgets/popular_event_cards.dart';
import 'package:eventflow/widgets/event_tiles.dart';
// import 'package:eventflow/widgets/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PopularEventModel> popularEvents = [];

  void _getPopularEvents() {
    popularEvents = PopularEventModel.getPopularEvents();
  }

  @override
  void initState() {
    super.initState();
    _getPopularEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Home'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                // Simulate refresh
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
              },
              child: ListView(
                children: [
                  // PopularEventCards(popularEvents: popularEvents),
                  // SizedBox(height: 20),
                  EventTiles(eventModel: eventProvider.events),
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
