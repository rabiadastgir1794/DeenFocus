import 'package:flutter/material.dart';

/// Theme-aware tokens for the onboarding welcome screen.
abstract class OnboardingWelcomeTheme {
  OnboardingWelcomeTheme._();

  static Color chipBackground(ColorScheme colorScheme, Brightness brightness) {
    if (brightness == Brightness.dark) {
      return colorScheme.surfaceContainerHigh.withValues(alpha: 0.55);
    }
    return colorScheme.surfaceContainerLowest.withValues(alpha: 0.92);
  }

  static Color chipBorder(ColorScheme colorScheme) {
    return colorScheme.outlineVariant.withValues(alpha: 0.55);
  }

  static Color chipLabel(ColorScheme colorScheme) {
    return colorScheme.primary;
  }

  static Color logoShadow(ColorScheme colorScheme, Brightness brightness) {
    return colorScheme.primary.withValues(
      alpha: brightness == Brightness.dark ? 0.18 : 0.14,
    );
  }
}
