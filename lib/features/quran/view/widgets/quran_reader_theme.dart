import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../reading_engine/quran_reading_color_theme.dart';

/// Resolved palette for Quran reader surfaces (one brightness variant).
///
/// Primaries stay on [AppColors.primary] / [AppColors.primaryDark] so chrome
/// matches the app, while background / paper / accent differ clearly per theme.
class QuranReaderPalette {
  const QuranReaderPalette({
    required this.background,
    required this.paper,
    required this.primary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.glassBorder,
  });

  final Color background;
  final Color paper;
  final Color primary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color glassBorder;

  static const animDuration = Duration(milliseconds: 250);
  static const animCurve = Curves.easeOutCubic;

  static QuranReaderPalette resolve(
    QuranReadingColorTheme theme,
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryDark : AppColors.primary;
    return switch (theme) {
      // Warm cream / parchment page — classic Mushaf paper feel.
      QuranReadingColorTheme.parchment => isDark
          ? QuranReaderPalette(
              background: const Color(0xFF16120C),
              paper: const Color(0xFF221C14),
              primary: primary,
              accent: const Color(0xFFC9A24D),
              textPrimary: const Color(0xFFF2E8D8),
              textSecondary: const Color(0xFFB5A48A),
              glassBorder: const Color(0x33FFFFFF),
            )
          : QuranReaderPalette(
              background: const Color(0xFFF3EBD8),
              paper: const Color(0xFFFFFBF2),
              primary: primary,
              accent: const Color(0xFFC9A24D),
              textPrimary: const Color(0xFF2C2418),
              textSecondary: const Color(0xFF6B5E4A),
              glassBorder: const Color(0xA6FFFFFF),
            ),
      // Soft green surfaces — closest to the rest of the app.
      QuranReadingColorTheme.emerald => isDark
          ? QuranReaderPalette(
              background: AppColors.backgroundDark,
              paper: AppColors.surfaceContainerDark,
              primary: primary,
              accent: AppColors.emeraldGlow,
              textPrimary: AppColors.textPrimaryDark,
              textSecondary: AppColors.textSecondaryDark,
              glassBorder: const Color(0x33FFFFFF),
            )
          : QuranReaderPalette(
              background: const Color(0xFFE4F0E9),
              paper: const Color(0xFFF7FBF8),
              primary: primary,
              accent: AppColors.primary,
              textPrimary: AppColors.textPrimaryLight,
              textSecondary: AppColors.textSecondaryLight,
              glassBorder: const Color(0xA6FFFFFF),
            ),
      // Cool slate / deep green — “night reading” even in light mode.
      QuranReadingColorTheme.midnight => isDark
          ? QuranReaderPalette(
              background: const Color(0xFF070D0A),
              paper: const Color(0xFF121A15),
              primary: primary,
              accent: AppColors.tertiaryDark,
              textPrimary: const Color(0xFFE6EEE9),
              textSecondary: const Color(0xFF8FA89A),
              glassBorder: const Color(0x28FFFFFF),
            )
          : QuranReaderPalette(
              background: const Color(0xFFD5DED9),
              paper: const Color(0xFFEEF2F0),
              primary: primary,
              accent: AppColors.tertiaryLight,
              textPrimary: const Color(0xFF15241C),
              textSecondary: const Color(0xFF4A6358),
              glassBorder: const Color(0xB3FFFFFF),
            ),
    };
  }

  List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 28,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  List<BoxShadow> get pageShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 36,
          offset: const Offset(0, 14),
        ),
        BoxShadow(
          color: accent.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 4),
        ),
      ];

  List<BoxShadow> get floatingShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];

  BoxDecoration glassDecoration({double radius = 20}) => BoxDecoration(
        color: paper.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: glassBorder),
        boxShadow: softShadow,
      );

  LinearGradient backgroundGradient({double accentMix = 0.08}) =>
      LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          background,
          Color.lerp(background, accent, accentMix)!,
          background,
        ],
        stops: const [0.0, 0.45, 1.0],
      );
}

/// Provides [QuranReaderPalette] to Quran reader widgets below.
class QuranReaderThemeScope extends InheritedWidget {
  const QuranReaderThemeScope({
    super.key,
    required this.palette,
    required super.child,
  });

  final QuranReaderPalette palette;

  static QuranReaderPalette of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<QuranReaderThemeScope>();
    assert(scope != null, 'QuranReaderThemeScope not found in context');
    return scope!.palette;
  }

  static QuranReaderPalette? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<QuranReaderThemeScope>()
        ?.palette;
  }

  @override
  bool updateShouldNotify(QuranReaderThemeScope oldWidget) {
    return palette != oldWidget.palette;
  }
}

extension QuranReaderPaletteContext on BuildContext {
  QuranReaderPalette get quranReader =>
      QuranReaderThemeScope.maybeOf(this) ??
      QuranReaderPalette.resolve(
        QuranReadingColorTheme.emerald,
        Theme.of(this).brightness,
      );
}
