import 'package:flutter/material.dart';

/// Standardized top-left back control used across custom headers.
class AppTopBackButton extends StatelessWidget {
  const AppTopBackButton({
    super.key,
    required this.onTap,
    this.icon = Icons.arrow_back_rounded,
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
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.52),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.42),
            ),
          ),
          child: Icon(icon, size: 24, color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
