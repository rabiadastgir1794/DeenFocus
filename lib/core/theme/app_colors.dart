import 'package:flutter/material.dart';

/// Centralized app colors (DEEN FOCUS palette). Do not hardcode colors in widgets.
abstract class AppColors {
  AppColors._();

  // —— Primary ——
  static const Color primary = Color(0xFF4E9A7C); // Light primary
  static const Color primaryDark = Color(0xFF8ED4B4); // Dark primary
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFF1B3D2E);
  static const Color primaryContainerLight = Color(0xFFC8E6D8);
  static const Color primaryContainerDark = Color(0xFF2E6B52);
  static const Color onPrimaryContainerLight = Color(0xFF1B3D2E);
  static const Color onPrimaryContainerDark = Color(0xFFC8E6D8);

  // —— Secondary ——
  static const Color secondaryLight = Color(0xFFB5A48A);
  static const Color secondaryDark = Color(0xFFD8C8AA);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF3D3224);
  static const Color secondaryContainerLight = Color(0xFFF0E6D6);
  static const Color secondaryContainerDark = Color(0xFF544636);
  static const Color onSecondaryContainerLight = Color(0xFF3D3224);
  static const Color onSecondaryContainerDark = Color(0xFFF0E6D6);

  // —— Accent (tertiary) ——
  static const Color tertiaryLight = Color(0xFF5BA4C4);
  static const Color tertiaryDark = Color(0xFF8ECCE8);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color onTertiaryDark = Color(0xFF163545);
  static const Color tertiaryContainerLight = Color(0xFFC8E4F0);
  static const Color tertiaryContainerDark = Color(0xFF2E6B85);
  static const Color onTertiaryContainerLight = Color(0xFF163545);
  static const Color onTertiaryContainerDark = Color(0xFFC8E4F0);

  // —— Backgrounds & surfaces ——
  static const Color backgroundLight = Color(0xFFF7F5F0);
  static const Color backgroundDark = Color(0xFF111B14);
  static const Color surfaceLight = Color(0xFFF7F5F0);
  static const Color surfaceDark = Color(0xFF111B14);
  static const Color surfaceVariantLight = Color(0xFFE8E0D4);
  static const Color surfaceVariantDark = Color(0xFF3A3A30);
  static const Color inverseSurfaceLight = Color(0xFF2F312D);
  static const Color inverseSurfaceDark = Color(0xFFE0E3DC);
  static const Color inverseOnSurfaceLight = Color(0xFFF0F1EB);
  static const Color inverseOnSurfaceDark = Color(0xFF2F312D);
  static const Color onBackgroundLight = Color(0xFF1C2E24);
  static const Color onBackgroundDark = Color(0xFFE0E3DC);

  // —— Text ——
  static const Color textPrimaryLight = Color(0xFF1C2E24);
  static const Color textPrimaryDark = Color(0xFFE0E3DC);
  static const Color textSecondaryLight = Color(0xFF4A4539);
  static const Color textSecondaryDark = Color(0xFFCFC6B4);

  // —— Input & cards ——
  static const Color inputBackgroundLight = surfaceVariantLight;
  static const Color inputBackgroundDark = surfaceVariantDark;
  static const Color cardBackgroundLight = surfaceContainerLight;
  static const Color cardBackgroundDark = surfaceContainerDark;

  // —— Material 3 surface roles ——
  static const Color surfaceTintLight = primary;
  static const Color surfaceTintDark = primaryDark;
  static const Color surfaceBrightLight = Color(0xFFF7F5F0);
  static const Color surfaceBrightDark = Color(0xFF373D35);
  static const Color surfaceDimLight = Color(0xFFDDD9CE);
  static const Color surfaceDimDark = Color(0xFF111B14);
  static const Color surfaceContainerLowestLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowestDark = Color(0xFF141F18);
  static const Color surfaceContainerLowLight = Color(0xFFF5F1E8);
  static const Color surfaceContainerLowDark = Color(0xFF19241C);
  static const Color surfaceContainerLight = Color(0xFFEFEBE1);
  static const Color surfaceContainerDark = Color(0xFF1D2820);
  static const Color surfaceContainerHighLight = Color(0xFFE9E5DB);
  static const Color surfaceContainerHighDark = Color(0xFF232E26);
  static const Color surfaceContainerHighestLight = Color(0xFFE3DFD5);
  static const Color surfaceContainerHighestDark = Color(0xFF2D382F);

  // —— Button disabled ——
  static const Color buttonDisabledLight = Color(0xFFE8E0D4);
  static const Color buttonDisabledDark = Color(0xFF3A3A30);
  static const Color buttonDisabledTextLight = Color(0xFF7D7768);
  static const Color buttonDisabledTextDark = Color(0xFF989080);

  // —— Progress indicator ——
  static const Color progressInactiveLight = Color(0xFFCFC6B4);
  static const Color progressInactiveDark = Color(0xFF4A4539);

  // —— Selection / chip ——
  static const Color chipBackgroundLight = Color(0xFFF0E6D6);
  static const Color chipBackgroundDark = Color(0xFF2A332D);
  static const Color selectedCardBorderLight = Color(0xFF4E9A7C);
  static const Color unSelectedCardBorderLight = Color(0xFFCFC6B4);
  static const Color selectedCardBorderDark = Color(0xFF8ED4B4);

  static const Color outlineLight = Color(0xFF7D7768);
  static const Color outlineDark = Color(0xFF989080);
  static const Color outlineVariantLight = Color(0xFFCFC6B4);
  static const Color outlineVariantDark = Color(0xFF4A4539);

  // —— Destructive ——
  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerLight = Color(0xFFFFDAD6);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerLight = Color(0xFF410002);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  // —— Custom tokens ——
  static const Color sand = Color(0xFFB5A48A);
  static const Color sandForeground = Color(0xFF3D3224);
  static const Color sandDark = Color(0xFF544636);
  static const Color sandForegroundDark = Color(0xFFF0E6D6);
  static const Color emeraldGlow = Color(0xFF8ED4B4);
  static const Color emeraldGlowDark = Color(0xFF4E9A7C);
  static const Color warmBg = Color(0xFFF7F5F0);
  static const Color warmBgDark = Color(0xFF111B14);

  /// Upcoming prayer tile fill (light theme).
  static const Color prayerUpcomingTileLight = warmBg;
}