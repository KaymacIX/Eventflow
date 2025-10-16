import 'package:flutter/material.dart';
import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/utils/api_service.dart';

class TicketsProvider with ChangeNotifier {
  List<EventModel> _tickets = [];
  bool _isLoading = false;

  List<EventModel> get tickets => _tickets;
  bool get isLoading => _isLoading;

  Future<void> loadTickets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final api = ApiService();
      print('Loading tickets from API...');
      final response = await api.get('/tickets');
      print('Tickets API response: ${response.toJson()}');
      if (response.success && response.responseData != null) {
        // Handle nested tickets structure
        final ticketsData = response.responseData['tickets'] ?? response.responseData['data'] ?? response.responseData;
        final List<dynamic> data = ticketsData is List ? ticketsData : [];
        _tickets = data.map((item) {
          // If item has 'event' key, use that, otherwise use the item directly
          final eventData = item['event'] ?? item;
          return EventModel.fromJson(eventData);
        }).toList();
        print('Loaded ${_tickets.length} tickets');
      } else {
        print('Failed to load tickets: ${response.responseMessage}');
      }
    } catch (e) {
      print('Error loading tickets: $e');
      // API failed, leave tickets empty
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearTickets() {
    _tickets = [];
    notifyListeners();
  }
}