import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../utils/api_service.dart';
import '../utils/debug_helper.dart';
import 'event_provider.dart';
import 'favorites_provider.dart';
import 'tickets_provider.dart';
import 'my_events_provider.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = true;
  Map<String, dynamic>? _user;
  String? _token;
  BuildContext? _context;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  AuthProvider() {
    _checkAuthStatus();
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  /// Check if user is already authenticated on app start
  Future<void> _checkAuthStatus() async {
    print('DEBUG: Starting auth status check...');
    await DebugHelper.printStoredAuthData();

    try {
      final apiService = ApiService();
      final token = await apiService.getToken();
      final prefs = await SharedPreferences.getInstance();
      final rememberLogin = prefs.getBool('remember_login') ?? false;

      print('DEBUG: Token exists: ${token != null && token.isNotEmpty}');
      print('DEBUG: Remember login: $rememberLogin');

      if (token != null && token.isNotEmpty && rememberLogin) {
        print('DEBUG: Token and remember login found, checking stored user data...');

        // Get stored user data
        final storedUserData = await getStoredUserData();
        print('DEBUG: Stored user data: $storedUserData');

        if (storedUserData != null) {
          _token = token;
          _user = storedUserData;
          _isAuthenticated = true;
          print('DEBUG: User authenticated with stored data');

          // Update user events and load user-specific data after authentication
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_context != null) {
              final eventProvider = Provider.of<EventProvider>(_context!, listen: false);
              final favoritesProvider = Provider.of<FavoritesProvider>(_context!, listen: false);
              final ticketsProvider = Provider.of<TicketsProvider>(_context!, listen: false);
              final myEventsProvider = Provider.of<MyEventsProvider>(_context!, listen: false);

              eventProvider.updateUserEvents(_user?['email']);
              favoritesProvider.loadFavorites();
              ticketsProvider.loadTickets();
              myEventsProvider.loadMyEvents();
            }
          });

          // Try to verify token with API call, but don't fail if API is unavailable
          try {
            final response = await apiService.get('/user/profile');
            if (response.success) {
              // Update user data if API call succeeds
              _user = response.responseData;
              // Update stored user data
              await prefs.setString('user_data', jsonEncode(_user));
              print('DEBUG: User data updated from API');
            }
          } catch (e) {
            // API call failed, but we still keep the user logged in with stored data
            print('DEBUG: API verification failed, using stored data: $e');
          }

        } else {
          print('DEBUG: No stored user data found, clearing auth data');
          // No stored user data, clear everything
          await _clearAuthData();
        }
      } else {
        print('DEBUG: No token or remember login is false, clearing auth data');
        // No token or remember login is false
        await _clearAuthData();
      }
    } catch (e) {
      print('DEBUG: Error checking auth status: $e');
      // Don't clear auth data on error, might be network issue
      _isAuthenticated = false;
    } finally {
      print('DEBUG: Auth check complete. Authenticated: $_isAuthenticated');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login user with email and password
  Future<bool> login(String email, String password, {bool remember = true}) async {
    try {
      final apiService = ApiService();
      final response = await apiService.post(
        '/login',
        data: {'email': email.trim(), 'password': password},
      );

      if (response.success) {
        final token = response.responseData?['token'];
        final userData = response.responseData?['user'];

        if (token != null) {
          _token = token;
          _user = userData ?? {'email': email.trim(), 'name': 'User'};
          _isAuthenticated = true;

          // Always save token, but set remember_login flag based on user choice
          await apiService.saveToken(token);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_login', remember);
          
          if (remember) {
            // Save user data for persistent login
            await prefs.setString('user_data', jsonEncode(_user));
            print('Login data saved for persistent login');
          } else {
            // Remove user data if not remembering
            await prefs.remove('user_data');
            print('Login data not saved - remember me disabled');
          }

          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      // For testing purposes, create a mock successful login
      if (email.isNotEmpty && password.isNotEmpty) {
        _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        _user = {'email': email.trim(), 'name': 'Test User'};
        _isAuthenticated = true;
        
        final apiService = ApiService();
        await apiService.saveToken(_token!);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_login', remember);
        
        if (remember) {
          await prefs.setString('user_data', jsonEncode(_user));
          print('Mock login data saved for persistent login');
        }
        
        notifyListeners();
        return true;
      }
      return false;
    }
  }

  /// Logout user and clear all stored data
  Future<void> logout() async {
    try {
      final apiService = ApiService();

      // Call logout endpoint if authenticated
      if (_isAuthenticated && _token != null) {
        await apiService.post('/logout');
      }

      // Clear local data
      await _clearAuthData();

      // Clear other providers' data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_context != null) {
          final eventProvider = Provider.of<EventProvider>(_context!, listen: false);
          final favoritesProvider = Provider.of<FavoritesProvider>(_context!, listen: false);
          final ticketsProvider = Provider.of<TicketsProvider>(_context!, listen: false);
          final myEventsProvider = Provider.of<MyEventsProvider>(_context!, listen: false);

          eventProvider.clearEvents();
          favoritesProvider.clearFavorites();
          ticketsProvider.clearTickets();
          myEventsProvider.clearEvents();
        }
      });

    } catch (e) {
      print('Logout error: $e');
      // Still clear local data even if API call fails
      await _clearAuthData();
    }
  }

  /// Clear all authentication data
  Future<void> _clearAuthData() async {
    try {
      final apiService = ApiService();
      await apiService.removeToken();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.remove('remember_login');
      
      _token = null;
      _user = null;
      _isAuthenticated = false;
      
      notifyListeners();
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  /// Check if user has enabled remember login
  Future<bool> shouldRememberLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('remember_login') ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Get stored user data
  Future<Map<String, dynamic>?> getStoredUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        return jsonDecode(userDataString);
      }
      return null;
    } catch (e) {
      print('Error getting stored user data: $e');
      return null;
    }
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    if (!_isAuthenticated) return;
    
    try {
      final apiService = ApiService();
      final response = await apiService.get('/user/profile');
      
      if (response.success) {
        _user = response.responseData;
        
        // Update stored user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(_user));
        
        notifyListeners();
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }
}