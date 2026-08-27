import 'package:flutter/material.dart';

import '../../../core/share/content_share_payload.dart';
import '../../../l10n/app_localizations.dart';
import '../data/library_progress_service.dart';
import '../widgets/learning_card_actions.dart';
import '../widgets/learning_detail_scaffold.dart';

/// Generic detail screen for a single learning item (bookmark/copy/share).
class LearningItemDetailScreen extends StatefulWidget {
  const LearningItemDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.sectionId,
    required this.index,
    required this.shareText,
    required this.sharePayload,
    required this.body,
    this.initiallyBookmarked = false,
  });

  final String title;
  final String subtitle;
  final String sectionId;
  final int index;
  final String shareText;
  final ContentSharePayload sharePayload;
  final Widget body;
  final bool initiallyBookmarked;

  @override
  State<LearningItemDetailScreen> createState() =>
      _LearningItemDetailScreenState();
}

class _LearningItemDetailScreenState extends State<LearningItemDetailScreen> {
  late bool _bookmarked = widget.initiallyBookmarked;

  Future<void> _toggleBookmark() async {
    final saved = await LibraryProgressService.instance.toggleBookmark(
      widget.sectionId,
      widget.index,
    );
    if (!mounted) return;
    setState(() => _bookmarked = saved);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved ? l10n.libraryBookmarkSaved : l10n.libraryBookmarkRemoved,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LearningDetailScaffold(
      title: widget.title,
      subtitle: widget.subtitle,
      isBookmarked: _bookmarked,
      onBookmark: _toggleBookmark,
      onCopy: () => copyLearningText(context, widget.shareText),
      sharePayload: widget.sharePayload,
      child: widget.body,
    );
  }
}
