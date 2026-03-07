import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/services/storage_service.dart';
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

  final AudioPlayer _player = AudioPlayer();
  List<AyahRecord> _ayahs = const <AyahRecord>[];
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
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _bootstrap();
    _bindPlayerState();
  }

  @override
  void dispose() {
    _ticker?.cancel();
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

    setState(() {
      _ayahs = results[0] as List<AyahRecord>;
      _showEnglish = results[1] as bool;
      _arabicFontSp = results[2] as double;
      _englishFontSp = results[3] as double;
      _loadingAyahs = false;
    });

    if (_ayahs.isNotEmpty) {
      await _preparePlayer();
    }
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
        _showAudioBar = true;
      });
      _scrollToAyah(index);
    });

    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      if (state.playing) {
        _startTicker();
      } else {
        _ticker?.cancel();
      }
      setState(() {});
    });
  }

  Future<void> _preparePlayer() async {
    final source = ConcatenatingAudioSource(
      children: _ayahs
          .map((ayah) {
            return AudioSource.uri(
              Uri.parse(_getAudioUrl(ayah.surahNumber, ayah.ayahNumber)),
            );
          })
          .toList(growable: false),
    );
    await _player.setAudioSource(source, preload: true);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted || _isUserSeeking) return;
      setState(() {
        _currentPosition = _player.position;
        _currentDuration = _player.duration ?? Duration.zero;
      });
    });
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
    setState(() {
      _playingAyahIndex = position;
      _showAudioBar = true;
      _isAudioLoading = true;
    });
    await _player.seek(Duration.zero, index: position);
    await _player.play();
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
    _ticker?.cancel();
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = _player.playing;
    final currentAyah =
        (_playingAyahIndex >= 0 && _playingAyahIndex < _ayahs.length)
        ? _ayahs[_playingAyahIndex]
        : null;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
                const Spacer(),
                PopupMenuButton<_TextOption>(
                  tooltip: 'Text options',
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
                      child: const Text('English and Arabic'),
                    ),
                    CheckedPopupMenuItem<_TextOption>(
                      value: _TextOption.arabicOnly,
                      checked: !_showEnglish,
                      child: const Text('Arabic only'),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<_TextOption>(
                      value: _TextOption.increaseFont,
                      child: Text('Increase font'),
                    ),
                    const PopupMenuItem<_TextOption>(
                      value: _TextOption.decreaseFont,
                      child: Text('Decrease font'),
                    ),
                  ],
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 6.h,
                    ),
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
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 6.h, 24.w, 16.h),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.format_align_left_rounded,
                      size: 18.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${widget.surah.verses} verses',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.nightlight_round,
                      size: 18.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      widget.surah.revelationType,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _onPlayFullSurahTap,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                    ),
                    label: Text(isPlaying ? 'Pause' : 'Play surah'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: _loadingAyahs
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    controller: _listController,
                    padding: EdgeInsets.all(16.w),
                    itemCount: _ayahs.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final ayah = _ayahs[index];
                      final isCurrent = index == _playingAyahIndex;
                      return InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () => _onAyahTap(index),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: isCurrent
                                  ? colorScheme.primary.withValues(alpha: 0.5)
                                  : colorScheme.outlineVariant.withValues(
                                      alpha: 0.4,
                                    ),
                            ),
                            color: isCurrent
                                ? colorScheme.primary.withValues(alpha: 0.08)
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 24.w,
                                      height: 24.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorScheme.primary.withValues(
                                          alpha: 0.14,
                                        ),
                                      ),
                                      child: Text(
                                        ayah.ayahNumber.toString(),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (isCurrent)
                                      Icon(
                                        _player.playing
                                            ? Icons.graphic_eq_rounded
                                            : Icons.play_arrow_rounded,
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
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                if (_showEnglish) ...[
                                  SizedBox(height: 10.h),
                                  Text(
                                    ayah.englishText,
                                    style: TextStyle(
                                      fontSize: _englishFontSp.sp,
                                      height: 1.45,
                                      color: colorScheme.onSurfaceVariant,
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
          if (_showAudioBar && currentAyah != null)
            Container(
              margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
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
                          'Surah ${currentAyah.surahNumber}:${currentAyah.ayahNumber}',
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
                            color: colorScheme.surfaceContainerHighest,
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
                    value: _currentDuration.inMilliseconds <= 0
                        ? 0
                        : ((_currentPosition.inMilliseconds * 1000) /
                                  _currentDuration.inMilliseconds)
                              .clamp(0, 1000)
                              .toDouble(),
                    min: 0,
                    max: 1000,
                    onChangeStart: (_) => _isUserSeeking = true,
                    onChanged: (value) {
                      if (_currentDuration.inMilliseconds <= 0) return;
                      final ms =
                          ((_currentDuration.inMilliseconds * value) / 1000)
                              .toInt();
                      setState(
                        () => _currentPosition = Duration(milliseconds: ms),
                      );
                    },
                    onChangeEnd: (value) async {
                      _isUserSeeking = false;
                      if (_currentDuration.inMilliseconds <= 0) return;
                      final ms =
                          ((_currentDuration.inMilliseconds * value) / 1000)
                              .toInt();
                      await _player.seek(Duration(milliseconds: ms));
                    },
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: 56.w,
                    height: 56.w,
                    child: _isAudioLoading
                        ? const CircularProgressIndicator(strokeWidth: 2)
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
        ],
      ),
    );
  }
}

enum _TextOption { englishArabic, arabicOnly, increaseFont, decreaseFont }
