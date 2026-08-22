import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

/// Bridges the active Quran [AudioPlayer] to lock-screen / Control Center /
/// notification media controls. Does not own playback — reading screens still
/// create and dispose their own `just_audio` player.
class QuranAudioHandler extends BaseAudioHandler with SeekHandler {
  QuranAudioHandler._();

  static final QuranAudioHandler instance = QuranAudioHandler._();

  static Future<void>? _initFuture;
  static Uri? _artUri;
  static const _artAsset = 'assets/app_icon.png';

  AudioPlayer? _player;
  List<MediaItem> _items = const [];
  final List<StreamSubscription<dynamic>> _subs = [];
  DateTime? _lastNativeArtPush;
  static const _nowPlayingChannel = MethodChannel(
    'com.app.deenly.deenly/now_playing',
  );

  static MediaItem mediaItemFor({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
  }) {
    return MediaItem(
      id: '$surahNumber:$ayahNumber',
      title: '$surahName · $ayahNumber',
      album: surahName,
      artist: 'DeenFocus',
      artUri: _artUri,
    );
  }

  /// Starts the lock-screen bridge. Call from [attach] only — do not run
  /// during `main()` / first frame. Android `AudioService.init` needs the
  /// Activity-provided FlutterEngine and is unused until recitation plays.
  static Future<void> ensureInitialized() {
    final inFlight = _initFuture;
    if (inFlight != null) return inFlight;
    final future = _init();
    _initFuture = future;
    return future;
  }

  static Future<void> _init() async {
    try {
      await _prepareArtwork();
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      try {
        await AudioService.init(
          builder: () => instance,
          config: const AudioServiceConfig(
            androidNotificationChannelId: 'com.rnr.deenfocus.quran.audio',
            androidNotificationChannelName: 'Quran recitation',
            androidNotificationOngoing: true,
            androidStopForegroundOnPause: true,
            androidNotificationIcon: 'mipmap/ic_launcher',
          ),
        );
      } on Object catch (error, stack) {
        // Hot restart reuses the native plugin; a second Dart init throws.
        debugPrint('[QuranAudio] AudioService.init skipped: $error\n$stack');
      }
    } catch (error, stack) {
      _initFuture = null;
      Error.throwWithStackTrace(error, stack);
    }
  }

  static Future<void> _prepareArtwork() async {
    if (_artUri != null) return;
    try {
      final data = await rootBundle.load(_artAsset);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/deenfocus_now_playing.jpg');
      await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
      _artUri = Uri.file(file.path);
    } catch (error, stack) {
      debugPrint('[QuranAudio] artwork load failed: $error\n$stack');
    }
  }

  List<MediaItem> _withArtwork(List<MediaItem> items) {
    final art = _artUri;
    if (art == null) return items;
    return [
      for (final item in items)
        item.artUri == null ? item.copyWith(artUri: art) : item,
    ];
  }

  Future<void> attach({
    required AudioPlayer player,
    required List<MediaItem> items,
  }) async {
    await ensureInitialized();
    if (!identical(_player, player)) {
      _unbind();
      _player = player;
      _subs.add(player.playbackEventStream.listen((_) => _broadcast()));
      _subs.add(player.playerStateStream.listen((_) => _broadcast()));
      _subs.add(player.playingStream.listen((_) => _broadcast()));
      _subs.add(
        player.currentIndexStream.listen((_) {
          _syncMediaItem();
          _broadcast();
        }),
      );
      _subs.add(
        player.durationStream.listen((duration) {
          final current = mediaItem.value;
          if (current == null || duration == null) return;
          mediaItem.add(current.copyWith(duration: duration));
        }),
      );
    }
    _items = _withArtwork(items);
    queue.add(_items);
    _syncMediaItem();
    _broadcast();
    if (player.playing) {
      unawaited(_activateSession());
    }
  }

  void detach(AudioPlayer player) {
    if (!identical(_player, player)) return;
    _unbind();
    _items = const [];
    queue.add(const []);
    mediaItem.add(null);
    playbackState.add(
      PlaybackState(processingState: AudioProcessingState.idle, playing: false),
    );
  }

  void _unbind() {
    for (final sub in _subs) {
      unawaited(sub.cancel());
    }
    _subs.clear();
    _player = null;
  }

  void _syncMediaItem() {
    final items = _items;
    if (items.isEmpty) {
      mediaItem.add(null);
      return;
    }
    final index = _player?.currentIndex ?? 0;
    final clamped = index.clamp(0, items.length - 1);
    final duration = _player?.duration;
    final item = items[clamped];
    mediaItem.add(duration == null ? item : item.copyWith(duration: duration));
    unawaited(_pushNativeArtwork(force: true));
  }

  Future<void> _pushNativeArtwork({bool force = false}) async {
    final path = _artUri?.toFilePath();
    if (path == null) return;
    final now = DateTime.now();
    if (!force &&
        _lastNativeArtPush != null &&
        now.difference(_lastNativeArtPush!) <
            const Duration(milliseconds: 400)) {
      return;
    }
    _lastNativeArtPush = now;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await _nowPlayingChannel.invokeMethod<void>('setArtwork', path);
    } catch (_) {}
  }

  Future<void> _activateSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    await session.setActive(true);
  }

  AudioProcessingState _processingStateFor(AudioPlayer player) {
    final mapped =
        const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[player.processingState] ??
        AudioProcessingState.ready;
    // audio_service clears Now Playing when state goes idle. just_audio can
    // flicker idle between ayahs, which would blank the lock screen.
    if (mapped == AudioProcessingState.idle && _items.isNotEmpty) {
      return AudioProcessingState.ready;
    }
    return mapped;
  }

  void _broadcast() {
    final player = _player;
    if (player == null) return;
    final playing = player.playing;
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: _processingStateFor(player),
        playing: playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
        queueIndex: player.currentIndex,
      ),
    );
    unawaited(_pushNativeArtwork());
  }

  @override
  Future<void> play() async {
    final player = _player;
    if (player == null) return;
    await _activateSession();
    await player.play();
    _broadcast();
  }

  @override
  Future<void> pause() => _player?.pause() ?? Future.value();

  @override
  Future<void> seek(Duration position) =>
      _player?.seek(position) ?? Future.value();

  @override
  Future<void> skipToNext() async {
    final player = _player;
    if (player == null || !player.hasNext) return;
    await player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    final player = _player;
    if (player == null || !player.hasPrevious) return;
    await player.seekToPrevious();
  }

  @override
  Future<void> stop() async {
    await _player?.stop();
    await super.stop();
  }
}
