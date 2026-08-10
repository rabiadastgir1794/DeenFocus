import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../data/library_bookmark_service.dart';
import '../data/library_progress_service.dart';
import '../helpers/library_bookmark_opener.dart';
import '../model/library_bookmark_entry.dart';
import '../model/library_module.dart';

class LibraryBookmarksScreen extends StatefulWidget {
  const LibraryBookmarksScreen({super.key});

  @override
  State<LibraryBookmarksScreen> createState() => _LibraryBookmarksScreenState();
}

class _LibraryBookmarksScreenState extends State<LibraryBookmarksScreen> {
  List<LibraryBookmarkEntry> _items = const [];
  bool _loading = true;
  bool _startedInitialLoad = false;

  @override
  void initState() {
    super.initState();
    LibraryProgressService.bookmarkRevision.addListener(_onBookmarksChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_startedInitialLoad) {
      _startedInitialLoad = true;
      unawaited(_load());
    }
  }

  @override
  void dispose() {
    LibraryProgressService.bookmarkRevision.removeListener(_onBookmarksChanged);
    super.dispose();
  }

  void _onBookmarksChanged() {
    unawaited(_load());
  }

  Future<void> _load({bool showSpinner = false}) async {
    if (showSpinner && mounted) {
      setState(() => _loading = true);
    }
    try {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final items = await LibraryBookmarkService.list(l10n);
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _items = const [];
        _loading = false;
      });
    }
  }

  Future<void> _open(LibraryBookmarkEntry entry) async {
    await openLibraryBookmark(context, entry);
    if (!mounted) return;
    await _load();
  }

  Future<void> _remove(LibraryBookmarkEntry entry) async {
    await LibraryBookmarkService.remove(entry);
  }

  IconData _iconFor(LibraryModuleId moduleId) {
    for (final module in LibraryModule.all) {
      if (module.id == moduleId) return module.icon;
    }
    return Icons.bookmark_outline;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileColor =
        isDark ? colorScheme.surfaceContainerHighest : AppColors.surfaceLight;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.libraryBookmarksTitle,
        subtitle: l10n.libraryBookmarksSubtitle,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Text(
                      l10n.libraryBookmarksEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  itemCount: _items.length,
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
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
                        child: Icon(
                          Icons.delete_outline,
                          color: colorScheme.error,
                        ),
                      ),
                      child: Material(
                        color: tileColor,
                        borderRadius: BorderRadius.circular(16.r),
                        child: InkWell(
                          onTap: () => unawaited(_open(item)),
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(14.w, 14.h, 12.w, 14.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    _iconFor(item.moduleId),
                                    color: AppColors.primary,
                                    size: 22.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '${item.moduleLabel} · ${item.sectionLabel}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        item.preview,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                              height: 1.4,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
