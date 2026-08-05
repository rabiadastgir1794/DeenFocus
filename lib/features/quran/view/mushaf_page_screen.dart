import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/services/quran_translation_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../data/quran_local_repository.dart';
import '../reading_engine/mushaf_metadata.dart';
import '../reading_engine/quran_audio_controller.dart';
import '../reading_engine/quran_repeat_mode.dart';
import '../reading_engine/quran_script.dart';
import '../reading_engine/reading_engine.dart';
import '../reading_engine/reading_mode.dart';
import 'widgets/mushaf_page_text.dart';
import 'widgets/quran_audio_bar.dart';
import 'quran_reading_settings_launcher.dart';

/// Surah-scoped Mushaf Page View. Opens one [surah] and swipes only the
/// Madani Mushaf pages that contain that surah (not the full 604-page Quran).
///
/// Pages use [TextDirection.rtl] so Arabic reading matches a printed Mushaf:
/// swipe left → right to advance to the next page.
class MushafPageScreen extends StatefulWidget {
  const MushafPageScreen({
    super.key,
    required this.surah,
    this.initialPage,
  });

  final SurahSummary surah;

  /// Madani Mushaf page number to open (must belong to [surah]). Falls back
  /// to the first page of the surah when null or out of range.
  final int? initialPage;

  @override
  State<MushafPageScreen> createState() => _MushafPageScreenState();
}

class _MushafPageScreenState extends State<MushafPageScreen> {
  late final ReadingEngine _engine = ReadingEngine(mode: ReadingMode.page);
  final QuranAudioController _audio = QuranAudioController();

  bool _loading = true;
  /// Madani page numbers for [widget.surah], ascending.
  List<int> _surahPages = const <int>[];
  /// Index into [_surahPages] for the visible page.
  int _pageIndex = 0;
  late PageController _pageController;
  Map<int, List<AyahRecord>> _pageAyahs = const <int, List<AyahRecord>>{};
  Map<int, SurahSummary> _surahByNumber = const <int, SurahSummary>{};

  /// Tracks the in-flight [QuranAudioController.setPlaylist] call so ayah
  /// taps that land while a page swipe is still loading its playlist wait
  /// for it instead of seeking into a stale/half-loaded audio source.
  Future<void>? _playlistLoadFuture;

  bool _showEnglish = true;
  double _arabicFontSp = 20;
  double _englishFontSp = 15;
  double _lineSpacing = 1.8;
  String _arabicFontFamily = QuranScript.uthmani.fontFamily;
  double _speed = 1.0;
  double _volume = 1.0;
  QuranRepeatMode _repeatMode = QuranRepeatMode.off;

  int _selectedIndex = -1;
  bool _showAudioBar = false;
  bool _isAudioLoading = false;
  bool _isUserSeeking = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;

  int get _currentMushafPage =>
      _surahPages.isEmpty ? 1 : _surahPages[_pageIndex];

  @override
  void initState() {
    super.initState();
    QuranTranslationService.installationRevision.addListener(
      _onTranslationInstalled,
    );
    _bootstrap();
    _bindPlayerState();
  }

  @override
  void dispose() {
    QuranTranslationService.installationRevision.removeListener(
      _onTranslationInstalled,
    );
    _positionSub?.cancel();
    _durationSub?.cancel();
    if (!_loading) _pageController.dispose();
    unawaited(_audio.dispose());
    _engine.dispose();
    super.dispose();
  }

  void _onTranslationInstalled() {
    unawaited(_reloadTranslationTexts());
  }

  Future<void> _reloadTranslationTexts() async {
    if (_loading || !mounted) return;
    final surahNumber = widget.surah.number;
    final metadata = await MushafMetadata.load();
    final ayahs = await QuranLocalRepository.instance.getAyahsBySurah(
      surahNumber,
    );
    final byKey = <String, AyahRecord>{
      for (final a in ayahs) '${a.surahNumber}:${a.ayahNumber}': a,
    };
    final pageAyahs = <int, List<AyahRecord>>{};
    for (final page in _surahPages) {
      pageAyahs[page] = metadata
          .ayahsOfSurahOnPage(surahNumber, page)
          .map((loc) => byKey['${loc.surah}:${loc.ayah}'])
          .whereType<AyahRecord>()
          .toList(growable: false);
    }
    if (!mounted) return;
    setState(() => _pageAyahs = pageAyahs);
  }

  Future<void> _bootstrap() async {
    final prefsResults = await Future.wait<Object>([
      StorageService.quranShowEnglish,
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
      StorageService.quranLineSpacing,
      StorageService.quranPlaybackSpeed,
      StorageService.quranPlaybackVolume,
      StorageService.quranRepeatMode,
      StorageService.quranScript,
    ]);

    final metadata = await MushafMetadata.load();
    final surahNumber = widget.surah.number;
    final surahPages = metadata.pagesForSurah(surahNumber);
    final ayahs = await QuranLocalRepository.instance.getAyahsBySurah(
      surahNumber,
    );
    final byKey = <String, AyahRecord>{
      for (final a in ayahs) '${a.surahNumber}:${a.ayahNumber}': a,
    };
    final pageAyahs = <int, List<AyahRecord>>{};
    for (final page in surahPages) {
      pageAyahs[page] = metadata
          .ayahsOfSurahOnPage(surahNumber, page)
          .map((loc) => byKey['${loc.surah}:${loc.ayah}'])
          .whereType<AyahRecord>()
          .toList(growable: false);
    }

    var initialIndex = 0;
    final requested = widget.initialPage;
    if (requested != null) {
      final found = surahPages.indexOf(requested);
      if (found >= 0) initialIndex = found;
    } else {
      final remember = await StorageService.quranRememberLastPosition;
      final lastSurah = await StorageService.quranLastSurah;
      final lastPage = await StorageService.quranLastPage;
      if (remember &&
          lastSurah == surahNumber &&
          lastPage != null) {
        final found = surahPages.indexOf(lastPage);
        if (found >= 0) initialIndex = found;
      }
    }

    if (!mounted) return;
    setState(() {
      _showEnglish = prefsResults[0] as bool;
      _arabicFontSp = prefsResults[1] as double;
      _englishFontSp = prefsResults[2] as double;
      _lineSpacing = prefsResults[3] as double;
      _speed = prefsResults[4] as double;
      _volume = prefsResults[5] as double;
      _repeatMode = QuranRepeatMode.fromName(prefsResults[6] as String);
      _arabicFontFamily =
          QuranScriptX.fromName(prefsResults[7] as String).fontFamily;
      _surahPages = surahPages;
      _pageAyahs = pageAyahs;
      _surahByNumber = {surahNumber: widget.surah};
      _pageIndex = initialIndex.clamp(
        0,
        surahPages.isEmpty ? 0 : surahPages.length - 1,
      );
      _pageController = PageController(initialPage: _pageIndex);
      _loading = false;
    });

    await _audio.loadPreferences();
    if (_surahPages.isNotEmpty) {
      await _loadPagePlaylist(_currentMushafPage, autoPlay: false);
      _trackVisit(_currentMushafPage);
    }
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
      _trackVisit(_currentMushafPage, ayahIndex: index);
    });

    player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {});
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

  List<AyahRecord> get _currentAyahs =>
      _pageAyahs[_currentMushafPage] ?? const <AyahRecord>[];

  void _trackVisit(int mushafPage, {int ayahIndex = 0}) {
    final ayahs = _pageAyahs[mushafPage];
    if (ayahs == null || ayahs.isEmpty) return;
    final index = ayahIndex.clamp(0, ayahs.length - 1);
    final ayah = ayahs[index];
    _engine.trackPageVisit(
      mushafPage,
      surah: ayah.surahNumber,
      ayah: ayah.ayahNumber,
    );
  }

  Future<void> _loadPagePlaylist(int mushafPage, {required bool autoPlay}) async {
    final ayahs = _pageAyahs[mushafPage] ?? const <AyahRecord>[];
    if (ayahs.isEmpty) return;
    final future = _audio.setPlaylist(ayahs);
    _playlistLoadFuture = future;
    await future;
    if (autoPlay) {
      await _audio.player.play();
    }
  }

  Future<void> _onPageChanged(int index) async {
    if (index < 0 || index >= _surahPages.length) return;
    final mushafPage = _surahPages[index];
    setState(() {
      _pageIndex = index;
      _selectedIndex = -1;
      _showAudioBar = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    await _audio.player.stop();
    await _loadPagePlaylist(mushafPage, autoPlay: false);
    _trackVisit(mushafPage);
  }

  void _goToPageIndex(int index) {
    if (index < 0 || index >= _surahPages.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  /// Tap selects an ayah for highlight / translation only — never autoplays.
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
    _trackVisit(_currentMushafPage, ayahIndex: index);
  }

  /// Explicit play action — shows the audio bar and starts the selected ayah.
  Future<void> _playSelectedAyah() async {
    final ayahs = _currentAyahs;
    if (_selectedIndex < 0 || _selectedIndex >= ayahs.length) return;
    final targetPage = _currentMushafPage;
    final index = _selectedIndex;
    setState(() {
      _showAudioBar = true;
      _isAudioLoading = true;
    });
    try {
      final pending = _playlistLoadFuture;
      if (pending != null) await pending;
      if (!mounted || _currentMushafPage != targetPage) return;
      await _audio.player.seek(Duration.zero, index: index);
      await _audio.player.play();
      _trackVisit(targetPage, ayahIndex: index);
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

  Future<void> _reloadDisplayPrefs() async {
    final results = await Future.wait<Object>([
      StorageService.quranShowEnglish,
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
      StorageService.quranLineSpacing,
      StorageService.quranScript,
    ]);
    if (!mounted) return;
    setState(() {
      _showEnglish = results[0] as bool;
      _arabicFontSp = results[1] as double;
      _englishFontSp = results[2] as double;
      _lineSpacing = results[3] as double;
      _arabicFontFamily =
          QuranScriptX.fromName(results[4] as String).fontFamily;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return Scaffold(
        appBar: CustomAppBar(
          title: widget.surah.name,
          actions: [
            QuranReadingSettingsLauncher.appBarAction(context),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final ayahs = _currentAyahs;
    final hasSelection =
        _selectedIndex >= 0 && _selectedIndex < ayahs.length;
    final showAudioBar = _showAudioBar && hasSelection;
    final selectedAyah = hasSelection ? ayahs[_selectedIndex] : null;
    // Translation and audio never show together — avoids the overlap.
    // Hide strip while default English is still downloading (empty text).
    final showTranslation =
        hasSelection &&
        _showEnglish &&
        !showAudioBar &&
        (selectedAyah?.englishText.trim().isNotEmpty ?? false);
    final showPlayOnlyChip =
        hasSelection && !_showEnglish && !showAudioBar;
    final mushafPage = _currentMushafPage;
    final bottomChrome = showAudioBar
        ? 210.h
        : (showTranslation || showPlayOnlyChip ? 140.h : 16.h);

    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.surah.name} · ${l10n.quranPageLabel} $mushafPage',
        actions: [
          IconButton(
            tooltip: l10n.quranPreviousPage,
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: _pageIndex > 0
                ? () => _goToPageIndex(_pageIndex - 1)
                : null,
          ),
          IconButton(
            tooltip: l10n.quranNextPage,
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: _pageIndex < _surahPages.length - 1
                ? () => _goToPageIndex(_pageIndex + 1)
                : null,
          ),
          QuranReadingSettingsLauncher.appBarAction(
            context,
            onReturn: () => unawaited(_reloadDisplayPrefs()),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _surahPages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final page = _surahPages[index];
                  final pageAyahs = _pageAyahs[page] ?? const <AyahRecord>[];
                  final isCurrent = index == _pageIndex;
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: _MushafPageContent(
                      pageNumber: page,
                      ayahs: pageAyahs,
                      selectedIndex: isCurrent ? _selectedIndex : -1,
                      arabicFontSp: _arabicFontSp,
                      arabicFontFamily: _arabicFontFamily,
                      lineSpacing: _lineSpacing,
                      surahByNumber: _surahByNumber,
                      bottomPadding: isCurrent ? bottomChrome : 16.h,
                      onAyahTap: isCurrent ? _onAyahTap : (_) {},
                    ),
                  );
                },
              ),
            ),
            if (showTranslation)
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 8.h,
                child: _TranslationStrip(
                  ayah: ayahs[_selectedIndex],
                  fontSp: _englishFontSp,
                  surahLabel: l10n.quranSurahLabel,
                  onPlay: _playSelectedAyah,
                  onClose: _clearSelection,
                ),
              ),
            if (showPlayOnlyChip)
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 8.h,
                child: _PlayAyahChip(
                  label:
                      '${l10n.quranSurahLabel} ${ayahs[_selectedIndex].surahNumber}:${ayahs[_selectedIndex].ayahNumber}',
                  onPlay: _playSelectedAyah,
                  onClose: _clearSelection,
                ),
              ),
            if (showAudioBar)
              QuranAudioBar(
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
                  final ms = (_duration.inMilliseconds * value).toInt();
                  setState(() => _position = Duration(milliseconds: ms));
                },
                onSeekEnd: (value) async {
                  _isUserSeeking = false;
                  if (_duration.inMilliseconds <= 0) return;
                  final ms = (_duration.inMilliseconds * value).toInt();
                  await _audio.player.seek(Duration(milliseconds: ms));
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
              ),
          ],
        ),
      ),
    );
  }
}

class _MushafPageContent extends StatelessWidget {
  const _MushafPageContent({
    required this.pageNumber,
    required this.ayahs,
    required this.selectedIndex,
    required this.arabicFontSp,
    required this.arabicFontFamily,
    required this.lineSpacing,
    required this.surahByNumber,
    required this.bottomPadding,
    required this.onAyahTap,
  });

  final int pageNumber;
  final List<AyahRecord> ayahs;
  final int selectedIndex;
  final double arabicFontSp;
  final String arabicFontFamily;
  final double lineSpacing;
  final Map<int, SurahSummary> surahByNumber;
  final double bottomPadding;
  final ValueChanged<int> onAyahTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (ayahs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, bottomPadding),
            child: MushafPageText(
              ayahs: ayahs,
              playingIndex: selectedIndex,
              arabicFontSp: arabicFontSp,
              arabicFontFamily: arabicFontFamily,
              lineSpacing: lineSpacing,
              surahByNumber: surahByNumber,
              onAyahTap: onAyahTap,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            '${l10n.quranPageLabel} $pageNumber',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Translation-only sheet for a selected ayah. Play is explicit via [onPlay]
/// so translation and the audio bar never appear stacked together.
class _TranslationStrip extends StatelessWidget {
  const _TranslationStrip({
    required this.ayah,
    required this.fontSp,
    required this.surahLabel,
    required this.onPlay,
    required this.onClose,
  });

  final AyahRecord ayah;
  final double fontSp;
  final String surahLabel;
  final VoidCallback onPlay;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(14.r),
      color: colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 10.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$surahLabel ${ayah.surahNumber}:${ayah.ayahNumber}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Play',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.play_circle_fill_rounded,
                    color: colorScheme.primary,
                    size: 28.sp,
                  ),
                  onPressed: onPlay,
                ),
                IconButton(
                  tooltip: 'Close',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: onClose,
                ),
              ],
            ),
            Text(
              ayah.englishText,
              style: TextStyle(
                fontSize: fontSp.sp,
                height: 1.4,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when English is off — select still works; play is an explicit action.
class _PlayAyahChip extends StatelessWidget {
  const _PlayAyahChip({
    required this.label,
    required this.onPlay,
    required this.onClose,
  });

  final String label;
  final VoidCallback onPlay;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(14.r),
      color: colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Play',
              icon: Icon(
                Icons.play_circle_fill_rounded,
                color: colorScheme.primary,
                size: 32.sp,
              ),
              onPressed: onPlay,
            ),
            IconButton(
              tooltip: 'Close',
              icon: Icon(
                Icons.close_rounded,
                size: 18.sp,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
