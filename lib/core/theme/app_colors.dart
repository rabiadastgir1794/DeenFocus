import 'package:flutter/material.dart';

/// Centralized app colors. Do not hardcode colors in widgets.
abstract class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF459075);
  static const Color primaryDark = Color(0xFF3A7A62);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textPrimaryDark = Color(0xFFE1E1E1);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Input & cards
  static const Color inputBackgroundLight = Color(0xFFEEEEEE);
  static const Color inputBackgroundDark = Color(0xFF2C2C2C);
  static const Color cardBackgroundLight = Color(0xFFf7f4ef);
  static const Color cardBackgroundDark = Color(0xFF2A2A2A);

  // Button disabled
  static const Color buttonDisabledLight = Color(0xFFE0E0E0);
  static const Color buttonDisabledDark = Color(0xFF3D3D3D);
  static const Color buttonDisabledTextLight = Color(0xFF9E9E9E);
  static const Color buttonDisabledTextDark = Color(0xFF6B6B6B);

  // Progress indicator
  static const Color progressInactiveLight = Color(0xFFD1D5DB);
  static const Color progressInactiveDark = Color(0xFF4B5563);

  // Selection / chip
  static const Color chipBackgroundLight = Color(0xFFEEEEEE);
  static const Color chipBackgroundDark = Color(0xFF2C2C2C);
  static const Color selectedCardBorderLight = Color(0xFF459075);
  static const Color unSelectedCardBorderLight = Color(0xFFfaf8f4);
  static const Color selectedCardBorderDark = Color(0xFF5BA88A);
}
