import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0AB68B);
  static const green = Color(0xFF34C759);
  static const red = Color(0xFFFF3B30);
  static const background = Color(0xFF191824);
  static const tile = Color(0xFF2E2D39);
  static const yellow = Color(0xFFFFCC00);
  static const white = Color(0xFFFFFFFF);
  static const white80 = Color(0xCCFFFFFF); // 80% opacidad
  static const white60 = Color(0x99FFFFFF); // 60% opacidad
  static const white40 = Color(0x66FFFFFF); // 40% opacidad

  static Color alpha(Color color, int opacity) {
    return color.withAlpha((opacity.clamp(0, 100) * 255 ~/ 100));
  }
}
