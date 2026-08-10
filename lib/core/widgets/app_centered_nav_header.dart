import 'package:flutter/material.dart';

/// Calendar-style header: leading back control + centered title.
///
/// Matches the Islamic Calendar screen header layout and typography.
class AppCenteredNavHeader extends StatelessWidget {
  const AppCenteredNavHeader({
    super.key,
    required this.title,
    required this.backLabel,
    required this.onBack,
    this.trailing,
  });

  final String title;
  final String backLabel;
  final VoidCallback onBack;

  /// Optional trailing control (e.g. Insights calendar). Layout matches
  /// Calendar/Support when null.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: SizedBox(
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: onBack,
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                label: Text(
                  backLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (trailing != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: trailing,
              ),
          ],
        ),
      ),
    );
  }
}
