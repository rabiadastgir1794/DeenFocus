import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../features/tajweed/model/tajweed_models.dart';
import 'storage_service.dart';

/// Flutter facade for on-device Tajweed (CoreML iOS / ONNX Android).
///
/// **Production (Release/TestFlight):** [ensureModel] / [prepareModel] /
/// recording / scoring always use the platform production pack from
/// `catalog.json` (iOS CoreML, Android ONNX). That path is **not** gated by
/// `kDebugMode` / `#if DEBUG`.
///
/// **Debug-only:** [setDevCoreMlSource], [getDevCoreMlSource], and the
/// Settings “CoreML override” / Asset Debug UIs — those are hidden in Release;
/// native override is a no-op when `TajweedDevModelOverride.isAllowed == false`.
/// Canonical lexical scoring is always on in every build (not a toggle).
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
  static bool _freePreviewSession = false;

  /// Allows the one free demo ayah to run while AI Tajweed is off in Settings.
  static void setFreePreviewSession(bool active) {
    _freePreviewSession = active;
  }

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
    if (_freePreviewSession) return;
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
  ///
  /// Call only from Tajweed practice / DEBUG pack flows — never from app launch,
  /// resume, or unrelated screens.
  static Future<void> ensureModel() => _invoke<void>('ensureModel');

  /// Warm-loads native ASR + pronunciation head for inference.
  ///
  /// **Production call site:** only [TajweedModelSession._run] (via
  /// `ensurePrepared`), which runs when the user opens Tajweed practice and the
  /// session is not yet ready, or immediately after a fresh download / Official↔DIY
  /// switch. Must **not** be called from `main()`, providers, app resume, Settings
  /// init, or any screen outside the Tajweed feature.
  static Future<void> prepareModel() {
    assert(() {
      debugPrint(
        '[TajweedService] prepareModel() — expected only from TajweedModelSession '
        'or explicit Tajweed DEBUG install',
      );
      return true;
    }());
    return _invoke<void>('prepareModel');
  }

  static Future<void> startRecording({
    required int surah,
    required int ayah,
    required String expectedArabic,
    String? lexicalReferenceArabic,
  }) {
    return _invoke<void>('startRecording', <String, dynamic>{
      'surah': surah,
      'ayah': ayah,
      'expectedArabic': expectedArabic,
      if (lexicalReferenceArabic != null && lexicalReferenceArabic.isNotEmpty)
        'lexicalReferenceArabic': lexicalReferenceArabic,
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

  /// DEBUG iOS only: `catalog` | `official` | `diy`. Release always reports
  /// `catalog`. Also returns whether the native DEBUG override is active.
  static Future<String> getDevCoreMlSource() async {
    try {
      final raw = await _methodChannel.invokeMethod<dynamic>('getDevCoreMlSource');
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        return (map['source'] as String?) ?? 'catalog';
      }
      if (raw is String) return raw;
      return 'catalog';
    } on MissingPluginException {
      return 'catalog';
    } on PlatformException catch (e) {
      _rethrowPlatform(e);
    }
  }

  /// Whether native Debug override is compiled in (`overrideAllowed`).
  static Future<bool> isDevCoreMlOverrideAllowed() async {
    try {
      final raw = await _methodChannel.invokeMethod<dynamic>('getDevCoreMlSource');
      if (raw is Map) {
        return Map<String, dynamic>.from(raw)['overrideAllowed'] == true;
      }
      return false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// DEBUG iOS only: select which CoreML pack `ensureModel` downloads.
  /// Release no-ops. After changing, call [ensureModel] to download/activate.
  static Future<void> setDevCoreMlSource(String source) async {
    try {
      await _methodChannel.invokeMethod<void>('setDevCoreMlSource', <String, dynamic>{
        'source': source,
      });
    } on MissingPluginException {
      // No-op.
    } on PlatformException catch (e) {
      _rethrowPlatform(e);
    }
  }

  /// Active pack diagnostics (version, encoderApi, DEBUG source).
  static Future<Map<String, dynamic>> getActiveCoreMlInfo() async {
    try {
      final raw = await _methodChannel.invokeMethod<dynamic>('getActiveCoreMlInfo');
      if (raw is Map) {
        return Map<String, dynamic>.from(raw);
      }
      return <String, dynamic>{'available': false};
    } on MissingPluginException {
      return <String, dynamic>{'available': false};
    } on PlatformException catch (e) {
      _rethrowPlatform(e);
    }
  }

  /// Canonical lexical (ADR-010) is always the production scorer.
  /// Kept for channel compatibility; always returns `true`.
  static Future<bool> getCanonicalLexicalProductionEnabled() async {
    return true;
  }

  /// No-op — Canonical cannot be disabled. Always returns `true`.
  static Future<bool> setCanonicalLexicalProductionEnabled(bool enabled) async {
    return true;
  }
}
