import 'package:flutter/material.dart';
import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/utils/api_service.dart';

class MyEventsProvider with ChangeNotifier {
  List<EventModel> _myEvents = [];
  bool _isLoading = false;

  List<EventModel> get myEvents => _myEvents;
  bool get isLoading => _isLoading;

  Future<void> loadMyEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final api = ApiService();
      final response = await api.get('/my-events');
      if (response.success && response.responseData != null) {
        final List<dynamic> data = response.responseData is List
            ? response.responseData
            : response.responseData['data'] ?? [];
        _myEvents = data.map((e) => EventModel.fromJson(e)).toList();
      }
    } catch (e) {
      // API failed, leave events empty
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearEvents() {
    _myEvents = [];
    notifyListeners();
  }

  Future<void> deleteEvent(EventModel event) async {
    try {
      final api = ApiService();
      print('Attempting to delete event with ID: ${event.id}');
      final response = await api.delete('/events/${event.id}');
      print('Delete response: ${response.toJson()}');
      if (response.success) {
        _myEvents.removeWhere((e) => e.id == event.id);
        notifyListeners();
        print('Event deleted successfully from local list');
      } else {
        print('API returned failure: ${response.responseMessage}');
        throw Exception(response.responseMessage);
      }
    } catch (e) {
      print('Error deleting event: $e');
      // If API fails, still remove locally for better UX
      _myEvents.removeWhere((e) => e.id == event.id);
      notifyListeners();
      print('Event removed from local list despite API error');
    }
  }
}