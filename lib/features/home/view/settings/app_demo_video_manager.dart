import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

/// Bundled walkthrough clip (see `pubspec.yaml` assets).
const String kAppDemoVideoAsset = 'assets/video/about_deen_focus.mp4';

/// Single [VideoPlayerController] for settings preview + fullscreen demo.
///
/// Defers [VideoPlayerController.initialize] until after the first frame, which
/// is safer for platform channel setup (including after hot restart).
class AppDemoVideoManager extends ChangeNotifier {
  VideoPlayerController? _controller;
  Duration _resumePosition = Duration.zero;
  Object? _lastError;
  Future<void>? _initializing;

  VideoPlayerController? get controller =>
      _controller?.value.isInitialized == true ? _controller : null;

  Object? get lastError => _lastError;

  bool get hasError => _lastError != null;

  Duration get resumePosition => _resumePosition;

  /// Loads the asset if needed, then shows the first frame (muted) for preview.
  Future<void> ensurePreviewReady() async {
    await _ensureInitialized();
    final c = _controller;
    if (c == null) return;
    await c.setLooping(false);
    await c.setVolume(0);
    await c.pause();
    await c.seekTo(Duration.zero);
    notifyListeners();
  }

  /// Fullscreen: loop, audible, continue from [_resumePosition].
  Future<void> enterFullscreen() async {
    await _ensureInitialized();
    final c = _controller;
    if (c == null) return;
    _lastError = null;
    await c.setLooping(true);
    await c.setVolume(1);
    await c.seekTo(_resumePosition);
    await c.play();
    notifyListeners();
  }

  /// User left fullscreen: pause, remember position, reset preview to start.
  Future<void> leaveFullscreen() async {
    final c = _controller;
    if (c == null || c.value.isInitialized != true) return;
    _resumePosition = c.value.position;
    await c.pause();
    await c.setVolume(0);
    await c.setLooping(false);
    await c.seekTo(Duration.zero);
    notifyListeners();
  }

  Future<void> _ensureInitialized() async {
    if (_controller?.value.isInitialized == true) return;
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
        VideoPlayerController? ctrl;
        try {
          ctrl = VideoPlayerController.asset(kAppDemoVideoAsset);
          await ctrl.initialize();
          _controller = ctrl;
          ctrl = null;
          _lastError = null;
          await _controller!.setVolume(0);
          await _controller!.pause();
          await _controller!.seekTo(Duration.zero);
          notifyListeners();
          completer.complete();
        } on PlatformException catch (e) {
          if (ctrl != null) {
            await ctrl.dispose();
          }
          _lastError = e;
          notifyListeners();
          completer.completeError(e);
        } catch (e) {
          if (ctrl != null) {
            await ctrl.dispose();
          }
          _lastError = e;
          notifyListeners();
          completer.completeError(e);
        }
      }());
    });
    return completer.future;
  }

  /// After a channel error, tear down and try again (often needs a full run
  /// instead of hot restart).
  Future<void> retry() async {
    await _controller?.dispose();
    _controller = null;
    _lastError = null;
    notifyListeners();
    await ensurePreviewReady();
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    _controller = null;
    super.dispose();
  }
}
