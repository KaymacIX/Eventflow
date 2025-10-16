import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eventflow/models/popular_event_model.dart';
import 'package:eventflow/providers/event_provider.dart';
import 'package:eventflow/providers/auth_provider.dart';
import 'package:eventflow/providers/my_events_provider.dart';

import 'package:eventflow/widgets/app_bar.dart';
// import 'package:eventflow/widgets/popular_event_cards.dart';
import 'package:eventflow/widgets/event_tiles.dart';
// import 'package:eventflow/widgets/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<PopularEventModel> popularEvents = [];
  late TabController _tabController;

  void _getPopularEvents() {
    popularEvents = PopularEventModel.getPopularEvents();
  }

  @override
  void initState() {
    super.initState();
    _getPopularEvents();
    _tabController = TabController(length: 2, vsync: this);

    // Load both upcoming events and my events when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final myEventsProvider = Provider.of<MyEventsProvider>(context, listen: false);
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      
      myEventsProvider.loadMyEvents();
      eventProvider.loadEvents();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Home'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabController.index = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _tabController.index == 0
                            ? const Color(0xFF13D0A1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Upcoming Events',
                          style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.white
                                : Colors.grey[600],
                            fontWeight: _tabController.index == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabController.index = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _tabController.index == 1
                            ? const Color(0xFF13D0A1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'My Events',
                          style: TextStyle(
                            color: _tabController.index == 1
                                ? Colors.white
                                : Colors.grey[600],
                            fontWeight: _tabController.index == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming Events Tab
                _buildUpcomingEventsTab(),
                // My Events Tab
                _buildMyEventsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/create_event');
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 19, 208, 161),
        foregroundColor: Colors.white,
        tooltip: 'Create Event',
      ),
    );
  }

  Widget _buildUpcomingEventsTab() {
    return Consumer2<EventProvider, MyEventsProvider>(
      builder: (context, eventProvider, myEventsProvider, child) {
        // Get all upcoming events
        final allUpcomingEvents = eventProvider.getUpcomingEvents();
        
        // Get IDs of user's own events to filter them out
        final myEventIds = myEventsProvider.myEvents
            .map((e) => e.id)
            .where((id) => id != null)
            .toSet();
        
        // Filter out user's own events from upcoming events
        final upcomingEvents = allUpcomingEvents
            .where((event) => !myEventIds.contains(event.id))
            .toList();
        
        return RefreshIndicator(
          onRefresh: () async {
            // Reload both providers to ensure data is in sync
            await eventProvider.loadEvents();
            await myEventsProvider.loadMyEvents();
            setState(() {});
          },
          child: upcomingEvents.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No upcoming events',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    EventTiles(
                      eventModel: upcomingEvents,
                      showHeader: false,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildMyEventsTab() {
    return Consumer<MyEventsProvider>(
      builder: (context, myEventsProvider, child) {
        final myEvents = myEventsProvider.myEvents;

        return RefreshIndicator(
          onRefresh: () async {
            // Trigger a reload of my events from the API
            await myEventsProvider.loadMyEvents();
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: myEventsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : myEvents.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_note,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No events created yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap the + button to create your first event',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: [
                          EventTiles(eventModel: myEvents, isMyEvents: true),
                          const SizedBox(height: 20),
                        ],
                      ),
          ),
        );
      },
    );
  }
}