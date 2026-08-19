import 'package:flutter/material.dart';

import '../logger/startup_probe.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

abstract class AppTheme {
  AppTheme._();

  static ThemeData? _light;
  static ThemeData? _dark;

  static ThemeData get light {
    final cached = _light;
    if (cached != null) return cached;
    final built = StartupProbe.timeSync(
      'AppTheme.light: evaluate lightTheme',
      () => lightTheme,
    );
    _light = built;
    return built;
  }

  static ThemeData get dark {
    final cached = _dark;
    if (cached != null) return cached;
    final built = StartupProbe.timeSync(
      'AppTheme.dark: evaluate darkTheme',
      () => darkTheme,
    );
    _dark = built;
    return built;
  }
}
