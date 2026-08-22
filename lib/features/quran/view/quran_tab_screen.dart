import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../l10n/app_localizations.dart';
import '../../islamic_library/data/library_bookmark_service.dart';
import '../../islamic_library/data/library_progress_service.dart';
import '../../islamic_library/view/library_bookmarks_screen.dart';
import '../../islamic_library/widgets/islamic_library_hub_body.dart';

/// Bottom-nav Learn tab — Islamic Library hub. Quran is the first module card;
/// tapping it opens [QuranReaderScreen].
class QuranTabScreen extends StatefulWidget {
  const QuranTabScreen({super.key});

  @override
  State<QuranTabScreen> createState() => _QuranTabScreenState();
}

class _QuranTabScreenState extends State<QuranTabScreen> {
  int _bookmarkCount = 0;

  @override
  void initState() {
    super.initState();
    LibraryProgressService.bookmarkRevision.addListener(_onBookmarksChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadBookmarkCount());
    });
  }

  @override
  void dispose() {
    LibraryProgressService.bookmarkRevision.removeListener(_onBookmarksChanged);
    super.dispose();
  }

  void _onBookmarksChanged() {
    unawaited(_loadBookmarkCount());
  }

  Future<void> _loadBookmarkCount() async {
    final l10n = AppLocalizations.of(context)!;
    final items = await LibraryBookmarkService.list(l10n);
    if (!mounted) return;
    setState(() => _bookmarkCount = items.length);
  }

  Future<void> _openBookmarks() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const LibraryBookmarksScreen(),
      ),
    );
    if (!mounted) return;
    await _loadBookmarkCount();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.libraryHubTitle,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          l10n.libraryHomeSubtitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.libraryBookmarksTitle,
                    onPressed: () => unawaited(_openBookmarks()),
                    icon: Badge(
                      isLabelVisible: _bookmarkCount > 0,
                      label: Text(
                        _bookmarkCount > 99 ? '99+' : '$_bookmarkCount',
                      ),
                      child: const Icon(Icons.bookmarks_outlined),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              const Expanded(child: IslamicLibraryHubBody()),
            ],
          ),
        ),
      ),
    );
  }
}
