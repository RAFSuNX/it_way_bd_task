import 'package:flutter/material.dart';

class ThemeColor {
  static const white = Colors.white;
  static const black54 = Colors.black54;

  // Light theme colors
  static const lightPrimary = Color(0xFF4B89DC); // Mild blue
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Colors.white;
  static const lightError = Color(0xFFDC2626);

  // Dark theme colors
  static const darkPrimary = Color(0xFF1A1A1A);
  static const darkBackground = Color(0xFF0A0A0A);
  static const darkSurface = Color(0xFF141414);
  static const darkSecondary = Color(0xFF2A2A2A);
  static const darkError = Color(0xFFEF4444);

  // Task status colors
  static const statusWorking = Color(0xFF9B5DE5); // Purple
  static const statusCompleted = Color(0xFF43AA8B); // Green
  static const statusPending = Color(0xFFFFC300); // Yellow
  static const statusDue = Color(0xFFE63946); // Red

  // Light color scheme
  static final lightColorScheme = ColorScheme.light(
    primary: lightPrimary,
    primaryContainer: lightPrimary.withOpacity(0.8),
    secondary: lightPrimary.withOpacity(0.7),
    background: lightBackground,
    surface: lightSurface,
    error: lightError,
    onPrimary: white,
    onSecondary: white,
    onBackground: Colors.black,
    onSurface: Colors.black,
    onError: white,
  );

  // Dark color scheme
  static final darkColorScheme = ColorScheme.dark(
    primary: darkPrimary,
    primaryContainer: const Color(0xFF262626),
    secondary: darkSecondary,
    background: darkBackground,
    surface: darkSurface,
    error: darkError,
    onPrimary: white,
    onSecondary: white,
    onBackground: white,
    onSurface: white,
    onError: white,
  );

  // Getter for current primary color (can be used in legacy code)
  static Color get primary => lightPrimary;

  // Theme data
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: lightPrimary,
      foregroundColor: white,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: darkPrimary,
      foregroundColor: white,
    ),
  );
}
