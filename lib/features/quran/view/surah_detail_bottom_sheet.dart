import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/services/quran_translation_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../tajweed/tajweed_entry_point.dart';
import '../data/quran_local_repository.dart';
import '../reading_engine/quran_layout_theme.dart';
import '../reading_engine/quran_recitation.dart';
import '../reading_engine/quran_repeat_mode.dart';
import '../reading_engine/quran_script.dart';
import '../reading_engine/reading_engine.dart';
import '../reading_engine/reading_mode.dart';
import 'widgets/ayah_card.dart';
import 'widgets/quran_audio_bar.dart';
import 'quran_reading_settings_launcher.dart';

class SurahDetailBottomSheet extends StatefulWidget {
  const SurahDetailBottomSheet({super.key, required this.surah, this.initialAyah});

  final SurahSummary surah;

  /// Optional ayah to scroll to on open (Continue Reading deep link).
  final int? initialAyah;

  @override
  State<SurahDetailBottomSheet> createState() => _SurahDetailBottomSheetState();
}

class _SurahDetailBottomSheetState extends State<SurahDetailBottomSheet> {
  /// Tracks Continue Reading position + Reading Progress for Surah Mode.
  /// Rendering/audio below are untouched from the original implementation;
  /// this only adds the Phase 1 persistence side effects.
  late final ReadingEngine _engine = ReadingEngine(mode: ReadingMode.surah);

  final AudioPlayer _player = AudioPlayer();
  List<AyahRecord> _ayahs = const <AyahRecord>[];
  bool _loadingAyahs = true;
  bool _showEnglish = true;
  bool _showTransliteration = true;
  QuranLayoutTheme _layoutTheme = QuranLayoutTheme.classic;
  double _arabicFontSp = 20;
  double _englishFontSp = 15;
  double _lineSpacing = 1.8;
  String _arabicFontFamily = QuranScript.uthmani.fontFamily;
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
  bool _showCompactHeader = false;
  bool _suppressNextAutoScroll = false;
  bool _tajweedEnabled = false;

  @override
  void initState() {
    super.initState();
    _listController.addListener(_handleListScroll);
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
    _listController.removeListener(_handleListScroll);
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
      TajweedEntryPoint.isEnabled(),
    ]);
    if (!mounted) return;

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
      _arabicFontFamily =
          QuranScriptX.fromName(results[10] as String).fontFamily;
      _tajweedEnabled = results[11] as bool;
      _loadingAyahs = false;
    });

    if (_ayahs.isNotEmpty) {
      await _preparePlayer();
      await _player.setSpeed(_playbackSpeed);
      await _player.setVolume(_playbackVolume);
      await _applyRepeatMode(_repeatMode);
      _maybeScrollToInitialAyah();
    }
  }

  void _maybeScrollToInitialAyah() {
    final targetAyah = widget.initialAyah;
    if (targetAyah == null) return;
    final index = _ayahs.indexWhere((a) => a.ayahNumber == targetAyah);
    if (index < 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToAyah(index));
    _engine.reportAyahVisited(widget.surah.number, targetAyah);
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
      setState(() {
        _playingAyahIndex = index;
      });
      final ayah = _ayahs[index];
      _engine.reportAyahVisited(ayah.surahNumber, ayah.ayahNumber);
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
          .map((ayah) {
            return AudioSource.uri(
              Uri.parse(
                QuranRecitation.audioUrl(ayah.surahNumber, ayah.ayahNumber),
              ),
            );
          })
          .toList(growable: false),
    );
    await _player.setAudioSource(source, preload: true);
  }

  Future<void> _onAyahTap(int position) async {
    if (_ayahs.isEmpty) return;
    _suppressNextAutoScroll = true;
    setState(() {
      _playingAyahIndex = position;
      _isAudioLoading = true;
    });
    await _player.seek(Duration.zero, index: position);
    await _player.play();
    final ayah = _ayahs[position];
    _engine.reportAyahVisited(ayah.surahNumber, ayah.ayahNumber);
  }

  /// Better Navigation (Phase 1, item 6): move to the previous/next ayah
  /// within this surah without leaving the screen.
  Future<void> _onPreviousAyahTap() async {
    if (_playingAyahIndex > 0) {
      await _onAyahTap(_playingAyahIndex - 1);
    } else if (_ayahs.isNotEmpty) {
      await _onAyahTap(0);
    }
  }

  Future<void> _onNextAyahTap() async {
    if (_playingAyahIndex >= 0 && _playingAyahIndex + 1 < _ayahs.length) {
      await _onAyahTap(_playingAyahIndex + 1);
    } else if (_ayahs.isNotEmpty) {
      await _onAyahTap(0);
    }
  }

  Future<void> _onPlayFullSurahTap() async {
    if (_ayahs.isEmpty) return;
    if (_player.playing) {
      await _player.pause();
      return;
    }

    if (_playingAyahIndex >= 0 && _playingAyahIndex < _ayahs.length) {
      await _player.play();
      setState(() => _showAudioBar = true);
      return;
    }

    setState(() {
      _playingAyahIndex = 0;
      _showAudioBar = true;
      _isAudioLoading = true;
    });
    await _player.seek(Duration.zero, index: 0);
    await _player.play();
    _scrollToAyah(0);
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
    ]);
    if (!mounted) return;
    setState(() {
      _showEnglish = results[0] as bool;
      _showTransliteration = results[1] as bool;
      _layoutTheme = QuranLayoutTheme.fromName(results[2] as String);
      _arabicFontSp = results[3] as double;
      _englishFontSp = results[4] as double;
      _lineSpacing = results[5] as double;
      _arabicFontFamily =
          QuranScriptX.fromName(results[6] as String).fontFamily;
    });
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
    // Trigger list auto-follow similar to native implementation.
    if (!_listController.hasClients) return;
    _listController.animateTo(
      (index * 120).toDouble(),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  final ScrollController _listController = ScrollController();

  void _handleListScroll() {
    if (!_listController.hasClients) return;
    final shouldCompact = _listController.offset > 8;
    if (shouldCompact == _showCompactHeader) return;
    setState(() => _showCompactHeader = shouldCompact);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = _player.playing;
    final currentAyah =
        (_playingAyahIndex >= 0 && _playingAyahIndex < _ayahs.length)
        ? _ayahs[_playingAyahIndex]
        : null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: widget.surah.name,
        onBack: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            tooltip: l10n.quranPreviousAyah,
            icon: const Icon(Icons.skip_previous_rounded),
            onPressed: _ayahs.isEmpty ? null : _onPreviousAyahTap,
          ),
          IconButton(
            tooltip: l10n.quranNextAyah,
            icon: const Icon(Icons.skip_next_rounded),
            onPressed: _ayahs.isEmpty ? null : _onNextAyahTap,
          ),
          QuranReadingSettingsLauncher.appBarAction(
            context,
            onReturn: () => unawaited(_reloadDisplayPrefs()),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Material(
          type: MaterialType.transparency,
          child: Builder(
            builder: (context) {
              final showAudioBar = _showAudioBar && currentAyah != null;
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ColoredBox(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: _showCompactHeader
                                  ? Padding(
                                      key: const ValueKey('compact_header'),
                                      padding: EdgeInsets.fromLTRB(
                                        16.w,
                                        0,
                                        16.w,
                                        12.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.surah.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          FilledButton(
                                            onPressed: _onPlayFullSurahTap,
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  colorScheme.primary,
                                              foregroundColor:
                                                  colorScheme.onPrimary,
                                              minimumSize: Size(44.w, 42.h),
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            child: Icon(
                                              isPlaying && _showAudioBar && currentAyah != null
                                                  ? Icons.pause
                                                  : Icons.play_arrow_rounded,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      key: const ValueKey('full_header'),
                                      padding: EdgeInsets.fromLTRB(
                                        24.w,
                                        6.h,
                                        24.w,
                                        16.h,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.surah.arabicName,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 30.sp,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            widget.surah.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: colorScheme.onSurface,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Wrap(
                                            alignment: WrapAlignment.center,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            spacing: 10.w,
                                            runSpacing: 6.h,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .format_align_left_rounded,
                                                    size: 18.sp,
                                                    color: colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    '${widget.surah.verses} ${l10n.quranVersesLabel}',
                                                    style: TextStyle(
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.nightlight_round,
                                                    size: 18.sp,
                                                    color: colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    widget.surah.revelationType,
                                                    style: TextStyle(
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14.h),
                                          SizedBox(
                                            width: double.infinity,
                                            child: FilledButton.icon(
                                              onPressed: _onPlayFullSurahTap,
                                              icon: Icon(
                                                isPlaying && showAudioBar
                                                    ? Icons.pause
                                                    : Icons.play_arrow_rounded,
                                              ),
                                              label: Text(
                                                isPlaying && showAudioBar
                                                    ? l10n.quranPause
                                                    : l10n.quranPlaySurah,
                                              ),
                                              style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    colorScheme.primary,
                                                foregroundColor:
                                                    colorScheme.onPrimary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            Divider(
                              height: 1,
                              color: colorScheme.outlineVariant,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _loadingAyahs
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.separated(
                                controller: _listController,
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  16.w,
                                  16.w,
                                  16.w + (showAudioBar ? 200.h : 0),
                                ),
                                itemCount: _ayahs.length,
                                separatorBuilder: (_, _) =>
                                    SizedBox(height: 10.h),
                                itemBuilder: (context, index) {
                                  final ayah = _ayahs[index];
                                  final isCurrent = index == _playingAyahIndex;
                                  return AyahCard(
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
                                    onTap: () => _onAyahTap(index),
                                    onPracticeTap: _tajweedEnabled
                                        ? () => TajweedEntryPoint.open(
                                              context,
                                              surah: ayah.surahNumber,
                                              ayah: ayah.ayahNumber,
                                              arabicText: ayah.arabicText,
                                              surahName: widget.surah.name,
                                              translation:
                                                  _showEnglish &&
                                                      ayah.englishText
                                                          .trim()
                                                          .isNotEmpty
                                                  ? ayah.englishText
                                                  : null,
                                            )
                                        : null,
                                  );
                                },
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
                      onSpeedChanged: (value) => unawaited(
                        _setPlaybackSpeed(value),
                      ),
                      onVolumeChanged: (value) => unawaited(
                        _setPlaybackVolume(value),
                      ),
                      onRepeatModeChanged: (value) => unawaited(
                        _setRepeatMode(value),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
