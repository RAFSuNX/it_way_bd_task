import 'package:flutter/material.dart';
import 'package:task_management_system/utils/theme/colors/color.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeTextStyles {
  static const Color _defaultTextColor = Colors.white;

  // Base style using GoogleFonts Poppins Regular (w400 only)
  static final TextStyle _baseStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    color: _defaultTextColor,
    height: 1.2,
  );

  // Heading styles (18-22 max, bold)
  static TextStyle h1 = _baseStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );

  static TextStyle h2 = _baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );

  static TextStyle h3 = _baseStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.1,
  );

  // Specialized heading (for splash screen)
  static TextStyle splashHeading = _baseStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    height: 1.2,
  );

  // Body text styles (14-16 max, normal)
  static TextStyle bodyLarge = _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodyMedium = _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: ThemeColor.primary,
  );

  static TextStyle bodySmall = _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  // Emphasis variants
  static TextStyle bodyLargeBold = bodyLarge.copyWith(
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyMediumBold = bodyMedium.copyWith(
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodySmallBold = bodySmall.copyWith(
    fontWeight: FontWeight.bold,
  );

  // For labels and special text
  static TextStyle label = _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextStyle caption = _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  // Button text
  static TextStyle button = _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // For backward compatibility
  static TextStyle heading = h2;
  static TextStyle normalTitle = bodyLargeBold;
  static TextStyle body = bodyMedium;
  static TextStyle subtitle = bodySmall;
  static TextStyle small = caption;
  static TextStyle hint = caption.copyWith(fontWeight: FontWeight.w500);
  static TextStyle keys = label;
  static TextStyle values = bodyMedium;

  static TextStyle get splashScreen => splashHeading;
}
