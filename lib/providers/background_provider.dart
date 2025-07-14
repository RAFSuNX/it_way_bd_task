import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundProvider with ChangeNotifier {
  static const _key = 'selected_bg';
  String? _selectedBackground;

  String? get selectedBackground => _selectedBackground;

  BackgroundProvider() {
    loadBackground();
  }

  Future<void> loadBackground() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedBackground = prefs.getString(_key);
    print('BackgroundProvider.loadBackground: loaded $_selectedBackground');
    notifyListeners();
  }

  Future<void> setBackground(String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    if (imagePath == null) {
      await prefs.remove(_key);
      print('BackgroundProvider.setBackground: cleared background');
    } else {
      await prefs.setString(_key, imagePath);
      print('BackgroundProvider.setBackground: set to $imagePath');
    }
    _selectedBackground = imagePath;
    notifyListeners();
  }
}
