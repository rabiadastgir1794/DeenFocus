import 'package:flutter/material.dart';

/// Shared thick open-indicator used on tappable Home cards.
class HomeCardOpenArrow extends StatelessWidget {
  const HomeCardOpenArrow({super.key, this.color});

  /// Defaults to [ColorScheme.primary] when null.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Icon(
      Icons.arrow_forward_rounded,
      size: 26,
      color: color ?? colorScheme.primary,
    );
  }
}
