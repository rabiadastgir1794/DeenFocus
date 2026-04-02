import 'package:flutter/material.dart';

/// Standardized top-left back control used across custom headers.
class AppTopBackButton extends StatelessWidget {
  const AppTopBackButton({
    super.key,
    required this.onTap,
    this.icon = Icons.chevron_left_rounded,
    this.semanticLabel,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: semanticLabel,
      button: true,
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        splashRadius: 20,
        icon: Icon(icon, size: 28, color: colorScheme.onSurface),
      ),
    );
  }
}
