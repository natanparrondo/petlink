import 'package:flutter/material.dart';

class AppTextStyles {
  static const sectionTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500, // Medium
    color: Colors.white,
  );

  static const tileTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: Colors.white,
  );

  static const appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500, // Medium
    color: Colors.white,
  );

  static const text = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: Colors.white,
  );

  static final textDimmed = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: Colors.white.withOpacity(0.6),
  );

  static final textSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    color: Colors.white,
  );

  static final textSmallDimmed = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    color: Colors.white.withOpacity(0.4),
  );

  static const bigText = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final bigTextSecondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: Colors.white.withOpacity(0.6),
  );
}
