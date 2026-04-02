import 'package:flutter/material.dart';

class HomeActionContainer extends StatelessWidget {
  const HomeActionContainer({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackground,
    required this.onTap,
    this.showOuterDecoration = true,
  });

  final Color backgroundColor;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackground;
  final VoidCallback onTap;
  final bool showOuterDecoration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final decoration = BoxDecoration(
      color: showOuterDecoration ? backgroundColor : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      border: showOuterDecoration
          ? Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.35))
          : null,
      boxShadow: showOuterDecoration
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ]
          : null,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        width: double.infinity,
        decoration: decoration,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
