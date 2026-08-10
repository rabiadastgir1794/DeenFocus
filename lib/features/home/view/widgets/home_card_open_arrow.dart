import 'package:flutter/material.dart';

/// Shared thick green open-indicator used on tappable Home cards.
class HomeCardOpenArrow extends StatelessWidget {
  const HomeCardOpenArrow({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Icon(
      Icons.arrow_forward_rounded,
      size: 26,
      color: colorScheme.primary,
    );
  }
}
