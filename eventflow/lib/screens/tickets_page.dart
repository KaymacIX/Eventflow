import 'package:flutter/material.dart';

import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/widgets/app_bar.dart';
import 'package:eventflow/widgets/event_tiles.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<EventModel> allEvents = [];
  List<EventModel> ticketedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    allEvents = EventModel.getEvents();
    // For demo purposes, assume some events have tickets purchased
    // In a real app, this would come from persistent storage or state management
    ticketedEvents = allEvents.where((event) => event.boxIsSelected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'My Tickets'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ticketedEvents.isEmpty
            ? Center(
                child: Text(
                  'No tickets purchased yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView(
                children: [
                  EventTiles(eventModel: ticketedEvents),
                  SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}