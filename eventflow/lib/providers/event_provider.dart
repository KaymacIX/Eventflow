import 'package:flutter/material.dart';
import 'package:eventflow/models/event_model.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> _events = [];
  List<EventModel> _favouriteEvents = [];
  List<EventModel> _ticketedEvents = [];
  String _searchQuery = '';

  List<EventModel> get events => _events;
  List<EventModel> get favouriteEvents => _favouriteEvents;
  List<EventModel> get ticketedEvents => _ticketedEvents;
  String get searchQuery => _searchQuery;

  EventProvider() {
    _loadEvents();
  }

  void _loadEvents() {
    _events = EventModel.getEvents();
    _favouriteEvents = _events.where((event) => event.isFavourite).toList();
    _ticketedEvents = _events.where((event) => event.hasTicket).toList();
    notifyListeners();
  }

  void toggleFavourite(EventModel event) {
    final index = _events.indexWhere((e) => e.name == event.name);
    if (index != -1) {
      _events[index].isFavourite = !_events[index].isFavourite;
      _updateFavouriteEvents();
      notifyListeners();
    }
  }

  void toggleTicket(EventModel event) {
    final index = _events.indexWhere((e) => e.name == event.name);
    if (index != -1) {
      _events[index].hasTicket = !_events[index].hasTicket;
      _updateTicketedEvents();
      notifyListeners();
    }
  }

  void _updateFavouriteEvents() {
    _favouriteEvents = _events.where((event) => event.isFavourite).toList();
  }

  void _updateTicketedEvents() {
    _ticketedEvents = _events.where((event) => event.hasTicket).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<EventModel> searchEvents(String query) {
    if (query.isEmpty) return _events;
    return _events.where((event) =>
      event.name.toLowerCase().contains(query.toLowerCase()) ||
      event.location.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}