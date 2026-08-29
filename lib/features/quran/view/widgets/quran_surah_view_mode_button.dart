import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Toggles between verse-list (Surah) and Mushaf page layouts for one surah.
class QuranSurahViewModeButton extends StatelessWidget {
  const QuranSurahViewModeButton({
    super.key,
    required this.showPageView,
    required this.onTap,
  });

  /// When true, tapping opens page view; when false, opens surah (list) view.
  final bool showPageView;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      tooltip: showPageView
          ? l10n.quranSwitchToPageView
          : l10n.quranSwitchToSurahView,
      icon: Icon(
        showPageView ? Icons.auto_stories_rounded : Icons.view_list_rounded,
      ),
      onPressed: onTap,
    );
  }
}
