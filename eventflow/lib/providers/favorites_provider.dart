import 'package:flutter/material.dart';
import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/utils/api_service.dart';

class FavoritesProvider with ChangeNotifier {
  List<EventModel> _favorites = [];
  bool _isLoading = false;

  List<EventModel> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final api = ApiService();
      print('Loading favorites from API...');
      final response = await api.get('/favorites');
      print('Favorites API response: ${response.toJson()}');
      if (response.success && response.responseData != null) {
        // Handle nested favorites structure
        final favoritesData = response.responseData['favorites'] ?? response.responseData['data'] ?? response.responseData;
        final List<dynamic> data = favoritesData is List ? favoritesData : [];
        _favorites = data.map((item) {
          // If item has 'event' key, use that, otherwise use the item directly
          final eventData = item['event'] ?? item;
          return EventModel.fromJson(eventData);
        }).toList();
        print('Loaded ${_favorites.length} favorites');
      } else {
        print('Failed to load favorites: ${response.responseMessage}');
      }
    } catch (e) {
      print('Error loading favorites: $e');
      // API failed, leave favorites empty
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFavorites() {
    _favorites = [];
    notifyListeners();
  }
}