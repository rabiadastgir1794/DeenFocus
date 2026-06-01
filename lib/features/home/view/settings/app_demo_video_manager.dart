import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../../../core/logger/logger_service.dart';
import '../../../../core/logger/trace_helpers.dart';

/// Bundled walkthrough clip (see `pubspec.yaml` assets).
const String kAppDemoVideoAsset = 'assets/video/about_deen_focus.mp4';
const String _kVideoPlayerLogTag = 'videoPlayer';
const Duration _kPlayStartTimeout = Duration(seconds: 2);
const Duration _kFirstFrameTimeout = Duration(seconds: 4);

/// Single [Player] for settings preview + fullscreen demo.
///
/// Uses media_kit instead of Flutter's platform video_player so Android devices
/// with fragile hardware playback paths (notably some Huawei models) can fall
/// back to media_kit's bundled native playback stack.
class AppDemoVideoManager extends ChangeNotifier {
  Player? _player;
  VideoController? _controller;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  Duration _resumePosition = Duration.zero;
  Object? _lastError;
  Future<void>? _initializing;
  bool _isReady = false;
  bool _disposed = false;

  VideoController? get controller => _isReady ? _controller : null;

  Object? get lastError => _lastError;

  bool get hasError => _lastError != null;

  Duration get resumePosition => _resumePosition;

  double get aspectRatio {
    final state = _player?.state;
    final width = state?.width;
    final height = state?.height;
    if (width != null && height != null && width > 0 && height > 0) {
      return width / height;
    }
    return 16 / 9;
  }

  /// Loads the asset if needed, then shows the first frame (muted) for preview.
  Future<void> ensurePreviewReady() async {
    await _ensureInitialized();
    final p = _player;
    if (p == null) return;
    await p.setPlaylistMode(PlaylistMode.none);
    await p.setVolume(0);
    await p.pause();
    await p.seek(Duration.zero);
    notifyListeners();
  }

  /// Fullscreen: loop, audible, continue from [_resumePosition].
  Future<void> enterFullscreen() async {
    await _ensureInitialized();
    final p = _player;
    if (p == null) return;
    _lastError = null;
    LoggerService.instance.info(
      _kVideoPlayerLogTag,
      'play requested asset=$kAppDemoVideoAsset resumeMs=${_resumePosition.inMilliseconds} ${_stateSummary(p)}',
    );
    try {
      await p.setPlaylistMode(PlaylistMode.single);
      await p.setVolume(100);
      await p.seek(_resumePosition);
      await p.play();
      await _verifyPlaybackStarted(p);
    } catch (e, st) {
      _lastError = e;
      _isReady = false;
      LoggerService.instance.error(
        _kVideoPlayerLogTag,
        'play failed asset=$kAppDemoVideoAsset ${_stateSummary(p)}',
        error: e,
        stackTrace: st,
      );
      notifyListeners();
      rethrow;
    }
    notifyListeners();
  }

  /// User left fullscreen: pause, remember position, reset preview to start.
  Future<void> leaveFullscreen() async {
    final p = _player;
    if (p == null) return;
    _resumePosition = p.state.position;
    await p.pause();
    await p.setVolume(0);
    await p.setPlaylistMode(PlaylistMode.none);
    await p.seek(Duration.zero);
    notifyListeners();
  }

  Future<void> _ensureInitialized() async {
    if (_isReady) return;
    if (_initializing != null) {
      await _initializing;
      return;
    }
    _initializing = _initializeAfterFrame();
    try {
      await _initializing;
    } finally {
      _initializing = null;
    }
  }

  Future<void> _initializeAfterFrame() async {
    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(() async {
        Player? player;
        try {
          final enableHardwareAcceleration =
              defaultTargetPlatform != TargetPlatform.android;
          LoggerService.instance.info(
            _kVideoPlayerLogTag,
            'initialize requested asset=$kAppDemoVideoAsset platform=$defaultTargetPlatform hardwareAcceleration=$enableHardwareAcceleration',
          );
          await TraceHelpers.traceAsync(
            _kVideoPlayerLogTag,
            'media_kit Player.open asset=$kAppDemoVideoAsset',
            () async {
              player = Player();
              final controller = VideoController(
                player!,
                configuration: VideoControllerConfiguration(
                  enableHardwareAcceleration: enableHardwareAcceleration,
                ),
              );
              await controller.platform.future;
              await player!.open(
                Media('asset:///$kAppDemoVideoAsset'),
                play: false,
              );
              _bindPlayer(player!);
              _player = player;
              _controller = controller;
              _isReady = true;
              player = null;
              _lastError = null;
              await _player!.setVolume(0);
              await _player!.pause();
              await _player!.seek(Duration.zero);
              LoggerService.instance.info(
                _kVideoPlayerLogTag,
                'initialize ready asset=$kAppDemoVideoAsset ${_stateSummary(_player!)}',
              );
              notifyListeners();
            },
            logSuccess: true,
          );
          completer.complete();
        } catch (e, st) {
          await player?.dispose();
          _lastError = e;
          _isReady = false;
          LoggerService.instance.error(
            _kVideoPlayerLogTag,
            'initialize failed asset=$kAppDemoVideoAsset platform=$defaultTargetPlatform',
            error: e,
            stackTrace: st,
          );
          notifyListeners();
          completer.completeError(e);
        }
      }());
    });
    return completer.future;
  }

  void _bindPlayer(Player player) {
    _subscriptions
      ..add(
        player.stream.error.listen((message) {
          _lastError = message;
          _isReady = false;
          LoggerService.instance.error(
            _kVideoPlayerLogTag,
            'media_kit stream error asset=$kAppDemoVideoAsset ${_stateSummary(player)}',
            error: message,
          );
          if (!_disposed) notifyListeners();
        }),
      )
      ..add(
        player.stream.width.listen((_) {
          if (!_disposed) notifyListeners();
        }),
      )
      ..add(
        player.stream.height.listen((_) {
          if (!_disposed) notifyListeners();
        }),
      );
  }

  Future<void> _verifyPlaybackStarted(Player player) async {
    if (!player.state.playing) {
      final started = await player.stream.playing
          .firstWhere((playing) => playing)
          .timeout(_kPlayStartTimeout, onTimeout: () => false);
      if (!started) {
        throw StateError(
          'media_kit did not report playing within ${_kPlayStartTimeout.inMilliseconds}ms',
        );
      }
    }

    final controller = _controller;
    if (controller == null) return;
    try {
      await controller.waitUntilFirstFrameRendered.timeout(_kFirstFrameTimeout);
    } on TimeoutException {
      _isReady = false;
      throw StateError(
        'media_kit did not render first frame within ${_kFirstFrameTimeout.inMilliseconds}ms',
      );
    }
  }

  String _stateSummary(Player player) {
    final state = player.state;
    return 'playing=${state.playing} buffering=${state.buffering} '
        'positionMs=${state.position.inMilliseconds} '
        'durationMs=${state.duration.inMilliseconds} '
        'size=${state.width ?? 0}x${state.height ?? 0}';
  }

  Future<void> _disposePlayer() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
    final player = _player;
    _player = null;
    _controller = null;
    _isReady = false;
    await player?.dispose();
  }

  /// After a playback error, tear down and try again from a clean player.
  Future<void> retry() async {
    await _disposePlayer();
    _lastError = null;
    notifyListeners();
    await ensurePreviewReady();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_disposePlayer());
    super.dispose();
  }
}
