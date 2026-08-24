import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'storage_service.dart';
import '../../features/quran/data/quran_translation_texts.dart';

/// Flutter facade for downloadable Quran translation packs (ADR-009).
///
/// Downloads run through the native [AIAssetManager] pipeline (`translation_pack`
/// plugins). The shared `catalog.json` is the source of truth for which
/// languages exist — nothing is hardcoded in the app.
///
/// **Default English** (`defaultLanguageCode`) is installed silently in the
/// background on first launch (no dialog, never blocks startup). Other
/// languages keep the manual download dialog.
class QuranTranslationService {
  QuranTranslationService._();

  /// Default Quran translation language (Saheeh International English pack).
  static const String defaultLanguageCode = 'en';

  static const MethodChannel _methodChannel = MethodChannel(
    'com.app.deenly.deenly/quran_translations',
  );
  static const EventChannel _eventChannel = EventChannel(
    'com.app.deenly.deenly/quran_translation_events',
  );

  static Stream<Map<String, dynamic>>? _events;

  /// Bumps whenever a translation pack becomes available on disk so open
  /// Quran screens can reload ayah text without a full navigation restart.
  static final ValueNotifier<int> installationRevision = ValueNotifier<int>(0);

  static Future<void>? _defaultEnsureInFlight;
  static bool _lifecycleObserverAttached = false;

  static bool isDefaultLanguage(String languageCode) =>
      languageCode == defaultLanguageCode;

  /// Non-English translation packs require an active subscription.
  static bool requiresPremium(String languageCode) =>
      !isDefaultLanguage(languageCode);

  static Stream<Map<String, dynamic>> events() {
    return _events ??= _eventChannel.receiveBroadcastStream().map((raw) {
      if (raw is Map) return Map<String, dynamic>.from(raw);
      return <String, dynamic>{'type': 'unknown', 'payload': raw};
    });
  }

  static Stream<double> downloadProgress() {
    return events()
        .where((e) => e['type'] == 'downloadProgress')
        .map((e) {
          final p = e['progress'];
          if (p is num) return p.toDouble().clamp(0.0, 1.0);
          return 0.0;
        });
  }

  /// One catalog row: language code, pack id, optional display name, install state.
  ///
  /// Defaults to a network refresh so newly published languages appear in
  /// Reading Settings without waiting for the 24h cache TTL. Falls back to the
  /// on-disk cache when offline (handled natively).
  static Future<List<QuranTranslationOption>> listAvailable({
    bool forceRefresh = true,
  }) async {
    try {
      final raw = await _methodChannel.invokeMethod<List<Object?>>(
        'listAvailableTranslations',
        {'forceRefresh': forceRefresh},
      );
      if (raw == null) return const [];
      return raw.map((item) {
        final map = Map<String, dynamic>.from(item! as Map);
        return QuranTranslationOption(
          languageCode: map['language'] as String,
          packId: map['packId'] as String,
          displayName: map['displayName'] as String?,
          installed: map['installed'] == true,
          approxSizeBytes: (map['approxSizeBytes'] as num?)?.toInt(),
        );
      }).toList(growable: false);
    } on PlatformException catch (e) {
      throw QuranTranslationException(e.message ?? e.code);
    }
  }

  /// True when [languageCode] appears in the cached/fresh catalog as `translation_pack`.
  static Future<bool> hasTranslationPack(String languageCode) async {
    try {
      final result = await _methodChannel.invokeMethod<bool>(
        'hasTranslationPack',
        {'languageCode': languageCode},
      );
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> isAvailable(String languageCode) async {
    try {
      final result = await _methodChannel.invokeMethod<bool>(
        'isTranslationAvailable',
        {'languageCode': languageCode},
      );
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<String?> localPath(String languageCode) async {
    try {
      final result = await _methodChannel.invokeMethod<String>(
        'getTranslationPath',
        {'languageCode': languageCode},
      );
      return result;
    } on PlatformException {
      return null;
    }
  }

  /// Downloads / updates via native AIAssetManager. Throws on first-install failure.
  static Future<void> ensureTranslation(String languageCode) async {
    try {
      await _methodChannel.invokeMethod<void>(
        'ensureTranslation',
        {'languageCode': languageCode},
      );
      QuranTranslationTexts.evict(languageCode);
      _notifyInstalled(languageCode);
    } on PlatformException catch (e) {
      throw QuranTranslationException(e.message ?? e.code);
    }
  }

  /// Persists the active Quran translation language and notifies open readers
  /// so they refresh immediately (works for already-installed packs too).
  static Future<void> selectLanguage(String languageCode) async {
    await StorageService.setQuranTranslationLanguage(languageCode);
    QuranTranslationTexts.evict(languageCode);
    _notifyInstalled(languageCode);
  }

  static Future<String?> displayNameFor(String languageCode) async {
    final options = await listAvailable();
    return options
        .where((o) => o.languageCode == languageCode)
        .map((o) => o.displayName)
        .firstOrNull;
  }

  /// Fire-and-forget: ensure default English is on disk. Never throws to callers,
  /// never shows UI. Safe to call from post-`runApp` init and on resume.
  static Future<void> ensureDefaultTranslationInBackground() {
    return _defaultEnsureInFlight ??= _ensureDefaultInternal().whenComplete(() {
      _defaultEnsureInFlight = null;
    });
  }

  /// Attach a one-shot lifecycle observer that retries the default download
  /// when the app returns to foreground (offline → online path).
  static void attachLifecycleRetry() {
    if (_lifecycleObserverAttached) return;
    _lifecycleObserverAttached = true;
    WidgetsBinding.instance.addObserver(_DefaultTranslationLifecycleObserver());
  }

  static Future<void> _ensureDefaultInternal() async {
    try {
      final language = defaultLanguageCode;
      // Keep Storage pointing at English as the product default.
      final selected = await StorageService.quranTranslationLanguage;
      if (selected.isEmpty) {
        await StorageService.setQuranTranslationLanguage(language);
      }

      // Already on disk — do not re-select; user may have chosen another pack.
      if (await isAvailable(language)) {
        return;
      }

      // Soft catalog check — if offline / pack missing, stay silent.
      final hasPack = await hasTranslationPack(language);
      if (!hasPack) return;

      await ensureTranslation(language);
      await selectLanguage(language);
      assert(() {
        debugPrint(
          '[QuranTranslation] default "$language" installed (silent background)',
        );
        return true;
      }());
    } catch (e) {
      assert(() {
        debugPrint('[QuranTranslation] silent default ensure failed: $e');
        return true;
      }());
      // Offline / transient — Arabic-only until next retry.
    }
  }

  static void _notifyInstalled(String languageCode) {
    installationRevision.value = installationRevision.value + 1;
  }
}

class _DefaultTranslationLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(QuranTranslationService.ensureDefaultTranslationInBackground());
    }
  }
}

class QuranTranslationOption {
  const QuranTranslationOption({
    required this.languageCode,
    required this.packId,
    this.displayName,
    required this.installed,
    this.approxSizeBytes,
  });

  /// BCP-47-ish language tag from catalog (may repeat for multiple translators).
  final String languageCode;

  /// Stable catalog identity — prefer this over [languageCode] for selection UI
  /// when multiple packs share a language (e.g. two English translators).
  final String packId;

  final String? displayName;
  final bool installed;

  /// Platform-specific catalog `approxSizeBytes` (ios/android), when present.
  final int? approxSizeBytes;
}

class QuranTranslationException implements Exception {
  QuranTranslationException(this.message);
  final String message;

  @override
  String toString() => 'QuranTranslationException: $message';
}
