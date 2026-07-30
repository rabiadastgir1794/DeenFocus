import 'dart:async';

import 'package:flutter/services.dart';

import '../../features/tajweed/model/tajweed_models.dart';
import 'storage_service.dart';

/// Flutter facade for on-device Tajweed (CoreML iOS / ONNX Android).
///
/// Platform detection stays here. UI and ViewModels must not branch on
/// CoreML vs ONNX. See ADR-006 / ADR-007.
class TajweedService {
  TajweedService._();

  static const MethodChannel _methodChannel = MethodChannel(
    'com.app.deenly.deenly/tajweed',
  );
  static const EventChannel _eventChannel = EventChannel(
    'com.app.deenly.deenly/tajweed_events',
  );

  static Stream<Map<String, dynamic>>? _events;

  /// Broadcast stream of native events (download progress, interruptions, etc.).
  static Stream<Map<String, dynamic>> events() {
    return _events ??= _eventChannel.receiveBroadcastStream().map((raw) {
      if (raw is Map) {
        return Map<String, dynamic>.from(raw);
      }
      return <String, dynamic>{'type': 'unknown', 'payload': raw};
    });
  }

  /// Download progress 0.0–1.0 derived from [events].
  static Stream<double> downloadProgress() {
    return events().where((e) => e['type'] == TajweedEventType.downloadProgress).map((
      e,
    ) {
      final p = e['progress'];
      if (p is num) return p.toDouble().clamp(0.0, 1.0);
      return 0.0;
    });
  }

  static Future<void> _ensureEnabled() async {
    final enabled = await StorageService.tajweedEnabled;
    if (!enabled) {
      throw const TajweedException(
        code: TajweedErrorCode.featureDisabled,
        message: 'Tajweed is disabled.',
      );
    }
  }

  static Never _rethrowPlatform(PlatformException e) {
    throw TajweedException(
      code: e.code,
      message: e.message,
      details: e.details,
    );
  }

  static Future<T> _invoke<T>(String method, [Map<String, dynamic>? args]) async {
    await _ensureEnabled();
    try {
      final result = await _methodChannel.invokeMethod<T>(method, args);
      return result as T;
    } on PlatformException catch (e) {
      _rethrowPlatform(e);
    } on MissingPluginException {
      throw const TajweedException(
        code: TajweedErrorCode.unsupported,
        message: 'Tajweed native plugin is not registered.',
      );
    }
  }

  static Future<bool> isAvailable() async {
    await _ensureEnabled();
    try {
      final result = await _methodChannel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } on PlatformException catch (e) {
      _rethrowPlatform(e);
    } on MissingPluginException {
      return false;
    }
  }

  /// Triggers native download/verify/activate (ADR-007). Progress via [downloadProgress].
  static Future<void> ensureModel() => _invoke<void>('ensureModel');

  static Future<void> prepareModel() => _invoke<void>('prepareModel');

  static Future<void> startRecording({
    required int surah,
    required int ayah,
    required String expectedArabic,
  }) {
    return _invoke<void>('startRecording', <String, dynamic>{
      'surah': surah,
      'ayah': ayah,
      'expectedArabic': expectedArabic,
    });
  }

  static Future<TajweedScoreResult> stopRecordingAndScore() async {
    await _ensureEnabled();
    try {
      final raw = await _methodChannel.invokeMethod<dynamic>(
        'stopRecordingAndScore',
      );
      if (raw is Map) {
        return TajweedScoreResult.fromJson(Map<String, dynamic>.from(raw));
      }
      throw const TajweedException(
        code: TajweedErrorCode.inferenceFailed,
        message: 'Native score result was not a map.',
      );
    } on PlatformException catch (e) {
      _rethrowPlatform(e);
    } on MissingPluginException {
      throw const TajweedException(
        code: TajweedErrorCode.unsupported,
        message: 'Tajweed native plugin is not registered.',
      );
    }
  }

  static Future<void> cancelRecording() => _invoke<void>('cancelRecording');

  static Future<TajweedRecordingState> getRecordingState() async {
    await _ensureEnabled();
    try {
      final raw = await _methodChannel.invokeMethod<String>('getRecordingState');
      return TajweedRecordingState.fromName(raw);
    } on PlatformException catch (e) {
      _rethrowPlatform(e);
    } on MissingPluginException {
      return TajweedRecordingState.idle;
    }
  }

  static Future<void> dispose() async {
    // Allow dispose even when feature flag is off (cleanup after disable).
    try {
      await _methodChannel.invokeMethod<void>('dispose');
    } on PlatformException catch (e) {
      _rethrowPlatform(e);
    } on MissingPluginException {
      // No-op when plugin absent.
    }
  }
}
