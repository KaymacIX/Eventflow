import 'package:flutter/material.dart';
import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/utils/api_service.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> _events = [];
  List<EventModel> _favouriteEvents = [];
  List<EventModel> _ticketedEvents = [];
  List<EventModel> _userEvents = [];
  String _searchQuery = '';

  List<EventModel> get events => _events;
  List<EventModel> get favouriteEvents => _favouriteEvents;
  List<EventModel> get ticketedEvents => _ticketedEvents;
  List<EventModel> get userEvents => _userEvents;
  String get searchQuery => _searchQuery;

  EventProvider() {
    _loadEvents();
  }

  Future<void> loadEvents() async {
    await _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      // Import ApiService at the top of the file
      // import 'package:eventflow/utils/api_service.dart';
      final api = ApiService();
      final response = await api.get('/events');
      if (response.success && response.responseData != null) {
        final List<dynamic> data = response.responseData is List
            ? response.responseData
            : response.responseData['data'] ?? [];
        _events = data.map((e) => EventModel.fromJson(e)).toList();
        _favouriteEvents = _events.where((event) => event.isFavourite).toList();
        _ticketedEvents = _events.where((event) => event.hasTicket).toList();
        _updateUserEvents();
      }
    } catch (e) {
      // API failed, leave events empty
    }
    notifyListeners();
  }

  void updateUserEventsFromAuth(String? currentUserEmail) {
    updateUserEvents(currentUserEmail);
  }

  void toggleFavourite(EventModel event) {
    final index = _events.indexWhere((e) => e.name == event.name);
    if (index != -1) {
      _events[index].isFavourite = !_events[index].isFavourite;
      _updateFavouriteEvents();
      _updateUserEvents();
      notifyListeners();
    }
  }

  void toggleTicket(EventModel event) {
    final index = _events.indexWhere((e) => e.name == event.name);
    if (index != -1) {
      _events[index].hasTicket = !_events[index].hasTicket;
      _updateTicketedEvents();
      _updateUserEvents();
      notifyListeners();
    }
  }

  void _updateFavouriteEvents() {
    _favouriteEvents = _events.where((event) => event.isFavourite).toList();
  }

  void _updateTicketedEvents() {
    _ticketedEvents = _events.where((event) => event.hasTicket).toList();
  }

  void _updateUserEvents() {
    // This will be updated when we have access to current user info
    // For now, we'll use a placeholder method
    _userEvents = [];
  }


  void updateUserEvents(String? currentUserEmail) {
    if (currentUserEmail != null) {
      // Compare user ID (from API) with current user ID
      _userEvents = _events.where((event) => event.createdBy == currentUserEmail.toString()).toList();
    } else {
      _userEvents = [];
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addEvent(EventModel event) {
    _events.add(event);
    _updateFavouriteEvents();
    _updateTicketedEvents();
    _updateUserEvents();
    notifyListeners();
  }

  List<EventModel> getUpcomingEvents() {
    final now = DateTime.now();
    return _events.where((event) {
      if (event.dateTime == null) return true;
      return event.dateTime!.isAfter(now);
    }).toList();
  }

  List<EventModel> getUserEvents(String? currentUserEmail) {
    if (currentUserEmail == null) return [];
    return _events.where((event) => event.createdBy == currentUserEmail.toString()).toList();
  }

  List<EventModel> searchEvents(String query) {
    if (query.isEmpty) return _events;
    return _events
        .where(
          (event) =>
              event.name.toLowerCase().contains(query.toLowerCase()) ||
              event.location.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
