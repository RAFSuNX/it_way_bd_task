import 'package:flutter/material.dart';

class Gap {
  static const double value = 8.0;

  // Vertical gaps
  static SizedBox y1 = const SizedBox(height: value * 0.5);  // 4px
  static SizedBox y2 = const SizedBox(height: value);        // 8px
  static SizedBox y4 = const SizedBox(height: value * 2);    // 16px
  static SizedBox y8 = const SizedBox(height: value * 3);    // 24px

  // Additional vertical gaps
  static SizedBox y12 = const SizedBox(height: value * 1.5); // 12px
  static SizedBox y16 = const SizedBox(height: value * 2);   // 16px
  static SizedBox y20 = const SizedBox(height: value * 2.5); // 20px
  static SizedBox y24 = const SizedBox(height: value * 3);   // 24px
  static SizedBox y32 = const SizedBox(height: value * 4);   // 32px

  // Horizontal gaps
  static SizedBox x1 = const SizedBox(width: value * 0.5);   // 4px
  static SizedBox x2 = const SizedBox(width: value);         // 8px
  static SizedBox x3 = const SizedBox(width: value * 1.5);   // 12px
  static SizedBox x4 = const SizedBox(width: value * 2);     // 16px

  // Additional horizontal gaps
  static const h8 = SizedBox(height: 8);
  static const h12 = SizedBox(height: 12);
  static const h16 = SizedBox(height: 16);
  static const h20 = SizedBox(height: 20);
  static const h24 = SizedBox(height: 24);

  static const w8 = SizedBox(width: 8);
  static const w12 = SizedBox(width: 12);
  static const w16 = SizedBox(width: 16);
}

