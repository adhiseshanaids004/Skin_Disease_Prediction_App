import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  bool _isDarkMode = false;
  final SharedPreferences? _prefs;

  ThemeProvider({required bool isDarkMode, SharedPreferences? prefs}) 
    : _isDarkMode = isDarkMode,
      _prefs = prefs;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme {
    return _isDarkMode 
      ? ThemeData.dark(useMaterial3: true)
      : ThemeData.light(useMaterial3: true);
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveThemePreference();
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    if (_prefs != null) {
      await _prefs.setBool(_themeKey, _isDarkMode);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    }
  }

  static Future<ThemeProvider> create() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? false;
    return ThemeProvider(isDarkMode: isDarkMode, prefs: prefs);
  }
}
