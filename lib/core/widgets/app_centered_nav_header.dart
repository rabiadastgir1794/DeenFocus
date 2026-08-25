import 'package:flutter/material.dart';

/// Calendar-style header: leading back control + centered title.
///
/// Matches the Islamic Calendar screen header layout and typography.
/// When [subtitle] is set, title and subtitle stack in the center without
/// colliding with the back control or trailing widget.
class AppCenteredNavHeader extends StatelessWidget {
  const AppCenteredNavHeader({
    super.key,
    required this.title,
    required this.backLabel,
    required this.onBack,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String backLabel;
  final VoidCallback onBack;

  /// Optional trailing control (e.g. Insights calendar). Layout matches
  /// Calendar/Support when null.
  final Widget? trailing;

  bool get _hasSubtitle {
    final value = subtitle;
    return value != null && value.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backButton = TextButton.icon(
      onPressed: onBack,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        visualDensity: VisualDensity.compact,
      ),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
      label: Text(
        backLabel,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            backButton,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (_hasSubtitle) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            trailing ??
                ExcludeSemantics(
                  child: IgnorePointer(
                    child: Opacity(opacity: 0, child: backButton),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
