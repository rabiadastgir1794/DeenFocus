import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class LearningCardActions extends StatelessWidget {
  const LearningCardActions({
    super.key,
    required this.isBookmarked,
    required this.onBookmark,
    required this.onCopy,
    required this.onShare,
    this.showCopy = true,
  });

  final bool isBookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final bool showCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionChip(
          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
          label: l10n.libraryBookmark,
          color: isBookmarked ? AppColors.primary : colorScheme.onSurfaceVariant,
          onTap: onBookmark,
        ),
        if (showCopy) ...[
          const SizedBox(width: 8),
          _ActionChip(
            icon: Icons.copy_outlined,
            label: l10n.libraryCopy,
            color: colorScheme.onSurfaceVariant,
            onTap: onCopy,
          ),
        ],
        const SizedBox(width: 8),
        _ActionChip(
          icon: Icons.ios_share_outlined,
          label: l10n.libraryShare,
          color: colorScheme.onSurfaceVariant,
          onTap: onShare,
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> copyLearningText(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppLocalizations.of(context)!.libraryCopied)),
  );
}

Future<void> shareLearningText(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(AppLocalizations.of(context)!.libraryShareCopiedHint),
    ),
  );
}
