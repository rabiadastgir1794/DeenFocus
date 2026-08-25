import 'package:flutter/material.dart';

import '../../../core/widgets/app_centered_nav_header.dart';
import '../../../l10n/app_localizations.dart';
import 'learning_card_actions.dart';

/// Detail page shell: scrollable body + bookmark/copy/share.
class LearningDetailScaffold extends StatelessWidget {
  const LearningDetailScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.isBookmarked = false,
    this.onBookmark,
    this.onCopy,
    this.onShare,
    this.showCopy = true,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final bool isBookmarked;
  final VoidCallback? onBookmark;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final bool showCopy;

  bool get _hasActions =>
      onBookmark != null || onCopy != null || onShare != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: title,
              subtitle: subtitle,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: child,
              ),
            ),
            if (_hasActions)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: LearningCardActions(
                  isBookmarked: isBookmarked,
                  showCopy: showCopy,
                  onBookmark: () => onBookmark?.call(),
                  onCopy: () => onCopy?.call(),
                  onShare: () => onShare?.call(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
