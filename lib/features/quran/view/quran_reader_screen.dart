import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/quran_bookmark_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../tajweed/tajweed_entry_point.dart';
import '../data/quran_local_repository.dart';
import '../reading_engine/mushaf_metadata.dart';
import '../reading_engine/quran_reading_color_theme.dart';
import '../reading_engine/reading_mode.dart';
import 'juz_reading_screen.dart';
import 'mushaf_full_page_screen.dart';
import 'quran_bookmarks_screen.dart';
import 'quran_reading_settings_launcher.dart';
import 'surah_detail_bottom_sheet.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/quran_page_grid.dart';
import 'widgets/quran_reader_theme.dart';
import '../../../core/widgets/custom_app_bar.dart';
import 'widgets/quran_reading_mode_tabs.dart';

class QuranReaderScreen extends StatefulWidget {
  const QuranReaderScreen({super.key});

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

enum _SearchResultKind { surah, page, juz, ayah }

class _SearchResult {
  const _SearchResult({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.surahNumber,
    this.ayah,
    this.page,
    this.juz,
  });

  final _SearchResultKind kind;
  final String title;
  final String subtitle;
  final int surahNumber;
  final int? ayah;
  final int? page;
  final int? juz;
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SurahSummary> _allSurahs = const <SurahSummary>[];
  List<_SearchResult> _searchResults = const <_SearchResult>[];
  List<JuzInfo> _juzList = const <JuzInfo>[];
  MushafMetadata? _metadata;

  bool _isLoading = true;
  String? _error;
  ReadingMode _selectedMode = ReadingMode.surah;
  _ContinueReadingState? _continueReading;
  int _highestPageCompleted = 0;
  int _bookmarkCount = 0;
  String? _lastListenedLabel;
  String? _lastTajweedLabel;
  int? _lastListenedSurah;
  int? _lastListenedAyah;
  int? _lastTajweedSurah;
  int? _lastTajweedAyah;
  String? _lastTajweedSurahName;
  int? _lastOpenedJuz;
  bool _searchActive = false;
  QuranReadingColorTheme _colorTheme = QuranReadingColorTheme.emerald;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    QuranBookmarkService.revision.addListener(_onBookmarksChanged);
    unawaited(_load());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    QuranBookmarkService.revision.removeListener(_onBookmarksChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onBookmarksChanged() {
    unawaited(_refreshCounts());
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait<Object?>([
        QuranLocalRepository.instance.getSurahs(),
        MushafMetadata.load(),
        StorageService.quranHighestPageCompleted,
        QuranBookmarkService.list(),
        StorageService.quranLastListenedSurah,
        StorageService.quranLastListenedAyah,
        StorageService.quranLastListenedSurahName,
        StorageService.lastTajweedSurah,
        StorageService.lastTajweedAyah,
        StorageService.lastTajweedSurahName,
        StorageService.quranLastJuz,
        StorageService.quranDefaultReadingMode,
        StorageService.quranReadingColorTheme,
      ]);
      if (!mounted) return;
      final surahs = results[0] as List<SurahSummary>;
      final metadata = results[1] as MushafMetadata;
      setState(() {
        _allSurahs = surahs;
        _metadata = metadata;
        _juzList = metadata.juzList;
        _highestPageCompleted = results[2] as int;
        _bookmarkCount = (results[3] as List<QuranBookmark>).length;
        _lastListenedSurah = results[4] as int?;
        _lastListenedAyah = results[5] as int?;
        _lastListenedLabel = _formatAyahLabel(
          results[6] as String?,
          _lastListenedSurah,
          _lastListenedAyah,
        );
        _lastTajweedSurah = results[7] as int?;
        _lastTajweedAyah = results[8] as int?;
        _lastTajweedSurahName = results[9] as String?;
        _lastTajweedLabel = _formatAyahLabel(
          _lastTajweedSurahName,
          _lastTajweedSurah,
          _lastTajweedAyah,
        );
        _lastOpenedJuz = results[10] as int?;
        _selectedMode = ReadingMode.fromName(results[11] as String?);
        _colorTheme = QuranReadingColorTheme.fromName(results[12] as String);
        _isLoading = false;
      });
      await _loadContinueReading();
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.quranLoadFailed;
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCounts() async {
    final results = await Future.wait<Object?>([
      StorageService.quranHighestPageCompleted,
      QuranBookmarkService.list(),
      StorageService.quranLastListenedSurah,
      StorageService.quranLastListenedAyah,
      StorageService.quranLastListenedSurahName,
      StorageService.lastTajweedSurah,
      StorageService.lastTajweedAyah,
      StorageService.lastTajweedSurahName,
    ]);
    if (!mounted) return;
    setState(() {
      _highestPageCompleted = results[0] as int;
      _bookmarkCount = (results[1] as List<QuranBookmark>).length;
      _lastListenedSurah = results[2] as int?;
      _lastListenedAyah = results[3] as int?;
      _lastListenedLabel = _formatAyahLabel(
        results[4] as String?,
        _lastListenedSurah,
        _lastListenedAyah,
      );
      _lastTajweedSurah = results[5] as int?;
      _lastTajweedAyah = results[6] as int?;
      _lastTajweedSurahName = results[7] as String?;
      _lastTajweedLabel = _formatAyahLabel(
        _lastTajweedSurahName,
        _lastTajweedSurah,
        _lastTajweedAyah,
      );
    });
  }

  String? _formatAyahLabel(String? surahName, int? surah, int? ayah) {
    if (surahName == null || surah == null || ayah == null) return null;
    return '$surahName $surah:$ayah';
  }

  Future<void> _loadContinueReading() async {
    final results = await Future.wait<Object?>([
      StorageService.quranLastMode,
      StorageService.quranLastSurah,
      StorageService.quranLastAyah,
      StorageService.quranLastPage,
      StorageService.quranLastJuz,
    ]);
    if (!mounted) return;

    final surah = results[1] as int?;
    final ayah = results[2] as int?;
    if (surah != null && ayah != null) {
      final surahSummary = _allSurahs.firstWhere(
        (s) => s.number == surah,
        orElse: () => _allSurahs.isEmpty
            ? const SurahSummary(
                number: 1,
                name: '',
                arabicName: '',
                verses: 0,
                revelationType: '',
              )
            : _allSurahs.first,
      );
      final page = (results[3] as int?) ?? 1;
      final juz = (results[4] as int?) ?? 1;
      final metadata = _metadata ?? await MushafMetadata.load();
      final juzPages = metadata.pagesInJuz(juz);
      final firstPage = metadata.firstPageOfJuz(juz) ?? 1;
      final juzProgress = juzPages.isEmpty
          ? 0
          : (((page - firstPage + 1) / juzPages.length) * 100).round().clamp(
              0,
              100,
            );

      setState(() {
        _continueReading = _ContinueReadingState(
          mode: ReadingMode.fromName(results[0] as String?),
          surahName: surahSummary.name,
          surahNumber: surah,
          ayahNumber: ayah,
          pageNumber: page,
          juzNumber: juz,
          juzProgressPercent: juzProgress,
        );
      });
    }
  }

  Future<void> _openContinueReading() async {
    final state = _continueReading;
    if (state == null) return;
    switch (state.mode) {
      case ReadingMode.surah:
        final surah = _allSurahs.firstWhere(
          (s) => s.number == state.surahNumber,
          orElse: () => _allSurahs.first,
        );
        await _openSurahDetail(surah, initialAyah: state.ayahNumber);
      case ReadingMode.juz:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => JuzReadingScreen(
              juzNumber: state.juzNumber,
              surah: state.surahNumber,
              ayah: state.ayahNumber,
            ),
          ),
        );
      case ReadingMode.page:
        await _openFullPage(state.pageNumber);
    }
    if (mounted) {
      await _loadContinueReading();
      await _refreshCounts();
    }
  }

  Future<void> _openFullPage(int page) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MushafFullPageScreen(initialPage: page),
      ),
    );
    if (mounted) {
      await _loadContinueReading();
      await _refreshCounts();
    }
  }

  void _onModeSelected(ReadingMode mode) {
    setState(() => _selectedMode = mode);
    unawaited(StorageService.setQuranDefaultReadingMode(mode.name));
  }

  Future<void> _openReadingSettings() async {
    await QuranReadingSettingsLauncher.open(context);
    if (!mounted) return;
    final themeName = await StorageService.quranReadingColorTheme;
    setState(
      () => _colorTheme = QuranReadingColorTheme.fromName(themeName),
    );
    await _loadContinueReading();
  }

  Future<void> _openBookmarks() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const QuranBookmarksScreen()),
    );
    if (mounted) await _refreshCounts();
  }

  Future<void> _openQuickTajweed() async {
    if (!await TajweedEntryPoint.isEnabled()) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.tajweedDisabledHint),
        ),
      );
      return;
    }

    var surahNumber = _lastTajweedSurah;
    var ayahNumber = _lastTajweedAyah;
    var surahName = _lastTajweedSurahName;

    if (surahNumber == null || ayahNumber == null) {
      final state = _continueReading;
      if (state == null) return;
      surahNumber = state.surahNumber;
      ayahNumber = state.ayahNumber;
      surahName = state.surahName;
    }

    final surah = _allSurahs.firstWhere(
      (s) => s.number == surahNumber,
      orElse: () => _allSurahs.first,
    );
    final ayahs = await QuranLocalRepository.instance.getAyahsBySurah(
      surahNumber,
    );
    final ayah = ayahs.firstWhere(
      (a) => a.ayahNumber == ayahNumber,
      orElse: () => ayahs.first,
    );
    if (!mounted) return;
    TajweedEntryPoint.open(
      context,
      surah: surahNumber,
      ayah: ayahNumber,
      arabicText: ayah.arabicText,
      surahName: surahName ?? surah.name,
      translation: ayah.englishText.isEmpty ? null : ayah.englishText,
    );
    if (mounted) await _refreshCounts();
  }

  Future<void> _openLastListened() async {
    final surahNumber = _lastListenedSurah;
    if (surahNumber == null) {
      await _openContinueReading();
      return;
    }
    SurahSummary? surah;
    for (final s in _allSurahs) {
      if (s.number == surahNumber) {
        surah = s;
        break;
      }
    }
    if (surah == null) {
      await _openContinueReading();
      return;
    }
    await _openSurahDetail(surah, initialAyah: _lastListenedAyah);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchActive = false;
        _searchResults = const [];
      });
      return;
    }
    unawaited(_runSearch(query));
  }

  Future<void> _runSearch(String query) async {
    final lower = query.toLowerCase();
    final results = <_SearchResult>[];
    final l10n = AppLocalizations.of(context)!;
    final metadata = _metadata ?? await MushafMetadata.load();

    // Page: "15" or "page 15"
    final pageMatch = RegExp(r'^(?:page\s*)?(\d{1,3})$', caseSensitive: false)
        .firstMatch(lower);
    if (pageMatch != null) {
      final page = int.tryParse(pageMatch.group(1)!);
      if (page != null && page >= 1 && page <= metadata.totalPages) {
        results.add(
          _SearchResult(
            kind: _SearchResultKind.page,
            title: '${l10n.quranPageLabel} $page',
            subtitle: l10n.quranOpenPage,
            surahNumber: 1,
            page: page,
          ),
        );
      }
    }

    // Juz: "juz 3" or "3" when small
    final juzMatch = RegExp(r'^(?:juz\s*)?(\d{1,2})$', caseSensitive: false)
        .firstMatch(lower);
    if (juzMatch != null) {
      final juz = int.tryParse(juzMatch.group(1)!);
      if (juz != null && juz >= 1 && juz <= metadata.totalJuz) {
        results.add(
          _SearchResult(
            kind: _SearchResultKind.juz,
            title: '${l10n.quranJuzLabel} $juz',
            subtitle: l10n.quranOpenJuz,
            surahNumber: 1,
            juz: juz,
          ),
        );
      }
    }

    // Ayah: "2:255" or "2 255"
    final ayahMatch = RegExp(r'^(\d{1,3})\s*[:\-]\s*(\d{1,3})$').firstMatch(query);
    if (ayahMatch != null) {
      final surah = int.parse(ayahMatch.group(1)!);
      final ayah = int.parse(ayahMatch.group(2)!);
      SurahSummary? surahSummary;
      for (final s in _allSurahs) {
        if (s.number == surah) {
          surahSummary = s;
          break;
        }
      }
      if (surahSummary != null && ayah <= surahSummary.verses) {
        results.add(
          _SearchResult(
            kind: _SearchResultKind.ayah,
            title: '${surahSummary.name} $surah:$ayah',
            subtitle: l10n.quranOpenAyah,
            surahNumber: surah,
            ayah: ayah,
          ),
        );
      }
    }

    // Surah name (English / Arabic / number)
    for (final surah in _allSurahs) {
      if (surah.name.toLowerCase().contains(lower) ||
          surah.arabicName.contains(query) ||
          surah.number.toString() == query) {
        results.add(
          _SearchResult(
            kind: _SearchResultKind.surah,
            title: surah.name,
            subtitle:
                '${surah.verses} ${l10n.quranVersesLabel} • ${surah.revelationType}',
            surahNumber: surah.number,
          ),
        );
      }
    }

    // Translation text (installed packs only, capped)
    if (query.length >= 3 && results.length < 12) {
      var scanned = 0;
      for (final surah in _allSurahs) {
        if (scanned > 8) break;
        final ayahs = await QuranLocalRepository.instance.getAyahsBySurah(
          surah.number,
        );
        scanned++;
        for (final ayah in ayahs) {
          final text = ayah.englishText.toLowerCase();
          if (text.isNotEmpty && text.contains(lower)) {
            results.add(
              _SearchResult(
                kind: _SearchResultKind.ayah,
                title: '${surah.name} ${surah.number}:${ayah.ayahNumber}',
                subtitle: ayah.englishText.length > 72
                    ? '${ayah.englishText.substring(0, 72)}…'
                    : ayah.englishText,
                surahNumber: surah.number,
                ayah: ayah.ayahNumber,
              ),
            );
            if (results.length >= 20) break;
          }
        }
        if (results.length >= 20) break;
      }
    }

    if (!mounted) return;
    setState(() {
      _searchActive = true;
      _searchResults = results;
    });
  }

  Future<void> _openSearchResult(_SearchResult result) async {
    switch (result.kind) {
      case _SearchResultKind.surah:
        final surah = _allSurahs.firstWhere(
          (s) => s.number == result.surahNumber,
        );
        await _openSurahDetail(surah);
      case _SearchResultKind.ayah:
        final surah = _allSurahs.firstWhere(
          (s) => s.number == result.surahNumber,
        );
        await _openSurahDetail(surah, initialAyah: result.ayah);
      case _SearchResultKind.page:
        await _openFullPage(result.page ?? 1);
      case _SearchResultKind.juz:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => JuzReadingScreen(juzNumber: result.juz ?? 1),
          ),
        );
        if (mounted) await _loadContinueReading();
    }
  }

  Future<void> _openSurahDetail(
    SurahSummary surah, {
    int? initialAyah,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SurahDetailBottomSheet(surah: surah, initialAyah: initialAyah),
      ),
    );
    if (mounted) {
      await _loadContinueReading();
      await _refreshCounts();
    }
  }

  Future<void> _openJuz(int juzNumber) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JuzReadingScreen(juzNumber: juzNumber),
      ),
    );
    if (mounted) {
      final last = await StorageService.quranLastJuz;
      setState(() => _lastOpenedJuz = last);
      await _loadContinueReading();
    }
  }

  Future<void> _bookmarkSurah(SurahSummary surah) async {
    await QuranBookmarkService.add(
      QuranBookmark(
        id: QuranBookmarkService.idFor(
          kind: QuranBookmarkKind.surah,
          surah: surah.number,
        ),
        kind: QuranBookmarkKind.surah,
        label: surah.name,
        surah: surah.number,
        createdAtMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    await _refreshCounts();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final palette = QuranReaderPalette.resolve(
      _colorTheme,
      Theme.of(context).brightness,
    );

    return QuranReaderThemeScope(
      palette: palette,
      child: Scaffold(
        appBar: CustomAppBar(
          title: l10n.libraryModuleQuran,
          subtitle: l10n.libraryModuleQuranSub,
          actions: [
            IconButton(
              tooltip: l10n.readingSettingsTitle,
              icon: Icon(
                Icons.tune_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: _openReadingSettings,
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_continueReading != null) ...[
                  SizedBox(height: 8.h),
                  ContinueReadingCard(
                    mode: _continueReading!.mode,
                    surahName: _continueReading!.surahName,
                    ayahNumber: _continueReading!.ayahNumber,
                    pageNumber: _continueReading!.pageNumber,
                    juzNumber: _continueReading!.juzNumber,
                    juzProgressPercent: _continueReading!.juzProgressPercent,
                    onTap: _openContinueReading,
                  ),
                ],
                SizedBox(height: 12.h),
                _QuickActionsRow(
                  bookmarkCount: _bookmarkCount,
                  lastTajweed: _lastTajweedLabel,
                  lastListened: _lastListenedLabel,
                  onTajweed: () => unawaited(_openQuickTajweed()),
                  onBookmarks: _openBookmarks,
                  onLastListened: _openLastListened,
                ),
                SizedBox(height: 14.h),
                QuranReadingModeTabs(
                  selected: _selectedMode,
                  onSelected: _onModeSelected,
                  surahLabel: l10n.quranModeSurah,
                  juzLabel: l10n.quranModeJuz,
                  pageLabel: l10n.quranModePage,
                ),
                SizedBox(height: 14.h),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.quranSearchHintExtended,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 18.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Expanded(child: _buildBody(context, l10n)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }
    if (_searchActive) {
      return _buildSearchResults(context, l10n);
    }
    return switch (_selectedMode) {
      ReadingMode.surah => _buildSurahList(context, l10n),
      ReadingMode.juz => _buildJuzList(context, l10n),
      ReadingMode.page => _buildPageGrid(context),
    };
  }

  Widget _buildSearchResults(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          l10n.quranNoResults,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }
    return ListView.separated(
      itemCount: _searchResults.length,
      separatorBuilder: (_, _) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          tileColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
          leading: Icon(_searchIcon(item.kind), color: colorScheme.primary),
          title: Text(item.title, style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(item.subtitle),
          onTap: () => unawaited(_openSearchResult(item)),
        );
      },
    );
  }

  Widget _buildPageGrid(BuildContext context) {
    final total = _metadata?.totalPages ?? 604;
    return QuranPageGrid(
      totalPages: total,
      highestCompletedPage: _highestPageCompleted,
      onPageTap: (page) => unawaited(_openFullPage(page)),
    );
  }

  Widget _buildJuzList(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

    return ListView.separated(
      itemCount: _juzList.length,
      separatorBuilder: (_, _) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final juz = _juzList[index];
        final metadata = _metadata;
        final pages = metadata?.pagesInJuz(juz.number) ?? const <int>[];
        final pageRange = pages.isEmpty
            ? ''
            : '${l10n.quranPageLabel}s ${pages.first}–${pages.last}';
        final isLastOpened = juz.number == _lastOpenedJuz;

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isLastOpened
                  ? colorScheme.primary.withValues(alpha: 0.45)
                  : borderColor,
            ),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            leading: CircleAvatar(
              backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
              child: Text(
                '${juz.number}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ),
            title: Text(
              '${l10n.quranJuzLabel} ${juz.number}',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(pageRange),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => unawaited(_openJuz(juz.number)),
            onLongPress: () => unawaited(
              QuranBookmarkService.add(
                QuranBookmark(
                  id: QuranBookmarkService.idFor(
                    kind: QuranBookmarkKind.juz,
                    surah: juz.startSurah,
                    juz: juz.number,
                  ),
                  kind: QuranBookmarkKind.juz,
                  label: '${l10n.quranJuzLabel} ${juz.number}',
                  surah: juz.startSurah,
                  juz: juz.number,
                  createdAtMs: DateTime.now().millisecondsSinceEpoch,
                ),
              ).then((_) => _refreshCounts()),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSurahList(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);
    final backgroundColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.20,
    );

    if (_allSurahs.isEmpty) {
      return Center(
        child: Text(
          l10n.quranNoSurahsFound,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return ListView.separated(
      itemCount: _allSurahs.length,
      separatorBuilder: (_, _) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final surah = _allSurahs[index];
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () => unawaited(_openSurahDetail(surah)),
            onLongPress: () => unawaited(_bookmarkSurah(surah)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      surah.number.toString(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surah.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${surah.verses} ${l10n.quranVersesLabel} • ${surah.revelationType}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    surah.arabicName,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _searchIcon(_SearchResultKind kind) => switch (kind) {
    _SearchResultKind.surah => Icons.menu_book_rounded,
    _SearchResultKind.page => Icons.auto_stories_rounded,
    _SearchResultKind.juz => Icons.bookmark_rounded,
    _SearchResultKind.ayah => Icons.format_quote_rounded,
  };
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.bookmarkCount,
    required this.lastTajweed,
    required this.lastListened,
    required this.onTajweed,
    required this.onBookmarks,
    required this.onLastListened,
  });

  final int bookmarkCount;
  final String? lastTajweed;
  final String? lastListened;
  final VoidCallback onTajweed;
  final VoidCallback onBookmarks;
  final VoidCallback onLastListened;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _QuickActionTile(
            icon: Icons.mic_rounded,
            title: l10n.quranQuickTajweed,
            subtitle: lastTajweed ?? l10n.quranQuickTajweedSub,
            onTap: onTajweed,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.bookmark_rounded,
            title: l10n.quranBookmarksTitle,
            subtitle: l10n.quranBookmarkCount(bookmarkCount),
            onTap: onBookmarks,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.headphones_rounded,
            title: l10n.quranLastListened,
            subtitle: lastListened ?? l10n.quranNoneYet,
            onTap: onLastListened,
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18.sp, color: colorScheme.primary),
              SizedBox(height: 6.h),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueReadingState {
  const _ContinueReadingState({
    required this.mode,
    required this.surahName,
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    required this.juzNumber,
    required this.juzProgressPercent,
  });

  final ReadingMode mode;
  final String surahName;
  final int surahNumber;
  final int ayahNumber;
  final int pageNumber;
  final int juzNumber;
  final int juzProgressPercent;
}
