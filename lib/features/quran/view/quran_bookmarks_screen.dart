import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/quran_bookmark_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../data/quran_local_repository.dart';
import 'juz_reading_screen.dart';
import 'mushaf_full_page_screen.dart';
import 'surah_detail_bottom_sheet.dart';

/// Saved Quran bookmarks (surah, ayah, page, juz).
class QuranBookmarksScreen extends StatefulWidget {
  const QuranBookmarksScreen({super.key});

  @override
  State<QuranBookmarksScreen> createState() => _QuranBookmarksScreenState();
}

class _QuranBookmarksScreenState extends State<QuranBookmarksScreen> {
  List<QuranBookmark> _items = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    QuranBookmarkService.revision.addListener(_onBookmarksChanged);
    unawaited(_load());
  }

  @override
  void dispose() {
    QuranBookmarkService.revision.removeListener(_onBookmarksChanged);
    super.dispose();
  }

  void _onBookmarksChanged() {
    unawaited(_load());
  }

  Future<void> _load() async {
    final items = await QuranBookmarkService.list();
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _open(QuranBookmark bookmark) async {
    switch (bookmark.kind) {
      case QuranBookmarkKind.surah:
        final surahs = await QuranLocalRepository.instance.getSurahs();
        final surah = surahs.firstWhere(
          (s) => s.number == bookmark.surah,
          orElse: () => surahs.first,
        );
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SurahDetailBottomSheet(surah: surah),
          ),
        );
      case QuranBookmarkKind.ayah:
        final surahs = await QuranLocalRepository.instance.getSurahs();
        final surah = surahs.firstWhere(
          (s) => s.number == bookmark.surah,
          orElse: () => surahs.first,
        );
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SurahDetailBottomSheet(
              surah: surah,
              initialAyah: bookmark.ayah,
            ),
          ),
        );
      case QuranBookmarkKind.page:
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => MushafFullPageScreen(
              initialPage: bookmark.page ?? 1,
            ),
          ),
        );
      case QuranBookmarkKind.juz:
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => JuzReadingScreen(juzNumber: bookmark.juz ?? 1),
          ),
        );
    }
  }

  Future<void> _remove(QuranBookmark bookmark) async {
    await QuranBookmarkService.remove(bookmark.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.quranBookmarksTitle),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? Center(
              child: Text(
                l10n.quranBookmarksEmpty,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              itemCount: _items.length,
              separatorBuilder: (_, _) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Dismissible(
                  key: ValueKey<String>(item.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => unawaited(_remove(item)),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.w),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(Icons.delete_outline, color: colorScheme.error),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.35,
                        ),
                      ),
                    ),
                    tileColor: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.25,
                    ),
                    leading: Icon(
                      _iconFor(item.kind),
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(_kindLabel(l10n, item.kind)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => unawaited(_open(item)),
                  ),
                );
              },
            ),
    );
  }

  IconData _iconFor(QuranBookmarkKind kind) => switch (kind) {
    QuranBookmarkKind.surah => Icons.menu_book_rounded,
    QuranBookmarkKind.ayah => Icons.format_quote_rounded,
    QuranBookmarkKind.page => Icons.auto_stories_rounded,
    QuranBookmarkKind.juz => Icons.bookmark_rounded,
  };

  String _kindLabel(AppLocalizations l10n, QuranBookmarkKind kind) =>
      switch (kind) {
        QuranBookmarkKind.surah => l10n.quranModeSurah,
        QuranBookmarkKind.ayah => l10n.quranSurahLabel,
        QuranBookmarkKind.page => l10n.quranModePage,
        QuranBookmarkKind.juz => l10n.quranModeJuz,
      };
}
