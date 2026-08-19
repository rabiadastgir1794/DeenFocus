import 'package:flutter/material.dart';

import '../../../core/widgets/custom_app_bar.dart';
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
    return Scaffold(
      appBar: CustomAppBar(title: title, subtitle: subtitle),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: child,
            ),
          ),
          if (_hasActions)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: LearningCardActions(
                  isBookmarked: isBookmarked,
                  showCopy: showCopy,
                  onBookmark: () => onBookmark?.call(),
                  onCopy: () => onCopy?.call(),
                  onShare: () => onShare?.call(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
