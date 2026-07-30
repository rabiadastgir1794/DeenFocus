import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/tajweed_service.dart';
import '../data/tajweed_history_store.dart';
import '../model/tajweed_models.dart';
import '../model/tajweed_practice_args.dart';

/// Top-level screen state for `TajweedPracticeScreen`.
///
/// [recordingReady]/[recording]/[scoring]/[result] all render the same
/// "recording" screen shell with different content — kept as one enum so the
/// screen has a single `switch` instead of two nested state machines.
enum TajweedFlowStage {
  checkingModel,
  downloadingModel,
  downloadFailed,
  recordingReady,
  recording,
  scoring,
  result,
}

/// Orchestrates the production Tajweed practice flow:
/// `ensureModel()` -> (one-time download screen) -> record -> score -> result.
///
/// Does not touch the AI Asset Manager / downloader — only calls the existing
/// `TajweedService` facade (ADR-006/007 contract, unchanged).
class TajweedPracticeViewModel extends ChangeNotifier {
  TajweedPracticeViewModel({required this.args});

  final TajweedPracticeArgs args;

  TajweedFlowStage _stage = TajweedFlowStage.checkingModel;
  TajweedFlowStage get stage => _stage;

  double _downloadProgress = 0;
  double get downloadProgress => _downloadProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Non-fatal banner shown on the recording screen (e.g. "recording too
  /// short, try again") without leaving [TajweedFlowStage.recordingReady].
  String? _recordingBanner;
  String? get recordingBanner => _recordingBanner;

  bool _micPermissionDenied = false;
  bool get micPermissionDenied => _micPermissionDenied;

  /// Guards against double-tap / concurrent async actions on the recording
  /// screen (mic permission + native startRecording are both async, and the
  /// GestureDetector's onTap doesn't await the returned Future).
  bool _actionInFlight = false;
  bool get actionInFlight => _actionInFlight;

  TajweedScoreResult? _result;
  TajweedScoreResult? get result => _result;

  Duration _recordingElapsed = Duration.zero;
  Duration get recordingElapsed => _recordingElapsed;

  StreamSubscription<double>? _progressSub;
  StreamSubscription<Map<String, dynamic>>? _eventsSub;
  Timer? _elapsedTimer;

  Future<void> start() async {
    _stage = TajweedFlowStage.checkingModel;
    notifyListeners();

    final enabled = await StorageService.tajweedEnabled;
    if (!enabled) {
      _stage = TajweedFlowStage.downloadFailed;
      _errorMessage =
          'AI Tajweed practice is turned off. Enable it in Settings first.';
      notifyListeners();
      return;
    }

    _eventsSub = TajweedService.events().listen(_onNativeEvent);

    try {
      final available = await TajweedService.isAvailable();
      if (available) {
        _stage = TajweedFlowStage.recordingReady;
        notifyListeners();
        return;
      }
    } catch (_) {
      // Fall through to ensureModel(), which will surface a concrete error.
    }

    await _downloadModel();
  }

  Future<void> _downloadModel() async {
    _stage = TajweedFlowStage.downloadingModel;
    _downloadProgress = 0;
    _errorMessage = null;
    notifyListeners();

    _progressSub ??= TajweedService.downloadProgress().listen((p) {
      _downloadProgress = p;
      notifyListeners();
    });

    try {
      await TajweedService.ensureModel();
      _stage = TajweedFlowStage.recordingReady;
      _downloadProgress = 1;
    } on TajweedException catch (e) {
      _stage = TajweedFlowStage.downloadFailed;
      _errorMessage = _friendlyMessage(e);
    } catch (e) {
      _stage = TajweedFlowStage.downloadFailed;
      _errorMessage = 'Could not prepare the AI model: $e';
    }
    notifyListeners();
  }

  Future<void> retryDownload() => _downloadModel();

  Future<void> toggleRecording() async {
    if (_actionInFlight) return;
    if (_stage == TajweedFlowStage.recording) {
      await _stopAndScore();
    } else if (_stage == TajweedFlowStage.recordingReady) {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    _actionInFlight = true;
    _recordingBanner = null;
    _micPermissionDenied = false;
    notifyListeners();

    try {
      final granted = await PermissionService.requestMicrophone();
      if (!granted) {
        _micPermissionDenied = true;
        _recordingBanner =
            'Microphone access is required to practice recitation.';
        return;
      }

      await TajweedService.startRecording(
        surah: args.surah,
        ayah: args.ayah,
        expectedArabic: args.arabicText,
      );
      _stage = TajweedFlowStage.recording;
      _startElapsedTimer();
    } on TajweedException catch (e) {
      _recordingBanner = _friendlyMessage(e);
    } catch (e) {
      _recordingBanner = 'Could not start recording: $e';
    } finally {
      _actionInFlight = false;
      notifyListeners();
    }
  }

  Future<void> _stopAndScore() async {
    _actionInFlight = true;
    _stopElapsedTimer();
    _stage = TajweedFlowStage.scoring;
    notifyListeners();

    try {
      final score = await TajweedService.stopRecordingAndScore();
      _result = score;
      _stage = TajweedFlowStage.result;
      unawaited(
        TajweedHistoryStore.add(
          TajweedHistoryEntry.fromScore(
            surah: args.surah,
            ayah: args.ayah,
            score: score,
          ),
        ),
      );
    } on TajweedException catch (e) {
      _stage = TajweedFlowStage.recordingReady;
      _recordingBanner = _friendlyMessage(e);
    } catch (e) {
      _stage = TajweedFlowStage.recordingReady;
      _recordingBanner = 'Scoring failed: $e';
    } finally {
      _actionInFlight = false;
      notifyListeners();
    }
  }

  Future<void> cancelRecording() async {
    _stopElapsedTimer();
    try {
      await TajweedService.cancelRecording();
    } catch (_) {
      // Best-effort — fall through to idle regardless.
    }
    _stage = TajweedFlowStage.recordingReady;
    notifyListeners();
  }

  void tryAgain() {
    _result = null;
    _recordingBanner = null;
    _stage = TajweedFlowStage.recordingReady;
    notifyListeners();
  }

  void _startElapsedTimer() {
    _recordingElapsed = Duration.zero;
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordingElapsed += const Duration(seconds: 1);
      notifyListeners();
    });
  }

  void _stopElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
  }

  void _onNativeEvent(Map<String, dynamic> event) {
    switch (event['type']) {
      case TajweedEventType.interrupted:
        if (_stage == TajweedFlowStage.recording ||
            _stage == TajweedFlowStage.scoring) {
          _stopElapsedTimer();
          _stage = TajweedFlowStage.recordingReady;
          _recordingBanner = 'Recording was interrupted. Please try again.';
          notifyListeners();
        }
      case TajweedEventType.modelUnloaded:
        // Memory-pressure cleanup on the native side; next startRecording()
        // transparently reloads the model (warm-load path), no UI action needed.
        break;
    }
  }

  String _friendlyMessage(TajweedException e) {
    switch (e.code) {
      case TajweedErrorCode.featureDisabled:
        return 'AI Tajweed practice is turned off. Enable it in Settings first.';
      case TajweedErrorCode.micPermissionDenied:
        return 'Microphone access is required to practice recitation.';
      case TajweedErrorCode.micBusy:
        return 'The microphone is being used by another app.';
      case TajweedErrorCode.audioTooShort:
        return 'That recording was too short — try reciting the full ayah.';
      case TajweedErrorCode.audioTooLong:
        return 'That recording was too long — keep it under 48 seconds.';
      case TajweedErrorCode.audioQualityPoor:
        return 'Audio was too quiet or distorted — find a quieter spot and try again.';
      case TajweedErrorCode.modelMissing:
        return 'The AI model is not installed yet.';
      case TajweedErrorCode.modelDownloadFailed:
        return 'Downloading the AI model failed. Check your connection and try again.';
      case TajweedErrorCode.modelLoadFailed:
        return 'The AI model could not be loaded on this device.';
      case TajweedErrorCode.inferenceFailed:
        return 'Scoring your recitation failed. Please try again.';
      case TajweedErrorCode.inferenceCancelled:
        return 'Recording cancelled.';
      case TajweedErrorCode.interrupted:
        return 'Recording was interrupted. Please try again.';
      case TajweedErrorCode.unsupported:
        return 'AI Tajweed practice is not available on this device.';
      default:
        return e.message ?? 'Something went wrong (${e.code}).';
    }
  }

  @override
  void dispose() {
    _stopElapsedTimer();
    _progressSub?.cancel();
    _eventsSub?.cancel();
    if (_stage == TajweedFlowStage.recording ||
        _stage == TajweedFlowStage.scoring) {
      unawaited(TajweedService.cancelRecording().catchError((_) {}));
    }
    super.dispose();
  }
}
