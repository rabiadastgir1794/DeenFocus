import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deenly/core/theme/app_text_theme.dart';

void main() {
  test('body and labels gain 1–2pt; display sizes stay put', () {
    final theme = buildAppTextTheme(Brightness.light);
    final material = Typography.material2021().black;

    expect(theme.bodySmall?.fontSize, 13);
    expect(theme.bodyMedium?.fontSize, 15);
    expect(theme.labelSmall?.fontSize, 12);
    expect(theme.labelMedium?.fontSize, 13);
    expect(theme.labelLarge?.fontSize, 15);
    expect(theme.titleSmall?.fontSize, 15);

    expect(theme.displayLarge?.fontSize, material.displayLarge?.fontSize);
    expect(theme.headlineSmall?.fontSize, material.headlineSmall?.fontSize);
    expect(theme.titleLarge?.fontSize, material.titleLarge?.fontSize);

    expect(theme.bodySmall?.fontWeight, FontWeight.w500);
    expect(theme.labelSmall?.fontWeight, FontWeight.w600);
    expect(theme.bodyMedium?.fontFamily, kAppFontFamily);
  });
}
