import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setDateTime(String key, DateTime value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value.toIso8601String());
  }

  static Future<DateTime?> getDateTime(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final stringValue = prefs.getString(key);
    if (stringValue == null) return null;
    return DateTime.tryParse(stringValue);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> debugPrintAll() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    for (var key in allKeys) {
      print('$key: ${prefs.get(key)}');
    }
  }
}
