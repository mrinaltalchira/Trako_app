import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {

  // Singleton pattern
  static final PrefManager _instance = PrefManager._internal();
  factory PrefManager() => _instance;
  PrefManager._internal();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Save a string
  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    prefs.setString(key, value);
  }

  // Get a string
  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  // Save an integer
  Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    prefs.setInt(key, value);
  }

  // Get an integer
  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  // Save a boolean
  Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    prefs.setBool(key, value);
  }

  // Get a boolean
  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  // Remove a key
  Future<void> remove(String key) async {
    final prefs = await _prefs;
    prefs.remove(key);
  }

  // Clear all preferences
  Future<void> clear() async {
    final prefs = await _prefs;
    prefs.clear();
  }




  // auth token

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString('token');
  }

  Future<void> setToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString('token', token);
  }

}