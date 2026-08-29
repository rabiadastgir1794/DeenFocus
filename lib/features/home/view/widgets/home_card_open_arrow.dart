import 'package:flutter/material.dart';

/// Forward arrow for tappable Home cards.
///
/// Uses [Icons.arrow_forward_rounded], whose [IconData.matchTextDirection] is
/// true — Flutter mirrors it to point left in RTL. Do not swap to
/// [Icons.arrow_back] manually; that icon also mirrors and ends up pointing
/// right again in Arabic layouts.
class HomeDirectionalForwardIcon extends StatelessWidget {
  const HomeDirectionalForwardIcon({
    super.key,
    required this.size,
    required this.color,
    this.icon = Icons.arrow_forward_rounded,
  });

  final double size;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }
}

/// Trailing chevron for tappable Home rows/cards (same mirroring as above).
class HomeDirectionalChevronIcon extends StatelessWidget {
  const HomeDirectionalChevronIcon({
    super.key,
    required this.color,
    this.size = 24,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.chevron_right, size: size, color: color);
  }
}

/// Shared thick open-indicator used on tappable Home cards.
class HomeCardOpenArrow extends StatelessWidget {
  const HomeCardOpenArrow({super.key, this.color});

  /// Defaults to [ColorScheme.primary] when null.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return HomeDirectionalForwardIcon(
      size: 26,
      color: color ?? colorScheme.primary,
    );
  }
}
