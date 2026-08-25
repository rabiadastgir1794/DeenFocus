import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/services/quran_translation_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../l10n/app_localizations.dart';
import '../data/quran_local_repository.dart';
import '../reading_engine/mushaf_metadata.dart';
import '../reading_engine/quran_audio_controller.dart';
import '../reading_engine/quran_arabic_font.dart';
import '../reading_engine/quran_display_prefs.dart';
import '../reading_engine/quran_repeat_mode.dart';
import '../reading_engine/quran_layout_theme.dart';
import '../reading_engine/quran_reading_color_theme.dart';
import '../reading_engine/quran_script.dart';
import '../reading_engine/reading_engine.dart';
import '../reading_engine/reading_mode.dart';
import 'widgets/mushaf_ayah_selection_chrome.dart';
import 'widgets/mushaf_page_text.dart';
import 'widgets/quran_audio_bar.dart';
import 'widgets/quran_mushaf_page_frame.dart';
import 'widgets/quran_reader_app_bar.dart';
import 'widgets/quran_reader_background.dart';
import 'widgets/quran_reader_bottom_actions.dart';
import 'widgets/quran_reader_icon_button.dart';
import 'widgets/quran_reader_info_bar.dart';
import 'widgets/quran_reader_theme.dart';
import 'quran_reading_settings_launcher.dart';

/// Full 604-page Mushaf reader opened from the Page tab grid.
class MushafFullPageScreen extends StatefulWidget {
  const MushafFullPageScreen({super.key, required this.initialPage});

  final int initialPage;

  @override
  State<MushafFullPageScreen> createState() => _MushafFullPageScreenState();
}

class _MushafFullPageScreenState extends State<MushafFullPageScreen> {
  late final ReadingEngine _engine = ReadingEngine(mode: ReadingMode.page);
  final QuranAudioController _audio = QuranAudioController();
  late final PageController _pageController;
  late int _totalPages;
  MushafMetadata? _metadata;

  bool _loading = true;
  int _pageIndex = 0;
  int _highestCompleted = 0;
  int _selectedIndex = -1;
  final Map<int, List<AyahRecord>> _pageAyahs = <int, List<AyahRecord>>{};
  Map<int, SurahSummary> _surahByNumber = const <int, SurahSummary>{};
  Future<void>? _playlistLoadFuture;

  bool _showEnglish = true;
  double _arabicFontSp = 20;
  double _englishFontSp = 15;
  double _lineSpacing = 1.8;
  String? _arabicFontFamily = QuranScript.uthmani.fontFamily;
  List<String>? _arabicFontFamilyFallback;
  double _speed = 1.0;
  double _volume = 1.0;
  QuranRepeatMode _repeatMode = QuranRepeatMode.off;
  QuranReadingColorTheme _colorTheme = QuranReadingColorTheme.emerald;
  QuranLayoutTheme _layoutTheme = QuranLayoutTheme.classic;

  bool _showAudioBar = false;
  bool _isAudioLoading = false;
  bool _isUserSeeking = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;

  int get _currentPage => _pageIndex + 1;
  bool get _isLastPage => _currentPage >= _totalPages;

  List<AyahRecord> get _currentAyahs =>
      _pageAyahs[_currentPage] ?? const <AyahRecord>[];

  @override
  void initState() {
    super.initState();
    _pageIndex = (widget.initialPage - 1).clamp(0, 603);
    _pageController = PageController(initialPage: _pageIndex);
    QuranTranslationService.installationRevision.addListener(
      _onTranslationInstalled,
    );
    _bindPlayerState();
    unawaited(_bootstrap());
  }

  @override
  void dispose() {
    QuranTranslationService.installationRevision.removeListener(
      _onTranslationInstalled,
    );
    _positionSub?.cancel();
    _durationSub?.cancel();
    _pageController.dispose();
    unawaited(_audio.dispose());
    _engine.dispose();
    super.dispose();
  }

  void _onTranslationInstalled() {
    unawaited(_reloadAllLoadedPages());
  }

  Future<void> _reloadAllLoadedPages() async {
    final keys = _pageAyahs.keys.toList(growable: false);
    for (final page in keys) {
      await _ensurePageLoaded(page, force: true);
    }
    if (mounted) setState(() {});
  }

  void _bindPlayerState() {
    final player = _audio.player;
    player.playbackEventStream.listen((_) {
      if (!mounted) return;
      final state = player.processingState;
      final loading =
          state == ProcessingState.loading ||
          state == ProcessingState.buffering;
      if (_isAudioLoading != loading) setState(() => _isAudioLoading = loading);
      if (state == ProcessingState.completed) _closeAudioBar();
    });

    player.currentIndexStream.listen((index) {
      if (!mounted || index == null || !_showAudioBar) return;
      final ayahs = _currentAyahs;
      if (index < 0 || index >= ayahs.length) return;
      setState(() => _selectedIndex = index);
      _trackCurrentPage(ayahIndex: index);
      if (_audio.player.playing) {
        _recordListened(index);
      }
    });

    player.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });

    _positionSub = player.positionStream.listen((position) {
      if (!mounted || _isUserSeeking) return;
      setState(() => _position = position);
    });
    _durationSub = player.durationStream.listen((duration) {
      if (!mounted) return;
      setState(() => _duration = duration ?? Duration.zero);
    });
  }

  Future<void> _bootstrap() async {
    final results = await Future.wait<Object>([
      MushafMetadata.load(),
      QuranLocalRepository.instance.getSurahs(),
      StorageService.quranShowEnglish,
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
      StorageService.quranLineSpacing,
      StorageService.quranPlaybackSpeed,
      StorageService.quranPlaybackVolume,
      StorageService.quranRepeatMode,
      StorageService.quranScript,
      StorageService.quranArabicFont.then((v) => v ?? ''),
      StorageService.quranHighestPageCompleted,
      StorageService.quranReadingColorTheme,
      StorageService.quranLayoutTheme,
    ]);
    if (!mounted) return;
    final metadata = results[0] as MushafMetadata;
    final surahs = results[1] as List<SurahSummary>;
    final script = QuranScriptX.fromName(results[9] as String);
    final arabicFont = QuranArabicFont.resolve(
      savedName: results[10] as String,
      script: script,
    );
    setState(() {
      _metadata = metadata;
      _totalPages = metadata.totalPages;
      _surahByNumber = {for (final s in surahs) s.number: s};
      _showEnglish = results[2] as bool;
      _arabicFontSp = results[3] as double;
      _englishFontSp = results[4] as double;
      _lineSpacing = results[5] as double;
      _speed = results[6] as double;
      _volume = results[7] as double;
      _repeatMode = QuranRepeatMode.fromName(results[8] as String);
      _arabicFontFamily = arabicFont.fontFamily;
      _arabicFontFamilyFallback = arabicFont.fontFamilyFallback;
      _highestCompleted = results[11] as int;
      _colorTheme = QuranReadingColorTheme.fromName(results[12] as String);
      _layoutTheme = QuranLayoutTheme.fromName(results[13] as String);
      _loading = false;
    });
    await _audio.loadPreferences();
    await _ensurePageLoaded(_currentPage);
    await _loadPagePlaylist(_currentPage, autoPlay: false);
    _trackCurrentPage();
  }

  Future<void> _ensurePageLoaded(int page, {bool force = false}) async {
    if (!force && _pageAyahs.containsKey(page)) return;
    final metadata = await MushafMetadata.load();
    final locations = metadata.ayahsOnPage(page);
    if (locations.isEmpty) {
      _pageAyahs[page] = const [];
      return;
    }
    final ayahs = await QuranLocalRepository.instance.getAyahsByKeys(
      locations.map((l) => (l.surah, l.ayah)).toList(growable: false),
    );
    _pageAyahs[page] = ayahs;
  }

  Future<void> _loadPagePlaylist(int page, {required bool autoPlay}) async {
    final ayahs = _pageAyahs[page] ?? const <AyahRecord>[];
    if (ayahs.isEmpty) return;
    final future = _audio.setPlaylist(ayahs);
    _playlistLoadFuture = future;
    await future;
    if (autoPlay) {
      await _audio.player.play();
    }
  }

  void _trackCurrentPage({int ayahIndex = 0}) {
    final ayahs = _pageAyahs[_currentPage];
    if (ayahs == null || ayahs.isEmpty) return;
    final index = ayahIndex.clamp(0, ayahs.length - 1);
    final ayah = ayahs[index];
    _engine.trackPageVisit(
      _currentPage,
      surah: ayah.surahNumber,
      ayah: ayah.ayahNumber,
    );
  }

  Future<void> _onPageChanged(int index) async {
    final page = index + 1;
    setState(() {
      _pageIndex = index;
      _selectedIndex = -1;
      _showAudioBar = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    await _audio.player.stop();
    await _ensurePageLoaded(page);
    await _loadPagePlaylist(page, autoPlay: false);
    _trackCurrentPage();
    if (mounted) setState(() {});
  }

  void _onAyahTap(int index) {
    final ayahs = _currentAyahs;
    if (index < 0 || index >= ayahs.length) return;
    unawaited(_audio.player.stop());
    setState(() {
      _selectedIndex = index;
      _showAudioBar = false;
      _isAudioLoading = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    _trackCurrentPage(ayahIndex: index);
  }

  void _recordListened(int ayahIndex) {
    final ayahs = _currentAyahs;
    if (ayahIndex < 0 || ayahIndex >= ayahs.length) return;
    final ayah = ayahs[ayahIndex];
    final surah = _surahByNumber[ayah.surahNumber];
    unawaited(
      StorageService.setQuranLastListened(
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        surahName: surah?.name ?? 'Surah ${ayah.surahNumber}',
      ),
    );
  }

  Future<void> _playSelectedAyah() async {
    final ayahs = _currentAyahs;
    if (_selectedIndex < 0 || _selectedIndex >= ayahs.length) return;
    final targetPage = _currentPage;
    final index = _selectedIndex;
    setState(() {
      _showAudioBar = true;
      _isAudioLoading = true;
    });
    try {
      final pending = _playlistLoadFuture;
      if (pending != null) await pending;
      if (!mounted || _currentPage != targetPage) return;
      await _audio.player.seek(Duration.zero, index: index);
      await _audio.player.play();
      _recordListened(index);
      _trackCurrentPage(ayahIndex: index);
    } catch (_) {
      if (mounted) {
        setState(() {
          _isAudioLoading = false;
          _showAudioBar = false;
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    final player = _audio.player;
    if (player.playing) {
      await player.pause();
    } else if (_selectedIndex >= 0) {
      if (!_showAudioBar) {
        await _playSelectedAyah();
      } else {
        await player.play();
      }
    }
  }

  void _closeAudioBar() {
    unawaited(_audio.player.stop());
    setState(() {
      _showAudioBar = false;
      _isAudioLoading = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
  }

  void _clearSelection() {
    unawaited(_audio.player.stop());
    setState(() {
      _selectedIndex = -1;
      _showAudioBar = false;
      _isAudioLoading = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
  }

  Future<void> _markCurrentPageRead() async {
    await StorageService.markQuranPageCompleted(_currentPage);
    if (!mounted) return;
    setState(() => _highestCompleted = _currentPage);
    _trackCurrentPage(
      ayahIndex: _selectedIndex >= 0 ? _selectedIndex : 0,
    );
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.quranPageMarkedRead(_currentPage),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _goToNextPage() async {
    if (_isLastPage) return;
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  Widget _buildPageContent({
    required List<AyahRecord> pageAyahs,
    required bool isCurrent,
  }) {
    final text = MushafPageText(
      key: ValueKey('text-$_layoutTheme'),
      ayahs: pageAyahs,
      playingIndex: isCurrent ? _selectedIndex : -1,
      arabicFontSp: _arabicFontSp,
      arabicFontFamily: _arabicFontFamily,
      arabicFontFamilyFallback: _arabicFontFamilyFallback,
      lineSpacing: _lineSpacing,
      layoutTheme: _layoutTheme,
      surahByNumber: _surahByNumber,
      onAyahTap: isCurrent ? _onAyahTap : (_) {},
    );
    if (_layoutTheme.isMushafStyle) {
      return QuranMushafPageFrame(child: text);
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: text,
    );
  }

  Future<void> _reloadDisplayPrefs() async {
    final results = await Future.wait<Object>([
      StorageService.quranShowEnglish,
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
      StorageService.quranLineSpacing,
      QuranDisplayPrefs.load(),
      StorageService.quranReadingColorTheme,
      StorageService.quranLayoutTheme,
    ]);
    if (!mounted) return;
    final display = results[4] as QuranDisplayPrefs;
    setState(() {
      _showEnglish = results[0] as bool;
      _arabicFontSp = results[1] as double;
      _englishFontSp = results[2] as double;
      _lineSpacing = results[3] as double;
      _arabicFontFamily = display.fontFamily;
      _arabicFontFamilyFallback = display.fontFamilyFallback;
      _colorTheme = QuranReadingColorTheme.fromName(results[5] as String);
      _layoutTheme = QuranLayoutTheme.fromName(results[6] as String);
    });
    // Force-reload cached pages so script/translation overlays refresh.
    await _reloadAllLoadedPages();
  }

  int _juzForPage(int page) {
    final ayahs = _pageAyahs[page];
    if (ayahs != null && ayahs.isNotEmpty) {
      return _metadata?.juzForAyah(ayahs.first.surahNumber, ayahs.first.ayahNumber) ??
          1;
    }
    final locs = _metadata?.ayahsOnPage(page);
    if (locs != null && locs.isNotEmpty) return locs.first.juz;
    return 1;
  }

  String? _surahHeadlineForPage(int page) {
    final ayahs = _pageAyahs[page];
    if (ayahs == null || ayahs.isEmpty) return null;
    final surah = _surahByNumber[ayahs.first.surahNumber];
    if (surah == null) return null;
    return surah.name;
  }

  void _showPageInfoSheet() {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.quranReader;
    final ayahs = _currentAyahs;
    final juz = _juzForPage(_currentPage);
    final progress = _totalPages > 0 ? _highestCompleted / _totalPages : 0.0;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: palette.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.quranPageLabel} $_currentPage',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              _InfoRow(label: l10n.quranJuzLabel, value: '$juz'),
              _InfoRow(
                label: l10n.quranSurahLabel,
                value: _surahHeadlineForPage(_currentPage) ?? '—',
              ),
              _InfoRow(label: 'Ayahs on page', value: '${ayahs.length}'),
              _InfoRow(
                label: 'Reading progress',
                value: '${(progress * 100).round()}%',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = QuranReaderPalette.resolve(
      _colorTheme,
      Theme.of(context).brightness,
    );

    if (_loading) {
      return QuranReaderThemeScope(
        palette: palette,
        child: Scaffold(
          backgroundColor: palette.background,
          appBar: QuranReaderAppBar(title: l10n.quranModePage),
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final ayahs = _currentAyahs;
    final hasSelection =
        _selectedIndex >= 0 && _selectedIndex < ayahs.length;
    final showAudioBar = _showAudioBar && hasSelection;
    final showTranslation = hasSelection &&
        _showEnglish &&
        !showAudioBar;
    final showPlayOnlyChip =
        hasSelection && !_showEnglish && !showAudioBar;
    final bottomChrome = showAudioBar
        ? 300.h
        : (showTranslation || showPlayOnlyChip ? 210.h : 108.h);
    final readingProgress =
        _totalPages > 0 ? _highestCompleted / _totalPages : 0.0;
    final currentJuz = _juzForPage(_currentPage);

    return QuranReaderThemeScope(
      palette: palette,
      child: Scaffold(
      backgroundColor: palette.background,
      appBar: QuranReaderAppBar(
        title: _surahHeadlineForPage(_currentPage) ?? l10n.quranModePage,
        subtitle: '${l10n.quranPageLabel} $_currentPage',
        onBack: () => Navigator.of(context).pop(),
        actions: [
          QuranReaderIconButton(
            icon: Icons.chevron_left_rounded,
            tooltip: l10n.quranPreviousPage,
            onPressed: _pageIndex > 0
                ? () => _pageController.previousPage(
                      duration: QuranReaderPalette.animDuration,
                      curve: QuranReaderPalette.animCurve,
                    )
                : null,
          ),
          QuranReaderIconButton(
            icon: Icons.chevron_right_rounded,
            tooltip: l10n.quranNextPage,
            onPressed: !_isLastPage ? () => unawaited(_goToNextPage()) : null,
          ),
          QuranReaderIconButton(
            icon: Icons.info_outline_rounded,
            tooltip: 'Info',
            onPressed: _showPageInfoSheet,
          ),
          QuranReaderIconButton(
            icon: Icons.tune_rounded,
            tooltip: l10n.readingSettingsTitle,
            onPressed: () async {
              await QuranReadingSettingsLauncher.open(context);
              if (mounted) await _reloadDisplayPrefs();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const QuranReaderBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedSwitcher(
                duration: QuranReaderPalette.animDuration,
                switchInCurve: QuranReaderPalette.animCurve,
                switchOutCurve: QuranReaderPalette.animCurve,
                child: QuranReaderInfoBar(
                  key: ValueKey('info-$_currentPage'),
                  juzNumber: currentJuz,
                  pageNumber: _currentPage,
                  progress: readingProgress,
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _totalPages,
                    onPageChanged: (i) => unawaited(_onPageChanged(i)),
                    itemBuilder: (context, index) {
                      final page = index + 1;
                      final pageAyahs = _pageAyahs[page];
                      if (pageAyahs == null) {
                        unawaited(_ensurePageLoaded(page).then((_) {
                          if (mounted) setState(() {});
                        }));
                        return const Center(child: CircularProgressIndicator());
                      }
                      final isCurrent = index == _pageIndex;
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: AnimatedSwitcher(
                          duration: QuranReaderPalette.animDuration,
                          child: SingleChildScrollView(
                            key: ValueKey('page-$page-${_layoutTheme.name}'),
                            padding: EdgeInsets.only(
                              bottom: isCurrent ? bottomChrome : 108.h,
                            ),
                            child: pageAyahs.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(top: 48.h),
                                    child: Center(
                                      child: Text(
                                        l10n.quranPageEmpty,
                                        style: TextStyle(
                                          color: palette.textSecondary,
                                        ),
                                      ),
                                    ),
                                  )
                                : _buildPageContent(
                                    pageAyahs: pageAyahs,
                                    isCurrent: isCurrent,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: AnimatedSize(
          duration: QuranReaderPalette.animDuration,
          curve: QuranReaderPalette.animCurve,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: QuranReaderPalette.animDuration,
                child: showAudioBar
                    ? QuranAudioBar(
                        key: const ValueKey('audio'),
                        floating: false,
                        label:
                            '${l10n.quranSurahLabel} ${ayahs[_selectedIndex].surahNumber}:${ayahs[_selectedIndex].ayahNumber}',
                        position: _position,
                        duration: _duration,
                        isPlaying: _audio.player.playing,
                        isLoading: _isAudioLoading,
                        speed: _speed,
                        volume: _volume,
                        repeatMode: _repeatMode,
                        onTogglePlayPause: _togglePlayPause,
                        onClose: _closeAudioBar,
                        onSeekStart: () => _isUserSeeking = true,
                        onSeekChanged: (value) {
                          if (_duration.inMilliseconds <= 0) return;
                          final ms =
                              (_duration.inMilliseconds * value).toInt();
                          setState(
                            () => _position = Duration(milliseconds: ms),
                          );
                        },
                        onSeekEnd: (value) async {
                          _isUserSeeking = false;
                          if (_duration.inMilliseconds <= 0) return;
                          final ms =
                              (_duration.inMilliseconds * value).toInt();
                          await _audio.player.seek(
                            Duration(milliseconds: ms),
                          );
                        },
                        onSpeedChanged: (value) {
                          setState(() => _speed = value);
                          unawaited(_audio.setSpeed(value));
                        },
                        onVolumeChanged: (value) {
                          setState(() => _volume = value);
                          unawaited(_audio.setVolume(value));
                        },
                        onRepeatModeChanged: (value) {
                          setState(() => _repeatMode = value);
                          unawaited(_audio.setRepeatMode(value));
                        },
                      )
                    : const SizedBox.shrink(key: ValueKey('no-audio')),
              ),
              if (showTranslation)
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                  child: MushafAyahTranslationStrip(
                    ayah: ayahs[_selectedIndex],
                    fontSp: _englishFontSp,
                    surahLabel: l10n.quranSurahLabel,
                    onPlay: () => unawaited(_playSelectedAyah()),
                    onClose: _clearSelection,
                  ),
                ),
              if (showPlayOnlyChip)
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                  child: MushafAyahPlayChip(
                    label:
                        '${l10n.quranSurahLabel} ${ayahs[_selectedIndex].surahNumber}:${ayahs[_selectedIndex].ayahNumber}',
                    onPlay: () => unawaited(_playSelectedAyah()),
                    onClose: _clearSelection,
                  ),
                ),
              QuranReaderBottomActions(
                readLabel: l10n.quranMarkPageRead,
                nextLabel: _isLastPage
                    ? l10n.quranMushafComplete
                    : l10n.quranNextPage,
                readCompleted: _currentPage <= _highestCompleted,
                nextEnabled: !_isLastPage,
                onRead: ayahs.isEmpty
                    ? null
                    : () => unawaited(_markCurrentPageRead()),
                onNext: _isLastPage ? null : () => unawaited(_goToNextPage()),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: palette.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
