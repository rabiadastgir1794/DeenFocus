import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/services/quran_bookmark_service.dart';
import '../../../core/services/quran_translation_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../tajweed/tajweed_entry_point.dart';
import '../data/quran_local_repository.dart';
import '../reading_engine/quran_layout_theme.dart';
import '../reading_engine/quran_reading_color_theme.dart';
import '../reading_engine/quran_recitation.dart';
import '../reading_engine/quran_repeat_mode.dart';
import '../reading_engine/quran_arabic_font.dart';
import '../reading_engine/quran_script.dart';
import '../reading_engine/reading_engine.dart';
import '../reading_engine/reading_mode.dart';
import 'widgets/ayah_card.dart';
import 'widgets/quran_audio_bar.dart';
import 'widgets/quran_reader_theme.dart';
import 'widgets/surah_header_card.dart';
import 'widgets/tajweed_legend_row.dart';
import 'quran_reading_settings_launcher.dart';

class SurahDetailBottomSheet extends StatefulWidget {
  const SurahDetailBottomSheet({super.key, required this.surah, this.initialAyah});

  final SurahSummary surah;
  final int? initialAyah;

  @override
  State<SurahDetailBottomSheet> createState() => _SurahDetailBottomSheetState();
}

class _SurahDetailBottomSheetState extends State<SurahDetailBottomSheet> {
  late final ReadingEngine _engine = ReadingEngine(mode: ReadingMode.surah);

  final AudioPlayer _player = AudioPlayer();
  List<AyahRecord> _ayahs = const <AyahRecord>[];
  bool _loadingAyahs = true;
  bool _showEnglish = true;
  bool _showTransliteration = true;
  QuranLayoutTheme _layoutTheme = QuranLayoutTheme.classic;
  QuranReadingColorTheme _colorTheme = QuranReadingColorTheme.emerald;
  double _arabicFontSp = 20;
  double _englishFontSp = 15;
  double _lineSpacing = 1.8;
  String? _arabicFontFamily = QuranScript.uthmani.fontFamily;
  List<String>? _arabicFontFamilyFallback;
  double _playbackSpeed = 1.0;
  double _playbackVolume = 1.0;
  QuranRepeatMode _repeatMode = QuranRepeatMode.off;
  int _playingAyahIndex = -1;
  bool _showAudioBar = false;
  bool _isAudioLoading = false;
  bool _isUserSeeking = false;
  Duration _currentPosition = Duration.zero;
  Duration _currentDuration = Duration.zero;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  bool _suppressNextAutoScroll = false;
  bool _tajweedEnabled = false;
  Set<int> _bookmarkedAyahs = const <int>{};

  final ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    QuranTranslationService.installationRevision.addListener(
      _onTranslationInstalled,
    );
    unawaited(_bootstrap());
    _bindPlayerState();
  }

  @override
  void dispose() {
    QuranTranslationService.installationRevision.removeListener(
      _onTranslationInstalled,
    );
    _positionSub?.cancel();
    _durationSub?.cancel();
    _listController.dispose();
    _player.dispose();
    _engine.dispose();
    super.dispose();
  }

  void _onTranslationInstalled() {
    unawaited(_reloadAyahTexts());
  }

  Future<void> _reloadAyahTexts() async {
    if (_loadingAyahs || !mounted) return;
    final ayahs = await QuranLocalRepository.instance.getAyahsBySurah(
      widget.surah.number,
    );
    if (!mounted) return;
    setState(() => _ayahs = ayahs);
  }

  Future<void> _bootstrap() async {
    final results = await Future.wait<Object>([
      QuranLocalRepository.instance.getAyahsBySurah(widget.surah.number),
      StorageService.quranShowEnglish,
      StorageService.quranShowTransliteration,
      StorageService.quranLayoutTheme,
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
      StorageService.quranPlaybackSpeed,
      StorageService.quranPlaybackVolume,
      StorageService.quranRepeatMode,
      StorageService.quranLineSpacing,
      StorageService.quranScript,
      StorageService.quranArabicFont.then((v) => v ?? ''),
      TajweedEntryPoint.isEnabled(),
      QuranBookmarkService.list(),
      StorageService.quranReadingColorTheme,
    ]);
    if (!mounted) return;

    final bookmarks = results[13] as List<QuranBookmark>;
    final bookmarkedAyahs = bookmarks
        .where(
          (b) =>
              b.kind == QuranBookmarkKind.ayah &&
              b.surah == widget.surah.number &&
              b.ayah != null,
        )
        .map((b) => b.ayah!)
        .toSet();

    final script = QuranScriptX.fromName(results[10] as String);
    final arabicFont = QuranArabicFont.resolve(
      savedName: results[11] as String,
      script: script,
    );

    setState(() {
      _ayahs = results[0] as List<AyahRecord>;
      _showEnglish = results[1] as bool;
      _showTransliteration = results[2] as bool;
      _layoutTheme = QuranLayoutTheme.fromName(results[3] as String);
      _arabicFontSp = results[4] as double;
      _englishFontSp = results[5] as double;
      _playbackSpeed = results[6] as double;
      _playbackVolume = results[7] as double;
      _repeatMode = QuranRepeatMode.fromName(results[8] as String);
      _lineSpacing = results[9] as double;
      _arabicFontFamily = arabicFont.fontFamily;
      _arabicFontFamilyFallback = arabicFont.fontFamilyFallback;
      _tajweedEnabled = results[12] as bool;
      _bookmarkedAyahs = bookmarkedAyahs;
      _colorTheme = QuranReadingColorTheme.fromName(results[14] as String);
      _loadingAyahs = false;
    });

    if (_ayahs.isNotEmpty) {
      await _engine.openSurah(
        widget.surah.number,
        ayah: widget.initialAyah ?? 1,
      );
      await _preparePlayer();
      await _player.setSpeed(_playbackSpeed);
      await _player.setVolume(_playbackVolume);
      await _applyRepeatMode(_repeatMode);
      _maybeScrollToInitialAyah();
    }
  }

  Future<void> _leaveScreen() async {
    await _engine.flush();
    if (mounted) Navigator.of(context).pop();
  }

  Widget _buildAyahCard(int index) {
    final ayah = _ayahs[index];
    final isCurrent = index == _playingAyahIndex;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: AyahCard(
        ayah: ayah,
        isCurrent: isCurrent,
        isPlaying: _player.playing,
        showEnglish: _showEnglish,
        showTransliteration: _showTransliteration,
        layoutTheme: _layoutTheme,
        arabicFontSp: _arabicFontSp,
        englishFontSp: _englishFontSp,
        lineSpacing: _lineSpacing,
        arabicFontFamily: _arabicFontFamily,
        arabicFontFamilyFallback: _arabicFontFamilyFallback,
        style: AyahCardStyle.surahDetail,
        onTap: () => unawaited(_onAyahTap(index)),
        isBookmarked: _bookmarkedAyahs.contains(ayah.ayahNumber),
        onBookmarkTap: () => unawaited(_toggleBookmarkAyah(ayah)),
        onPracticeTap: _tajweedEnabled
            ? () => TajweedEntryPoint.open(
                  context,
                  surah: ayah.surahNumber,
                  ayah: ayah.ayahNumber,
                  arabicText: ayah.arabicText,
                  surahName: widget.surah.name,
                  translation:
                      _showEnglish && ayah.englishText.trim().isNotEmpty
                      ? ayah.englishText
                      : null,
                )
            : null,
      ),
    );
  }

  void _maybeScrollToInitialAyah() {
    final targetAyah = widget.initialAyah;
    if (targetAyah == null) return;
    final index = _ayahs.indexWhere((a) => a.ayahNumber == targetAyah);
    if (index < 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToAyah(index));
  }

  Future<void> _applyRepeatMode(QuranRepeatMode mode) async {
    switch (mode) {
      case QuranRepeatMode.off:
        await _player.setLoopMode(LoopMode.off);
      case QuranRepeatMode.ayah:
        await _player.setLoopMode(LoopMode.one);
      case QuranRepeatMode.surah:
        await _player.setLoopMode(LoopMode.all);
    }
  }

  Future<void> _setPlaybackSpeed(double value) async {
    setState(() => _playbackSpeed = value);
    await _player.setSpeed(value);
    await StorageService.setQuranPlaybackSpeed(value);
  }

  Future<void> _setPlaybackVolume(double value) async {
    setState(() => _playbackVolume = value);
    await _player.setVolume(value);
    await StorageService.setQuranPlaybackVolume(value);
  }

  Future<void> _setRepeatMode(QuranRepeatMode mode) async {
    setState(() => _repeatMode = mode);
    await _applyRepeatMode(mode);
    await StorageService.setQuranRepeatMode(mode.name);
  }

  void _bindPlayerState() {
    _player.playbackEventStream.listen((_) {
      if (!mounted) return;
      final processingState = _player.processingState;
      final isLoading =
          processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering;
      if (_isAudioLoading != isLoading) {
        setState(() => _isAudioLoading = isLoading);
      }

      if (processingState == ProcessingState.completed) {
        _hideAudioBarOnComplete();
      }
    });

    _player.currentIndexStream.listen((index) {
      if (!mounted || index == null) return;
      if (index < 0 || index >= _ayahs.length) return;
      setState(() => _playingAyahIndex = index);
      final ayah = _ayahs[index];
      _engine.reportAyahVisited(ayah.surahNumber, ayah.ayahNumber);
      if (_showAudioBar && _player.playing) {
        unawaited(
          StorageService.setQuranLastListened(
            surahNumber: widget.surah.number,
            ayahNumber: ayah.ayahNumber,
            surahName: widget.surah.name,
          ),
        );
      }
      if (_suppressNextAutoScroll) {
        _suppressNextAutoScroll = false;
        return;
      }
      _scrollToAyah(index);
    });

    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      if (state.playing && !_showAudioBar) {
        setState(() => _showAudioBar = true);
      }
      setState(() {});
    });

    _positionSub = _player.positionStream.listen((position) {
      if (!mounted || _isUserSeeking) return;
      setState(() => _currentPosition = position);
    });
    _durationSub = _player.durationStream.listen((duration) {
      if (!mounted) return;
      setState(() => _currentDuration = duration ?? Duration.zero);
    });
  }

  Future<void> _preparePlayer() async {
    final source = ConcatenatingAudioSource(
      children: _ayahs
          .map(
            (ayah) => AudioSource.uri(
              Uri.parse(
                QuranRecitation.audioUrl(ayah.surahNumber, ayah.ayahNumber),
              ),
            ),
          )
          .toList(growable: false),
    );
    await _player.setAudioSource(source, preload: true);
  }

  Future<void> _onAyahTap(int position) async {
    if (_ayahs.isEmpty) return;
    _suppressNextAutoScroll = true;
    setState(() {
      _playingAyahIndex = position;
      _showAudioBar = true;
      _isAudioLoading = true;
    });
    await _player.seek(Duration.zero, index: position);
    await _player.play();
    unawaited(
      StorageService.setQuranLastListened(
        surahNumber: widget.surah.number,
        ayahNumber: _ayahs[position].ayahNumber,
        surahName: widget.surah.name,
      ),
    );
    final ayah = _ayahs[position];
    _engine.reportAyahVisited(ayah.surahNumber, ayah.ayahNumber);
  }

  Future<void> _togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else if (_playingAyahIndex >= 0) {
      await _player.play();
    }
  }

  Future<void> _closeAudioBar() async {
    await _player.stop();
    setState(() {
      _playingAyahIndex = -1;
      _showAudioBar = false;
      _currentPosition = Duration.zero;
      _currentDuration = Duration.zero;
    });
  }

  Future<void> _reloadDisplayPrefs() async {
    final results = await Future.wait<Object>([
      StorageService.quranShowEnglish,
      StorageService.quranShowTransliteration,
      StorageService.quranLayoutTheme,
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
      StorageService.quranLineSpacing,
      StorageService.quranScript,
      StorageService.quranArabicFont.then((v) => v ?? ''),
      StorageService.quranReadingColorTheme,
    ]);
    if (!mounted) return;
    final script = QuranScriptX.fromName(results[6] as String);
    final arabicFont = QuranArabicFont.resolve(
      savedName: results[7] as String,
      script: script,
    );
    setState(() {
      _showEnglish = results[0] as bool;
      _showTransliteration = results[1] as bool;
      _layoutTheme = QuranLayoutTheme.fromName(results[2] as String);
      _arabicFontSp = results[3] as double;
      _englishFontSp = results[4] as double;
      _lineSpacing = results[5] as double;
      _arabicFontFamily = arabicFont.fontFamily;
      _arabicFontFamilyFallback = arabicFont.fontFamilyFallback;
      _colorTheme = QuranReadingColorTheme.fromName(results[8] as String);
    });
    // Re-apply script + translation overlays so settings take effect immediately.
    await _reloadAyahTexts();
  }

  void _hideAudioBarOnComplete() {
    setState(() {
      _showAudioBar = false;
      _playingAyahIndex = -1;
      _currentPosition = Duration.zero;
      _currentDuration = Duration.zero;
    });
  }

  int get _sliderDurationMs {
    final max = _currentDuration.inMilliseconds;
    return max <= 0 ? 0 : max;
  }

  void _scrollToAyah(int index) {
    if (!_listController.hasClients) return;
    _listController.animateTo(
      (index * 220).toDouble(),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  Future<void> _toggleBookmarkAyah(AyahRecord ayah) async {
    final id = QuranBookmarkService.idFor(
      kind: QuranBookmarkKind.ayah,
      surah: ayah.surahNumber,
      ayah: ayah.ayahNumber,
    );
    final wasBookmarked = _bookmarkedAyahs.contains(ayah.ayahNumber);

    if (wasBookmarked) {
      await QuranBookmarkService.remove(id);
    } else {
      await QuranBookmarkService.add(
        QuranBookmark(
          id: id,
          kind: QuranBookmarkKind.ayah,
          label: '${widget.surah.name} ${ayah.surahNumber}:${ayah.ayahNumber}',
          surah: ayah.surahNumber,
          ayah: ayah.ayahNumber,
          createdAtMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      final next = Set<int>.from(_bookmarkedAyahs);
      if (wasBookmarked) {
        next.remove(ayah.ayahNumber);
      } else {
        next.add(ayah.ayahNumber);
      }
      _bookmarkedAyahs = next;
    });

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasBookmarked ? l10n.quranBookmarkRemoved : l10n.quranBookmarkSaved,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentAyah =
        (_playingAyahIndex >= 0 && _playingAyahIndex < _ayahs.length)
        ? _ayahs[_playingAyahIndex]
        : null;
    final showAudioBar = _showAudioBar && currentAyah != null;
    final subtitle =
        '${widget.surah.name} • ${widget.surah.verses} ${l10n.quranVersesLabel}';
    final palette = QuranReaderPalette.resolve(
      _colorTheme,
      Theme.of(context).brightness,
    );

    return QuranReaderThemeScope(
      palette: palette,
      child: PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _engine.flush();
        if (mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
      backgroundColor: palette.background,
      appBar: CustomAppBar(
        title: widget.surah.name,
        subtitle: subtitle,
        onBack: () => unawaited(_leaveScreen()),
        actions: [
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _loadingAyahs
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          controller: _listController,
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            12.h,
                            16.w,
                            16.h + (showAudioBar ? 200.h : 0),
                          ),
                          children: [
                            SurahHeaderCard(
                              surah: widget.surah,
                              layoutTheme: _layoutTheme,
                            ),
                            SizedBox(height: 12.h),
                            const TajweedLegendRow(),
                            SizedBox(height: 14.h),
                            ...List.generate(_ayahs.length, (index) {
                              return _buildAyahCard(index);
                            }),
                          ],
                        ),
                ),
              ],
            ),
            if (showAudioBar)
              QuranAudioBar(
                label:
                    '${l10n.quranSurahLabel} ${currentAyah.surahNumber}:${currentAyah.ayahNumber}',
                position: _currentPosition,
                duration: _currentDuration,
                isPlaying: _player.playing,
                isLoading: _isAudioLoading,
                speed: _playbackSpeed,
                volume: _playbackVolume,
                repeatMode: _repeatMode,
                onTogglePlayPause: _togglePlayPause,
                onClose: () => unawaited(_closeAudioBar()),
                onSeekStart: () => _isUserSeeking = true,
                onSeekChanged: (value) {
                  if (_sliderDurationMs <= 0) return;
                  final ms = (_sliderDurationMs * value).toInt();
                  setState(
                    () => _currentPosition = Duration(milliseconds: ms),
                  );
                },
                onSeekEnd: (value) async {
                  _isUserSeeking = false;
                  if (_sliderDurationMs <= 0) return;
                  final ms = (_sliderDurationMs * value).toInt();
                  await _player.seek(Duration(milliseconds: ms));
                },
                onSpeedChanged: (value) => unawaited(_setPlaybackSpeed(value)),
                onVolumeChanged: (value) => unawaited(_setPlaybackVolume(value)),
                onRepeatModeChanged: (value) => unawaited(_setRepeatMode(value)),
              ),
          ],
        ),
      ),
      ),
    ),
    );
  }
}
