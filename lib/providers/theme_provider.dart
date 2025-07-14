import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme/colors/color.dart';

class ThemeProvider with ChangeNotifier {
  static const _themePrefKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ColorScheme get colorScheme =>
      _themeMode == ThemeMode.dark ? ThemeColor.darkColorScheme : ThemeColor
          .lightColorScheme;

  /// Call this after constructing the provider to load initial theme
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themePrefKey);
    if (saved == 'dark') {
      _themeMode = ThemeMode.dark;
      notifyListeners();
    } else if (saved == 'light') {
      _themeMode = ThemeMode.light;
      notifyListeners();
    }
    // else use default
  }

  void toggleTheme() async {
    _themeMode =
    (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    await _saveThemeMode();
    notifyListeners();
  }

  void setTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _saveThemeMode();
    notifyListeners();
  }

  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _themePrefKey, _themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}
