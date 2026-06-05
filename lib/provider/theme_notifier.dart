import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ PASTIKAN ADA TULISAN "extends ChangeNotifier"
class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeNotifier() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners(); 
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    notifyListeners(); // Mengabari Consumer di main.dart untuk merubah tema aplikasi
  }
}