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
import '../reading_engine/quran_audio_controller.dart';
import '../reading_engine/quran_arabic_font.dart';
import '../reading_engine/quran_layout_theme.dart';
import '../reading_engine/quran_reading_color_theme.dart';
import '../reading_engine/quran_repeat_mode.dart';
import '../reading_engine/quran_script.dart';
import '../reading_engine/reading_engine.dart';
import '../reading_engine/reading_mode.dart';
import 'widgets/ayah_card.dart';
import 'widgets/quran_audio_bar.dart';
import 'widgets/quran_reader_theme.dart';
import 'quran_reading_settings_launcher.dart';

/// Juz Mode reading screen (Phase 1). Same reading + audio experience as the
/// Surah screen, but scoped to a Juz's ayah range via [ReadingEngine], with
/// Previous/Next Juz navigation.
class JuzReadingScreen extends StatefulWidget {
  const JuzReadingScreen({
    super.key,
    required this.juzNumber,
    this.surah,
    this.ayah,
  });

  final int juzNumber;

  /// Optional surah/ayah to scroll to immediately (Continue Reading deep
  /// link). If only [ayah] is given, it's assumed to be in the juz's first
  /// surah (e.g. opening straight from the Juz list).
  final int? surah;
  final int? ayah;

  @override
  State<JuzReadingScreen> createState() => _JuzReadingScreenState();
}

class _JuzReadingScreenState extends State<JuzReadingScreen> {
  late final ReadingEngine _engine = ReadingEngine(mode: ReadingMode.juz);
  final QuranAudioController _audio = QuranAudioController();
  final ScrollController _listController = ScrollController();

  bool _showEnglish = true;
  bool _showTransliteration = true;
  QuranLayoutTheme _layoutTheme = QuranLayoutTheme.classic;
  QuranReadingColorTheme _colorTheme = QuranReadingColorTheme.emerald;
  double _arabicFontSp = 20;
  double _englishFontSp = 15;
  double _lineSpacing = 1.8;
  String? _arabicFontFamily = QuranScript.uthmani.fontFamily;
  List<String>? _arabicFontFamilyFallback;
  double _speed = 1.0;
  double _volume = 1.0;
  QuranRepeatMode _repeatMode = QuranRepeatMode.off;
  bool _tajweedEnabled = false;

  int _playingIndex = -1;
  bool _showAudioBar = false;
  bool _isAudioLoading = false;
  bool _isUserSeeking = false;
  bool _startingPlayback = false;
  bool _playbackCompleted = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;

  @override
  void initState() {
    super.initState();
    _engine.addListener(_onEngineChanged);
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
    _engine.removeListener(_onEngineChanged);
    _positionSub?.cancel();
    _durationSub?.cancel();
    _listController.dispose();
    unawaited(_audio.dispose());
    _engine.dispose();
    super.dispose();
  }

  void _onEngineChanged() {
    if (mounted) setState(() {});
  }

  void _onTranslationInstalled() {
    unawaited(_engine.reloadAyahTexts());
  }

  Future<void> _bootstrap() async {
    final results = await Future.wait<Object>([
      StorageService.quranShowEnglish,
      StorageService.quranShowTransliteration,
      StorageService.quranLayoutTheme,
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
      StorageService.quranLineSpacing,
      StorageService.quranPlaybackSpeed,
      StorageService.quranPlaybackVolume,
      StorageService.quranRepeatMode,
      StorageService.quranScript,
      StorageService.quranArabicFont.then((v) => v ?? ''),
      TajweedEntryPoint.isEnabled(),
      StorageService.quranReadingColorTheme,
    ]);
    if (!mounted) return;
    final script = QuranScriptX.fromName(results[9] as String);
    final arabicFont = QuranArabicFont.resolve(
      savedName: results[10] as String,
      script: script,
    );
    setState(() {
      _showEnglish = results[0] as bool;
      _showTransliteration = results[1] as bool;
      _layoutTheme = QuranLayoutTheme.fromName(results[2] as String);
      _arabicFontSp = results[3] as double;
      _englishFontSp = results[4] as double;
      _lineSpacing = results[5] as double;
      _speed = results[6] as double;
      _volume = results[7] as double;
      _repeatMode = QuranRepeatMode.fromName(results[8] as String);
      _arabicFontFamily = arabicFont.fontFamily;
      _arabicFontFamilyFallback = arabicFont.fontFamilyFallback;
      _tajweedEnabled = results[11] as bool;
      _colorTheme = QuranReadingColorTheme.fromName(results[12] as String);
    });

    await _audio.loadPreferences();
    await _engine.openJuz(
      widget.juzNumber,
      surah: widget.surah,
      ayah: widget.ayah,
    );
    if (_engine.ayahs.isNotEmpty) {
      await _audio.setPlaylist(_engine.ayahs);
    }
    _maybeScrollToInitialAyah();
  }

  void _maybeScrollToInitialAyah() {
    final targetAyah = widget.ayah;
    if (targetAyah == null) return;
    final targetSurah =
        widget.surah ??
        (_engine.ayahs.isNotEmpty ? _engine.ayahs.first.surahNumber : null);
    final index = _engine.ayahs.indexWhere(
      (a) => a.surahNumber == targetSurah && a.ayahNumber == targetAyah,
    );
    if (index < 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listController.hasClients) return;
      _listController.animateTo(
        (index * 120).toDouble(),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  bool get _isActivelyPlaying =>
      _showAudioBar &&
      _audio.player.playing &&
      !_playbackCompleted &&
      _audio.player.processingState != ProcessingState.completed;

  void _bindPlayerState() {
    final player = _audio.player;
    player.playbackEventStream.listen((_) {
      if (!mounted) return;
      final state = player.processingState;
      final loading =
          state == ProcessingState.loading ||
          state == ProcessingState.buffering;
      if (_isAudioLoading != loading) setState(() => _isAudioLoading = loading);
      if (state == ProcessingState.completed &&
          _showAudioBar &&
          !_startingPlayback &&
          !_playbackCompleted) {
        unawaited(_onPlaylistCompleted());
      }
    });

    player.currentIndexStream.listen((index) {
      if (!mounted || index == null) return;
      if (_startingPlayback || _playbackCompleted) return;
      if (index < 0 || index >= _engine.ayahs.length) return;
      setState(() => _playingIndex = index);
      final ayah = _engine.ayahs[index];
      _engine.reportAyahVisited(ayah.surahNumber, ayah.ayahNumber);
    });

    player.playerStateStream.listen((_) {
      if (!mounted) return;
      setState(() {});
    });

    _positionSub = player.positionStream.listen((position) {
      if (!mounted || _isUserSeeking || _playbackCompleted) return;
      setState(() => _position = position);
    });
    _durationSub = player.durationStream.listen((duration) {
      if (!mounted) return;
      if (duration == null || duration <= Duration.zero) return;
      setState(() => _duration = duration);
    });
  }

  Future<void> _onPlaylistCompleted() async {
    final stayAt = _engine.ayahs.isEmpty ? -1 : _engine.ayahs.length - 1;
    final player = _audio.player;
    try {
      if (player.playing) {
        await player.pause();
      }
    } catch (_) {}
    if (!mounted || stayAt < 0) return;
    setState(() {
      _playbackCompleted = true;
      _showAudioBar = true;
      _playingIndex = stayAt;
      _isAudioLoading = false;
      if (_duration > Duration.zero) {
        _position = _duration;
      }
    });
  }

  Future<void> _onAyahTap(int index) async {
    if (_engine.ayahs.isEmpty) return;
    _startingPlayback = true;
    _playbackCompleted = false;
    setState(() {
      _playingIndex = index;
      _showAudioBar = true;
      _isAudioLoading = true;
    });
    try {
      await _audio.player.stop();
      await _audio.player.seek(Duration.zero, index: index);
      await _audio.player.play();
    } finally {
      _startingPlayback = false;
    }
    if (!mounted) return;
    setState(() {
      _playingIndex = index;
      _showAudioBar = true;
      _playbackCompleted = false;
    });
    final ayah = _engine.ayahs[index];
    _engine.reportAyahVisited(ayah.surahNumber, ayah.ayahNumber);
  }

  Future<void> _togglePlayPause() async {
    final player = _audio.player;
    if (_playbackCompleted ||
        player.processingState == ProcessingState.completed) {
      final index = _playingIndex >= 0 ? _playingIndex : 0;
      await _onAyahTap(index);
      return;
    }
    if (_isActivelyPlaying) {
      await player.pause();
    } else if (_playingIndex >= 0) {
      await player.play();
    } else if (_engine.ayahs.isNotEmpty) {
      await _onAyahTap(0);
    }
  }

  void _closeAudioBar() {
    _playbackCompleted = false;
    _startingPlayback = false;
    unawaited(_audio.player.stop());
    setState(() {
      _playingIndex = -1;
      _showAudioBar = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
  }

  Future<void> _goToPreviousJuz() async {
    if (!_engine.hasPreviousUnit) return;
    await _engine.goToPreviousUnit();
    await _audio.setPlaylist(_engine.ayahs);
    _closeAudioBar();
  }

  Future<void> _goToNextJuz() async {
    if (!_engine.hasNextUnit) return;
    await _engine.goToNextUnit();
    await _audio.setPlaylist(_engine.ayahs);
    _closeAudioBar();
  }

  Widget _buildJuzAyahCard(
    BuildContext context,
    AppLocalizations l10n,
    List<AyahRecord> ayahs,
    int index,
  ) {
    final ayah = ayahs[index];
    final isNewSurah =
        index == 0 || ayahs[index - 1].surahNumber != ayah.surahNumber;
    final surahLabel = isNewSurah
        ? '${l10n.quranSurahLabel} ${ayah.surahNumber}'
        : null;
    return AyahCard(
      ayah: ayah,
      isCurrent: index == _playingIndex,
      isPlaying: _isActivelyPlaying,
      showEnglish: _showEnglish,
      showTransliteration: _showTransliteration,
      layoutTheme: _layoutTheme,
      arabicFontSp: _arabicFontSp,
      englishFontSp: _englishFontSp,
      lineSpacing: _lineSpacing,
      arabicFontFamily: _arabicFontFamily,
      arabicFontFamilyFallback: _arabicFontFamilyFallback,
      surahLabel: surahLabel,
      style: AyahCardStyle.surahDetail,
      onTap: () => _onAyahTap(index),
      onPracticeTap: _tajweedEnabled
          ? () => TajweedEntryPoint.open(
                context,
                surah: ayah.surahNumber,
                ayah: ayah.ayahNumber,
                arabicText: ayah.arabicText,
                translation:
                    _showEnglish && ayah.englishText.trim().isNotEmpty
                    ? ayah.englishText
                    : null,
              )
          : null,
    );
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
      TajweedEntryPoint.isEnabled(),
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
      _tajweedEnabled = results[9] as bool;
    });
    await _engine.reloadAyahTexts();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ayahs = _engine.ayahs;
    final showAudioBar = _showAudioBar && _playingIndex >= 0 && _playingIndex < ayahs.length;
    final palette = QuranReaderPalette.resolve(
      _colorTheme,
      Theme.of(context).brightness,
    );

    return QuranReaderThemeScope(
      palette: palette,
      child: Scaffold(
      backgroundColor: palette.background,
      appBar: CustomAppBar(
        title: '${l10n.quranJuzLabel} ${_engine.unitNumber}',
        actions: [
          IconButton(
            tooltip: l10n.quranPreviousJuz,
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: _engine.hasPreviousUnit ? _goToPreviousJuz : null,
          ),
          IconButton(
            tooltip: l10n.quranNextJuz,
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: _engine.hasNextUnit ? _goToNextJuz : null,
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
            _engine.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    controller: _listController,
                    padding: EdgeInsets.fromLTRB(
                      16.w,
                      16.h,
                      16.w,
                      16.h + (showAudioBar ? 200.h : 0),
                    ),
                    itemCount: ayahs.length,
                    separatorBuilder: (_, _) => SizedBox(
                      height: _layoutTheme == QuranLayoutTheme.simple
                          ? 0
                          : 10.h,
                    ),
                    itemBuilder: (context, index) {
                      return _buildJuzAyahCard(context, l10n, ayahs, index);
                    },
                  ),
            if (showAudioBar)
              QuranAudioBar(
                label:
                    '${l10n.quranSurahLabel} ${ayahs[_playingIndex].surahNumber}:${ayahs[_playingIndex].ayahNumber}',
                position: _position,
                duration: _duration,
                isPlaying: _isActivelyPlaying,
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
    ),
    );
  }
}
