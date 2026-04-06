import 'package:flutter/material.dart';

/// Centralized app colors (DEEN FOCUS palette). Do not hardcode colors in widgets.
abstract class AppColors {
  AppColors._();

  // —— Primary ——
  static const Color primary = Color(0xFF46926E);
  static const Color primaryDark = Color(0xFF4B9974);
  static const Color onPrimaryLight = Color(0xFFF7F5F0);
  static const Color onPrimaryDark = Color(0xFF0F1219);
  static const Color primaryContainerLight = Color(0xFFD4EDE2);
  static const Color primaryContainerDark = Color(0xFF2A5C45);
  static const Color onPrimaryContainerLight = Color(0xFF1B2E24);
  static const Color onPrimaryContainerDark = Color(0xFFC8E6D8);

  // —— Secondary ——
  static const Color secondaryLight = Color(0xFFEBE4D8);
  static const Color secondaryDark = Color(0xFF262C38);
  static const Color onSecondaryLight = Color(0xFF263D30);
  static const Color onSecondaryDark = Color(0xFFDDD8CE);
  static const Color secondaryContainerLight = Color(0xFFEDEAE4);
  static const Color secondaryContainerDark = Color(0xFF323A48);
  static const Color onSecondaryContainerLight = Color(0xFF263D30);
  static const Color onSecondaryContainerDark = Color(0xFFDDD8CE);

  // —— Accent (tertiary) ——
  static const Color tertiaryLight = Color(0xFF85C4E0);
  static const Color tertiaryDark = Color(0xFF337A9A);
  static const Color onTertiaryLight = Color(0xFF123044);
  static const Color onTertiaryDark = Color(0xFFC2E2F0);
  static const Color tertiaryContainerLight = Color(0xFFD4EDF5);
  static const Color tertiaryContainerDark = Color(0xFF1F4A60);
  static const Color onTertiaryContainerLight = Color(0xFF123044);
  static const Color onTertiaryContainerDark = Color(0xFFC2E2F0);

  // —— Backgrounds & surfaces ——
  static const Color backgroundLight = Color(0xFFF7F5F0);
  static const Color backgroundDark = Color(0xFF0F1219);
  static const Color surfaceLight = Color(0xFFF7F5F0);
  static const Color surfaceDark = Color(0xFF0F1219);
  static const Color onBackgroundLight = Color(0xFF1B2E24);
  static const Color onBackgroundDark = Color(0xFFEDEAE4);

  // —— Text ——
  static const Color textPrimaryLight = Color(0xFF1B2E24);
  static const Color textPrimaryDark = Color(0xFFEDEAE4);
  static const Color textSecondaryLight = Color(0xFF6A7D72);
  static const Color textSecondaryDark = Color(0xFF818994);

  // —— Input & cards ——
  static const Color inputBackgroundLight = Color(0xFFE5E0D6);
  static const Color inputBackgroundDark = Color(0xFF262C38);
  static const Color cardBackgroundLight = Color(0xFFF2EFE8);
  static const Color cardBackgroundDark = Color(0xFF171C26);

  // —— Button disabled ——
  static const Color buttonDisabledLight = Color(0xFFEDEAE4);
  static const Color buttonDisabledDark = Color(0xFF222833);
  static const Color buttonDisabledTextLight = Color(0xFF6A7D72);
  static const Color buttonDisabledTextDark = Color(0xFF818994);

  // —— Progress indicator ——
  static const Color progressInactiveLight = Color(0xFF6A7D72);
  static const Color progressInactiveDark = Color(0xFF818994);

  // —— Selection / chip ——
  static const Color chipBackgroundLight = Color(0xFFEDEAE4);
  static const Color chipBackgroundDark = Color(0xFF222833);
  static const Color selectedCardBorderLight = Color(0xFF46926E);
  static const Color unSelectedCardBorderLight = Color(0xFFE5E0D6);
  static const Color selectedCardBorderDark = Color(0xFF4B9974);

  static const Color outlineLight = Color(0xFFE5E0D6);
  static const Color outlineDark = Color(0xFF262C38);
  static const Color outlineVariantLight = Color(0xFFEDEAE4);
  static const Color outlineVariantDark = Color(0xFF222833);

  // —— Destructive ——
  static const Color errorLight = Color(0xFFE02424);
  static const Color errorDark = Color(0xFF7F1D1D);
  static const Color onErrorLight = Color(0xFFFAFAFA);
  static const Color onErrorDark = Color(0xFFFAFAFA);
  static const Color errorContainerLight = Color(0xFFFFE8E8);
  static const Color errorContainerDark = Color(0xFF5C1515);
  static const Color onErrorContainerLight = Color(0xFF5C1010);
  static const Color onErrorContainerDark = Color(0xFFFFE8E8);

  // —— Custom tokens ——
  static const Color sand = Color(0xFFDFCFB8);
  static const Color sandForeground = Color(0xFF5C4D3D);
  static const Color sandDark = Color(0xFF3B352C);
  static const Color sandForegroundDark = Color(0xFFC9BBAA);
  static const Color emeraldGlow = Color(0xFF5CB896);
  static const Color emeraldGlowDark = Color(0xFF3D9970);
  static const Color warmBg = Color(0xFFF8F5EE);
  static const Color warmBgDark = Color(0xFF131820);

  /// Upcoming prayer tile fill (light theme).
  static const Color prayerUpcomingTileLight = warmBg;
}
