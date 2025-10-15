import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DebugHelper {
  static Future<void> printStoredAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      print('=== DEBUG: Stored Auth Data ===');
      print('Token: ${prefs.getString('auth_token')}');
      print('User Data: ${prefs.getString('user_data')}');
      print('Remember Login: ${prefs.getBool('remember_login')}');
      print('All Keys: ${prefs.getKeys()}');
      print('===============================');
    } catch (e) {
      print('Error reading stored auth data: $e');
    }
  }
  
  static Future<void> clearAllAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      await prefs.remove('remember_login');
      print('DEBUG: All auth data cleared');
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }
}