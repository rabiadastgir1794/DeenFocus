import 'package:flutter/widgets.dart';

/// Lightweight breakpoints for phone vs tablet layout tweaks.
class ResponsiveLayout {
  ResponsiveLayout._();

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600;

}
