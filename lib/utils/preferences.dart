import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _viewModeKey = 'view_mode';
  static const String _defaultColorKey = 'default_color';

  static const String viewModeBlock = 'block';
  static const String viewModeList = 'list';

  static Future<String> getViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_viewModeKey) ?? viewModeBlock;
  }

  static Future<void> setViewMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_viewModeKey, mode);
  }

  static Future<int> getDefaultColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_defaultColorKey) ?? 0xFF66CC99;
  }

  static Future<void> setDefaultColor(int color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_defaultColorKey, color);
  }
}

