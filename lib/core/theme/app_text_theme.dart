import 'package:flutter/material.dart';

/// App UI font. Quran/hadith Arabic faces are set per-widget (`UthmanicHafs`,
/// `NooreHuda`) and must not be replaced by this family.
const String kAppFontFamily = 'PlusJakartaSans';

/// Readable Material 3 type scale. Display/headline sizes stay at the 2021
/// defaults so hero numbers and page titles do not grow. Body, label, and
/// compact titles gain 1–2pt, slightly stronger weight, and steadier height.
TextTheme buildAppTextTheme(Brightness brightness) {
  final base = brightness == Brightness.dark
      ? Typography.material2021().white
      : Typography.material2021().black;
  final themed = base.apply(fontFamily: kAppFontFamily);

  return themed.copyWith(
    titleSmall: themed.titleSmall?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: 0.1,
    ),
    titleMedium: themed.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: 0.1,
    ),
    bodyLarge: themed.bodyLarge?.copyWith(height: 1.45, letterSpacing: 0.15),
    bodyMedium: themed.bodyMedium?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.45,
      letterSpacing: 0.15,
    ),
    bodySmall: themed.bodySmall?.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.4,
      letterSpacing: 0.15,
    ),
    labelLarge: themed.labelLarge?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: 0.1,
    ),
    labelMedium: themed.labelMedium?.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: 0.2,
    ),
    labelSmall: themed.labelSmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: 0.2,
    ),
  );
}
