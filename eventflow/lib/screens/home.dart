import 'package:flutter/material.dart';

import 'package:eventflow/models/popular_event_model.dart';
import 'package:eventflow/models/event_model.dart';

import 'package:eventflow/widgets/app_bar.dart';
// import 'package:eventflow/widgets/popular_event_cards.dart';
import 'package:eventflow/widgets/event_tiles.dart';
// import 'package:eventflow/widgets/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PopularEventModel> popularEvents = [];
  List<EventModel> eventModel = [];

  void _getPopularEvents() {
    popularEvents = PopularEventModel.getPopularEvents();
  }

  void _getEvents() {
    eventModel = EventModel.getEvents();
  }

  @override
  void initState() {
    super.initState();
    _getPopularEvents();
    _getEvents();
  }

  @override
  Widget build(BuildContext context) {
    _getPopularEvents();
    _getEvents();
    return Scaffold(
      appBar: Appbar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // PopularEventCards(popularEvents: popularEvents),
          // SizedBox(height: 20),
          EventTiles(eventModel: eventModel),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
