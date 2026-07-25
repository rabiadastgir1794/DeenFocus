import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../data/quran_local_repository.dart';

class SurahDetailBottomSheet extends StatefulWidget {
  const SurahDetailBottomSheet({super.key, required this.surah});

  final SurahSummary surah;

  @override
  State<SurahDetailBottomSheet> createState() => _SurahDetailBottomSheetState();
}

class _SurahDetailBottomSheetState extends State<SurahDetailBottomSheet> {
  static const int _reciterId = 1;
  static const String _audioBaseUrl =
      'https://the-quran-project.github.io/Quran-Audio/Data';

  AudioPlayer _player = AudioPlayer();
  List<AyahRecord> _ayahs = const <AyahRecord>[];
  List<GlobalKey> _ayahKeys = const <GlobalKey>[];
  bool _loadingAyahs = true;
  bool _showEnglish = true;
  double _arabicFontSp = 20;
  double _englishFontSp = 15;
  int _playingAyahIndex = -1;
  bool _showAudioBar = false;
  bool _isAudioLoading = false;
  bool _isUserSeeking = false;
  Duration _currentPosition = Duration.zero;
  Duration _currentDuration = Duration.zero;
  StreamSubscription<dynamic>? _playbackEventSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  bool _showCompactHeader = false;
  // Guard against the completed event firing more than once before we advance.
  bool _isAdvancingToNext = false;

  @override
  void initState() {
    super.initState();
    _listController.addListener(_handleListScroll);
    _bootstrap();
    _bindPlayerState();
  }

  @override
  void dispose() {
    _listController.removeListener(_handleListScroll);
    _playbackEventSub?.cancel();
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _listController.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final results = await Future.wait<Object>([
      QuranLocalRepository.instance.getAyahsBySurah(widget.surah.number),
      StorageService.quranShowEnglish,
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
    ]);
    if (!mounted) return;

    final ayahs = results[0] as List<AyahRecord>;
    setState(() {
      _ayahs = ayahs;
      _ayahKeys = List.generate(ayahs.length, (_) => GlobalKey());
      _showEnglish = results[1] as bool;
      _arabicFontSp = results[2] as double;
      _englishFontSp = results[3] as double;
      _loadingAyahs = false;
    });
    // Player is loaded on demand — no upfront source preparation needed.
  }

  void _bindPlayerState() {
    _playbackEventSub = _player.playbackEventStream.listen((_) async {
      if (!mounted) return;
      final processingState = _player.processingState;

      final isLoading = processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering;
      if (_isAudioLoading != isLoading) {
        setState(() => _isAudioLoading = isLoading);
      }

      // Single-file playback: when current ayah finishes, advance manually.
      if (processingState == ProcessingState.completed && !_isAdvancingToNext) {
        _isAdvancingToNext = true;
        final next = _playingAyahIndex + 1;
        try {
          if (_showAudioBar && next < _ayahs.length) {
            await _loadAndPlayAyah(next);
          } else {
            _hideAudioBarOnComplete();
          }
        } finally {
          _isAdvancingToNext = false;
        }
      }
    });

    _playerStateSub = _player.playerStateStream.listen((state) {
      if (!mounted) return;
      if (state.playing && !_showAudioBar) {
        setState(() => _showAudioBar = true);
      } else {
        setState(() {});
      }
    });

    _positionSub = _player.positionStream.listen((position) {
      if (!mounted || _isUserSeeking) return;
      setState(() {
        _currentPosition = position;
        final dur = _player.duration;
        if (dur != null) _currentDuration = dur;
      });
    });

    _durationSub = _player.durationStream.listen((duration) {
      if (!mounted) return;
      setState(() => _currentDuration = duration ?? Duration.zero);
    });
  }

  // Dispose the current player and create a fresh one with new subscriptions.
  // Called before every ayah load to avoid ExoPlayer's completed-state bug on Android.
  Future<void> _reinitPlayer() async {
    _playbackEventSub?.cancel();
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playbackEventSub = null;
    _playerStateSub = null;
    _positionSub = null;
    _durationSub = null;
    try { await _player.stop(); } catch (_) {}
    await _player.dispose();
    _player = AudioPlayer();
    _bindPlayerState();
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // Loads a single ayah MP3 and plays it. Updates highlight + scroll.
  Future<void> _loadAndPlayAyah(int index, {bool suppressScroll = false}) async {
    if (index < 0 || index >= _ayahs.length) return;
    final ayah = _ayahs[index];

    // Always reinit the player so setAudioSource starts from a clean idle state.
    // On Android, calling setAudioSource on a completed ExoPlayer releases it
    // without reinitialising, causing silent failure.
    await _reinitPlayer();
    if (!mounted) return;

    final hasInternet = await _hasInternetConnection();
    if (!mounted) return;
    if (!hasInternet) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.quranAudioNoInternet)),
      );
      return;
    }

    setState(() {
      _playingAyahIndex = index;
      _isAudioLoading = true;
      _showAudioBar = true;
      _currentPosition = Duration.zero;
      _currentDuration = Duration.zero;
    });
    if (!suppressScroll) _scrollToAyah(index);
    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(_getAudioUrl(ayah.surahNumber, ayah.ayahNumber))),
      ).timeout(const Duration(seconds: 10));
      if (!mounted) return;
      // Do NOT await play() — just_audio's play() Future completes only when
      // the track ends. Awaiting it would keep _isAdvancingToNext=true for the
      // entire track, causing the completed event to be silently skipped.
      unawaited(_player.play());
    } on TimeoutException {
      if (mounted) {
        setState(() => _isAudioLoading = false);
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.quranAudioTimeout)),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isAudioLoading = false);
    }
  }

  String _getAudioUrl(int surahNumber, int ayahNumber) {
    return '$_audioBaseUrl/$_reciterId/${surahNumber}_$ayahNumber.mp3';
  }

  String _formatTime(Duration value) {
    final totalSeconds = value.inSeconds.clamp(0, 999999);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _onAyahTap(int position) async {
    if (_ayahs.isEmpty) return;
    // Load and play the tapped ayah without auto-scrolling (user already sees it).
    await _loadAndPlayAyah(position, suppressScroll: true);
  }

  Future<void> _onPlayFullSurahTap() async {
    if (_ayahs.isEmpty) return;
    if (_player.playing) {
      await _player.pause();
      return;
    }
    // Resume if already loaded at a valid ayah.
    if (_playingAyahIndex >= 0 && _playingAyahIndex < _ayahs.length &&
        _player.processingState != ProcessingState.idle) {
      await _player.play();
      setState(() => _showAudioBar = true);
      return;
    }
    // Start from the beginning.
    await _loadAndPlayAyah(0);
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

  Future<void> _toggleShowEnglish(bool value) async {
    await StorageService.setQuranShowEnglish(value);
    if (!mounted) return;
    setState(() => _showEnglish = value);
  }

  Future<void> _increaseFont() async {
    final arabic = (_arabicFontSp + 1).clamp(16, 32).toDouble();
    final english = (_englishFontSp + 1).clamp(12, 24).toDouble();
    await StorageService.setQuranArabicFontSp(arabic);
    await StorageService.setQuranEnglishFontSp(english);
    if (!mounted) return;
    setState(() {
      _arabicFontSp = arabic;
      _englishFontSp = english;
    });
  }

  Future<void> _decreaseFont() async {
    final arabic = (_arabicFontSp - 1).clamp(16, 32).toDouble();
    final english = (_englishFontSp - 1).clamp(12, 24).toDouble();
    await StorageService.setQuranArabicFontSp(arabic);
    await StorageService.setQuranEnglishFontSp(english);
    if (!mounted) return;
    setState(() {
      _arabicFontSp = arabic;
      _englishFontSp = english;
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

  double get _sliderProgress {
    if (_sliderDurationMs <= 0) return 0;
    return (_currentPosition.inMilliseconds / _sliderDurationMs).clamp(0, 1);
  }

  void _scrollToAyah(int index) {
    if (index < 0 || index >= _ayahKeys.length) return;
    final ctx = _ayahKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.25,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    } else if (_listController.hasClients) {
      final estimated = (index * 220.0)
          .clamp(0.0, _listController.position.maxScrollExtent);
      _listController.animateTo(
        estimated,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
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
          PopupMenuButton<_TextOption>(
            tooltip: l10n.quranTextOptions,
            onSelected: (option) {
              switch (option) {
                case _TextOption.englishArabic:
                  _toggleShowEnglish(true);
                case _TextOption.arabicOnly:
                  _toggleShowEnglish(false);
                case _TextOption.increaseFont:
                  _increaseFont();
                case _TextOption.decreaseFont:
                  _decreaseFont();
              }
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem<_TextOption>(
                value: _TextOption.englishArabic,
                checked: _showEnglish,
                child: Text(l10n.quranEnglishAndArabic),
              ),
              CheckedPopupMenuItem<_TextOption>(
                value: _TextOption.arabicOnly,
                checked: !_showEnglish,
                child: Text(l10n.quranArabicOnly),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<_TextOption>(
                value: _TextOption.increaseFont,
                child: Text(l10n.quranIncreaseFont),
              ),
              PopupMenuItem<_TextOption>(
                value: _TextOption.decreaseFont,
                child: Text(l10n.quranDecreaseFont),
              ),
            ],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Text(
                'A A',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
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
                                cacheExtent: 800,
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
                                  return InkWell(
                                    key: _ayahKeys[index],
                                    borderRadius: BorderRadius.circular(16.r),
                                    onTap: () => _onAyahTap(index),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        border: Border.all(
                                          color: isCurrent
                                              ? colorScheme.primary.withValues(
                                                  alpha: 0.5,
                                                )
                                              : colorScheme.outlineVariant
                                                    .withValues(alpha: 0.4),
                                        ),
                                        color: isCurrent
                                            ? colorScheme.primary.withValues(
                                                alpha: 0.08,
                                              )
                                            : colorScheme.surface,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          14.w,
                                          12.h,
                                          14.w,
                                          12.h,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 24.w,
                                                  height: 24.w,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: colorScheme.primary
                                                        .withValues(
                                                          alpha: 0.14,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    ayah.ayahNumber.toString(),
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          colorScheme.primary,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                if (isCurrent)
                                                  Icon(
                                                    _player.playing
                                                        ? Icons
                                                              .graphic_eq_rounded
                                                        : Icons
                                                              .play_arrow_rounded,
                                                    color: colorScheme.primary,
                                                    size: 18.sp,
                                                  ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              ayah.arabicText,
                                              textAlign: TextAlign.right,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontSize: _arabicFontSp.sp,
                                                height: 1.8,
                                                color: isCurrent
                                                    ? colorScheme.primary
                                                    : colorScheme.onSurface,
                                              ),
                                            ),
                                            if (_showEnglish) ...[
                                              SizedBox(height: 10.h),
                                              Text(
                                                ayah.englishText,
                                                style: TextStyle(
                                                  fontSize: _englishFontSp.sp,
                                                  height: 1.45,
                                                  color: isCurrent
                                                      ? colorScheme.primary
                                                      : colorScheme.onSurface,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  if (showAudioBar)
                    Positioned(
                      left: 0.w,
                      right: 0.w,
                      bottom: Platform.isIOS ? -30 : 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60.r),
                            bottomRight: Radius.circular(60.r),
                          ),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.55,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${l10n.quranSurahLabel} ${currentAyah.surahNumber}:${currentAyah.ayahNumber}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _closeAudioBar,
                                  child: Container(
                                    width: 22.w,
                                    height: 22.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 14.sp,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _formatTime(_currentPosition),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                Text(
                                  _formatTime(_currentDuration),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _sliderProgress,
                              min: 0,
                              max: 1,
                              onChangeStart: (_) => _isUserSeeking = true,
                              onChanged: (value) {
                                if (_sliderDurationMs <= 0) return;
                                final ms = (_sliderDurationMs * value).toInt();
                                setState(
                                  () => _currentPosition = Duration(
                                    milliseconds: ms,
                                  ),
                                );
                              },
                              onChangeEnd: (value) async {
                                _isUserSeeking = false;
                                if (_sliderDurationMs <= 0) return;
                                final ms = (_sliderDurationMs * value).toInt();
                                await _player.seek(Duration(milliseconds: ms));
                              },
                            ),
                            SizedBox(height: 2.h),
                            SizedBox(
                              width: 56.w,
                              height: 56.w,
                              child: _isAudioLoading
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    )
                                  : FilledButton(
                                      onPressed: _togglePlayPause,
                                      style: FilledButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Icon(
                                        _player.playing
                                            ? Icons.pause
                                            : Icons.play_arrow_rounded,
                                        size: 28.sp,
                                      ),
                                    ),
                            ),
                          ],
                        ),
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

enum _TextOption { englishArabic, arabicOnly, increaseFont, decreaseFont }
