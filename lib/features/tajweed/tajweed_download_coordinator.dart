import 'package:flutter/foundation.dart';

import '../../core/services/storage_service.dart';
import '../../core/services/tajweed_service.dart';
import 'viewmodel/tajweed_practice_view_model.dart';

/// UI-facing download state for Settings (and mic routing).
enum TajweedDownloadPhase {
  /// Pack not on disk (or unknown).
  notDownloaded,

  /// [ensureModel] / prepare in flight (continues after leaving Settings).
  downloading,

  /// Pack verified on disk (ready for practice).
  downloaded,

  /// Last download attempt failed.
  failed,
}

/// Shared download coordinator so Settings progress and Surah mic routing
/// stay in sync across navigation. Settings download calls
/// [TajweedService.ensureModel] (pack only); practice still uses
/// [TajweedModelSession.ensurePrepared] for warm-load.
class TajweedDownloadCoordinator {
  TajweedDownloadCoordinator._();

  static final ValueNotifier<TajweedDownloadPhase> phase =
      ValueNotifier<TajweedDownloadPhase>(TajweedDownloadPhase.notDownloaded);

  static final ValueNotifier<double> progress = ValueNotifier<double>(0);

  static Future<void>? _inFlightUiDownload;
  static bool _listening = false;

  /// Attach the global progress stream once (safe to call from any screen).
  static void ensureListening() {
    if (_listening) return;
    _listening = true;
    TajweedModelSession.onEnsureStarted = noteEnsureStarted;
    TajweedModelSession.onEnsureFinished = noteEnsureFinished;
    // Keep subscription for app lifetime so progress survives navigation.
    TajweedService.downloadProgress().listen((p) {
      if (phase.value != TajweedDownloadPhase.downloading &&
          TajweedModelSession.isBusy) {
        phase.value = TajweedDownloadPhase.downloading;
      }
      if (p > progress.value) progress.value = p;
    });
  }

  /// Called when any path starts model ensure / prepare.
  static void noteEnsureStarted() {
    ensureListening();
    if (phase.value != TajweedDownloadPhase.downloaded) {
      phase.value = TajweedDownloadPhase.downloading;
      if (progress.value <= 0) progress.value = 0;
    }
  }

  /// Called when ensure+prepare finishes (success or failure).
  static void noteEnsureFinished({required bool success}) {
    if (success) {
      phase.value = TajweedDownloadPhase.downloaded;
      progress.value = 1;
    } else if (phase.value == TajweedDownloadPhase.downloading) {
      phase.value = TajweedDownloadPhase.failed;
    }
  }

  /// Refresh phase from disk / in-flight work (does not cancel downloads).
  static Future<void> refresh() async {
    ensureListening();

    if (TajweedModelSession.isBusy || _inFlightUiDownload != null) {
      phase.value = TajweedDownloadPhase.downloading;
      return;
    }

    try {
      if (await TajweedModelSession.isReadyForInference() ||
          await TajweedService.isAvailable()) {
        phase.value = TajweedDownloadPhase.downloaded;
        progress.value = 1;
        return;
      }
    } catch (_) {
      // Fall through.
    }

    if (phase.value == TajweedDownloadPhase.downloading) {
      // Stale downloading flag with no in-flight work.
      phase.value = TajweedDownloadPhase.notDownloaded;
      progress.value = 0;
      return;
    }

    if (phase.value != TajweedDownloadPhase.failed) {
      phase.value = TajweedDownloadPhase.notDownloaded;
      progress.value = 0;
    }
  }

  /// Start (or join) a Settings-driven download. Continues if the user leaves
  /// the screen. Downloads/verifies the pack only — does **not** warm-load
  /// inference ([TajweedModelSession.ensurePrepared] / prepare); practice does
  /// that on open. Android ONNX prepare after a ~450MB install can fail/OOM
  /// and previously made Settings look like download never started.
  static Future<void> startDownload() {
    ensureListening();
    return _inFlightUiDownload ??= _runDownload().whenComplete(() {
      _inFlightUiDownload = null;
    });
  }

  static Future<void> _runDownload() async {
    await StorageService.setTajweedEnabled(true);
    noteEnsureStarted();

    try {
      await TajweedService.ensureModel();
      final ok = await TajweedService.isAvailable();
      if (progress.value < 1) progress.value = 1;
      noteEnsureFinished(success: ok);
      if (!ok) {
        throw StateError('Model download finished but pack is not available');
      }
    } catch (e) {
      debugPrint('[TajweedDownloadCoordinator] download failed: $e');
      noteEnsureFinished(success: false);
      rethrow;
    }
  }

  /// Delete the on-disk pack and reset UI phase to [notDownloaded].
  /// No-op while a download is in flight.
  static Future<void> deleteDownloadedModel() async {
    ensureListening();
    if (TajweedModelSession.isBusy ||
        _inFlightUiDownload != null ||
        phase.value == TajweedDownloadPhase.downloading) {
      throw StateError('Cannot delete while download is in progress');
    }
    await TajweedService.deleteModel();
    TajweedModelSession.invalidateBecauseDeleted();
    phase.value = TajweedDownloadPhase.notDownloaded;
    progress.value = 0;
  }
}
