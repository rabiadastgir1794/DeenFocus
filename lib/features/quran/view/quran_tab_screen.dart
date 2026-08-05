import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../data/quran_local_repository.dart';
import '../reading_engine/reading_mode.dart';
import 'juz_list_screen.dart';
import 'juz_reading_screen.dart';
import 'mushaf_page_screen.dart';
import 'quran_reading_settings_launcher.dart';
import 'surah_detail_bottom_sheet.dart';
import 'widgets/continue_reading_card.dart';

class QuranTabScreen extends StatefulWidget {
  const QuranTabScreen({super.key});

  @override
  State<QuranTabScreen> createState() => _QuranTabScreenState();
}

class _QuranTabScreenState extends State<QuranTabScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SurahSummary> _allSurahs = const <SurahSummary>[];
  List<SurahSummary> _filteredSurahs = const <SurahSummary>[];
  bool _isLoading = true;
  String? _error;
  ReadingMode _selectedMode = ReadingMode.surah;
  _ContinueReadingState? _continueReading;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSurahs();
    _loadContinueReading();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    try {
      final surahs = await QuranLocalRepository.instance.getSurahs();
      if (!mounted) return;
      setState(() {
        _allSurahs = surahs;
        _filteredSurahs = surahs;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.quranLoadFailed;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadContinueReading() async {
    final results = await Future.wait<Object?>([
      StorageService.quranLastMode,
      StorageService.quranLastSurah,
      StorageService.quranLastAyah,
      StorageService.quranLastPage,
      StorageService.quranLastJuz,
      StorageService.quranDefaultReadingMode,
    ]);
    if (!mounted) return;

    final surah = results[1] as int?;
    final ayah = results[2] as int?;
    if (surah != null && ayah != null) {
      final surahs = await QuranLocalRepository.instance.getSurahs();
      final surahSummary = surahs.firstWhere(
        (s) => s.number == surah,
        orElse: () => surahs.isEmpty
            ? const SurahSummary(
                number: 1,
                name: '',
                arabicName: '',
                verses: 0,
                revelationType: '',
              )
            : surahs.first,
      );
      if (!mounted) return;
      setState(() {
        _continueReading = _ContinueReadingState(
          mode: ReadingMode.fromName(results[0] as String?),
          surahName: surahSummary.name,
          surahNumber: surah,
          ayahNumber: ayah,
          pageNumber: (results[3] as int?) ?? 1,
          juzNumber: (results[4] as int?) ?? 1,
        );
      });
    }
    setState(() {
      _selectedMode = ReadingMode.fromName(results[5] as String?);
    });
  }

  Future<void> _openContinueReading() async {
    final state = _continueReading;
    if (state == null) return;
    switch (state.mode) {
      case ReadingMode.surah:
        final surahs = _allSurahs.isNotEmpty
            ? _allSurahs
            : await QuranLocalRepository.instance.getSurahs();
        final surah = surahs.firstWhere(
          (s) => s.number == state.surahNumber,
          orElse: () => surahs.first,
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
        final surahs = _allSurahs.isNotEmpty
            ? _allSurahs
            : await QuranLocalRepository.instance.getSurahs();
        if (!mounted) return;
        final surah = surahs.firstWhere(
          (s) => s.number == state.surahNumber,
          orElse: () => surahs.first,
        );
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => MushafPageScreen(
              surah: surah,
              initialPage: state.pageNumber,
            ),
          ),
        );
    }
    if (mounted) await _loadContinueReading();
  }

  Future<void> _onModeSelected(ReadingMode mode) async {
    setState(() => _selectedMode = mode);
    unawaited(StorageService.setQuranDefaultReadingMode(mode.name));
    switch (mode) {
      case ReadingMode.surah:
      case ReadingMode.page:
        // Both modes keep the surah list inline; tapping a surah opens
        // either SurahDetailBottomSheet (Surah) or MushafPageScreen (Page).
        return;
      case ReadingMode.juz:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const JuzListScreen()),
        );
        if (mounted) await _loadContinueReading();
    }
  }

  Future<void> _openReadingSettings() async {
    await QuranReadingSettingsLauncher.open(context);
    if (mounted) await _loadContinueReading();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredSurahs = _allSurahs);
      return;
    }

    setState(() {
      _filteredSurahs = _allSurahs
          .where((surah) {
            return surah.name.toLowerCase().contains(query) ||
                surah.arabicName.contains(query) ||
                surah.number.toString().contains(query);
          })
          .toList(growable: false);
    });
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
    if (mounted) await _loadContinueReading();
  }

  Future<void> _openSurahPageView(SurahSummary surah) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MushafPageScreen(surah: surah),
      ),
    );
    if (mounted) await _loadContinueReading();
  }

  void _onSurahTapped(SurahSummary surah) {
    if (_selectedMode == ReadingMode.page) {
      unawaited(_openSurahPageView(surah));
    } else {
      unawaited(_openSurahDetail(surah));
    }
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
                          l10n.tabQuran,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          l10n.quranTabSubtitle,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
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
              if (_continueReading != null) ...[
                SizedBox(height: 12.h),
                ContinueReadingCard(
                  mode: _continueReading!.mode,
                  surahName: _continueReading!.surahName,
                  ayahNumber: _continueReading!.ayahNumber,
                  pageNumber: _continueReading!.pageNumber,
                  juzNumber: _continueReading!.juzNumber,
                  onTap: _openContinueReading,
                ),
              ],
              SizedBox(height: 14.h),
              SegmentedButton<ReadingMode>(
                segments: [
                  ButtonSegment(
                    value: ReadingMode.surah,
                    label: Text(l10n.quranModeSurah),
                  ),
                  ButtonSegment(
                    value: ReadingMode.juz,
                    label: Text(l10n.quranModeJuz),
                  ),
                  ButtonSegment(
                    value: ReadingMode.page,
                    label: Text(l10n.quranModePage),
                  ),
                ],
                selected: {_selectedMode},
                onSelectionChanged: (selection) =>
                    _onModeSelected(selection.first),
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
                    hintText: l10n.quranSearchHint,
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
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);
    final backgroundColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.20);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: TextStyle(color: colorScheme.error)),
      );
    }
    if (_filteredSurahs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 32.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.quranNoSurahsFound,
              style: TextStyle(
                fontSize: 13.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _filteredSurahs.length,
      separatorBuilder: (_, _) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final surah = _filteredSurahs[index];
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () => _onSurahTapped(surah),
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
}

class _ContinueReadingState {
  const _ContinueReadingState({
    required this.mode,
    required this.surahName,
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    required this.juzNumber,
  });

  final ReadingMode mode;
  final String surahName;
  final int surahNumber;
  final int ayahNumber;
  final int pageNumber;
  final int juzNumber;
}
