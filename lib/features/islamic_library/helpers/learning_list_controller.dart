import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../data/library_progress_service.dart';
import '../model/library_section_progress.dart';

/// Shared load/bookmark helpers for list → detail learning screens.
mixin LearningListController<T extends StatefulWidget> on State<T> {
  bool loading = true;
  Set<int> bookmarks = const {};
  String query = '';
  bool openedInitial = false;

  String get sectionId;
  int? get initialCardIndex;
  int get itemCount;

  Future<void> loadProgressAndFinish() async {
    final progress =
        await LibraryProgressService.instance.getProgress(sectionId);
    if (!mounted) return;
    setState(() {
      bookmarks = Set<int>.from(progress.bookmarks);
      loading = false;
    });
  }

  Future<LibrarySectionProgress> reloadProgress() {
    return LibraryProgressService.instance.getProgress(sectionId);
  }

  void applyProgress(LibrarySectionProgress progress) {
    if (!mounted) return;
    setState(() {
      bookmarks = Set<int>.from(progress.bookmarks);
    });
  }

  Future<bool> toggleBookmarkAt(int index) async {
    final saved = await LibraryProgressService.instance.toggleBookmark(
      sectionId,
      index,
    );
    if (!mounted) return saved;
    setState(() {
      bookmarks = Set<int>.from(bookmarks);
      if (saved) {
        bookmarks.add(index);
      } else {
        bookmarks.remove(index);
      }
    });
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved ? l10n.libraryBookmarkSaved : l10n.libraryBookmarkRemoved,
        ),
      ),
    );
    return saved;
  }

  Future<void> openDetailRoute({
    required int index,
    required WidgetBuilder builder,
  }) async {
    await LibraryProgressService.instance.setLastIndex(sectionId, index);
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: builder),
    );
    final progress = await reloadProgress();
    applyProgress(progress);
  }

  void maybeOpenInitial(void Function(int index) open) {
    if (openedInitial || initialCardIndex == null || itemCount <= 0) return;
    openedInitial = true;
    final index = initialCardIndex!.clamp(0, itemCount - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) open(index);
    });
  }

  List<int> filterIndexes(bool Function(int index) matches) {
    final q = query.trim();
    if (q.isEmpty) {
      return List<int>.generate(itemCount, (i) => i);
    }
    final out = <int>[];
    for (var i = 0; i < itemCount; i++) {
      if (matches(i)) out.add(i);
    }
    return out;
  }
}
