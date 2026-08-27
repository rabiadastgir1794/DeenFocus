import 'package:flutter/material.dart';

import '../../../core/share/content_share_payload.dart';
import '../../../core/share/content_share_service.dart';
import '../../../core/widgets/custom_app_bar.dart';
import 'learning_card_actions.dart';

/// Detail page shell: scrollable body + bookmark/copy/share.
class LearningDetailScaffold extends StatefulWidget {
  const LearningDetailScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.isBookmarked = false,
    this.onBookmark,
    this.onCopy,
    this.sharePayload,
    this.showCopy = true,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final bool isBookmarked;
  final VoidCallback? onBookmark;
  final VoidCallback? onCopy;
  final ContentSharePayload? sharePayload;
  final bool showCopy;

  @override
  State<LearningDetailScaffold> createState() => _LearningDetailScaffoldState();
}

class _LearningDetailScaffoldState extends State<LearningDetailScaffold> {
  final GlobalKey _cardKey = GlobalKey();
  bool _sharing = false;

  bool get _hasActions =>
      widget.onBookmark != null ||
      widget.onCopy != null ||
      widget.sharePayload != null;

  Future<void> _share() async {
    final payload = widget.sharePayload;
    if (payload == null || _sharing) return;
    setState(() => _sharing = true);
    try {
      await ContentShareService.shareCard(
        context: context,
        boundaryKey: _cardKey,
        payload: payload,
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title, subtitle: widget.subtitle),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: RepaintBoundary(
                key: _cardKey,
                child: widget.child,
              ),
            ),
          ),
          if (_hasActions)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: LearningCardActions(
                  isBookmarked: widget.isBookmarked,
                  showCopy: widget.showCopy,
                  onBookmark: () => widget.onBookmark?.call(),
                  onCopy: () => widget.onCopy?.call(),
                  onShare: _sharing ? () {} : _share,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
