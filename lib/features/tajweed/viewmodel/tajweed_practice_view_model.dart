import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/tajweed_service.dart';
import '../../quran/reading_engine/quran_recitation.dart';
import '../../quran/reading_engine/quran_repeat_mode.dart';
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

/// Process-wide model readiness for Tajweed practice.
///
/// Guarantees at most **one** `ensureModel` + `prepareModel` pair per bound
/// pack for the app process. Multiple [TajweedPracticeViewModel]s await the
/// same [Future]. Session resets only when the on-disk pack identity changes
/// (version / SHA), the user switches Official↔DIY, or the model is deleted —
/// never on screen create / ayah navigation.
class TajweedModelSession {
  TajweedModelSession._();

  static bool ready = false;
  static String? boundVersion;
  static String? boundEncoderSha;
  static Future<void>? _inFlight;
  static final List<VoidCallback> _afterEnsureListeners = <VoidCallback>[];

  /// True while a shared ensure+prepare is running (survives screen changes).
  static bool get isBusy => _inFlight != null;

  /// Optional UI hooks (e.g. Settings progress) — set by
  /// [TajweedDownloadCoordinator], never by native code.
  static VoidCallback? onEnsureStarted;
  static void Function({required bool success})? onEnsureFinished;

  /// Official↔DIY DEBUG switch — must start a fresh ensure+prepare.
  static void invalidateBecauseDevSourceSwitch() {
    _invalidate('devSourceSwitch');
  }

  /// User / debug harness wiped the on-disk pack.
  static void invalidateBecauseDeleted() {
    _invalidate('modelDeleted');
  }

  /// On-disk version or encoder SHA no longer matches what we prepared.
  static void invalidateBecausePackIdentityChanged() {
    _invalidate('versionOrShaChanged');
  }

  /// @nodoc Test-only / failure recovery when prepare failed mid-flight.
  @visibleForTesting
  static void resetForTest() {
    _invalidate('testReset');
  }

  static void _invalidate(String reason) {
    debugPrint('[TajweedModelSession] invalidate reason=$reason');
    ready = false;
    boundVersion = null;
    boundEncoderSha = null;
    _inFlight = null;
  }

  /// True when this process already finished prepare for the current on-disk
  /// pack. If the pack is missing or its version/SHA changed, invalidates and
  /// returns false so callers can run [ensurePrepared] again.
  static Future<bool> isReadyForInference() async {
    final available = await TajweedService.isAvailable();
    if (!available) {
      if (ready || _inFlight != null) {
        invalidateBecauseDeleted();
      }
      return false;
    }
    if (!ready) return false;

    final identity = await _readPackIdentity();
    if (!_identityMatches(identity.version, identity.sha)) {
      invalidateBecausePackIdentityChanged();
      return false;
    }
    return true;
  }

  /// Shared ensure → prepare for the app lifetime (per pack identity).
  ///
  /// If [ready] is already true, returns immediately without calling native
  /// ensure/prepare again. Concurrent callers share one [_inFlight] Future.
  /// [onAfterEnsure] runs after download/verify and before prepare (or
  /// immediately if already ready) so UIs can leave the download chrome.
  ///
  /// This is the **only** production entry that may invoke
  /// [TajweedService.prepareModel]. Call from Tajweed practice bootstrap or
  /// DEBUG Official↔DIY switch — nowhere else.
  static Future<void> ensurePrepared({VoidCallback? onAfterEnsure}) {
    if (onAfterEnsure != null) {
      _afterEnsureListeners.add(onAfterEnsure);
    }

    if (ready) {
      // Lifetime success for this pack — do not start another ensure+prepare.
      try {
        onAfterEnsure?.call();
      } finally {
        if (onAfterEnsure != null) {
          _afterEnsureListeners.remove(onAfterEnsure);
        }
      }
      return Future<void>.value();
    }

    _inFlight ??= _run();
    onEnsureStarted?.call();
    return _inFlight!.whenComplete(() {
      final success = ready;
      _inFlight = null;
      onEnsureFinished?.call(success: success);
      if (onAfterEnsure != null) {
        _afterEnsureListeners.remove(onAfterEnsure);
      }
    });
  }

  /// Sole production path that calls [TajweedService.prepareModel].
  static Future<void> _run() async {
    try {
      await TajweedService.ensureModel();
      for (final listener in List<VoidCallback>.from(_afterEnsureListeners)) {
        listener();
      }
      // Prepare only here: after download/verify (or no-op ensure when already
      // on disk), when Tajweed practice actually needs a warm model.
      await TajweedService.prepareModel();
      final identity = await _readPackIdentity();
      boundVersion = identity.version;
      boundEncoderSha = identity.sha;
      ready = true;
      debugPrint(
        '[TajweedModelSession] ready version=${identity.version} '
        'shaPrefix=${identity.sha.length >= 12 ? identity.sha.substring(0, 12) : identity.sha}',
      );
    } catch (e) {
      // prepare/ensure failed — never leave ready=true stuck forever.
      ready = false;
      boundVersion = null;
      boundEncoderSha = null;
      debugPrint('[TajweedModelSession] ensure/prepare failed: $e');
      rethrow;
    }
  }

  static Future<({String version, String sha})> _readPackIdentity() async {
    try {
      final info = await TajweedService.getActiveCoreMlInfo();
      final version = (info['version'] as String?) ??
          (info['manifestVersion'] as String?) ??
          '';
      final sha = (info['encoderSha256'] as String?) ?? '';
      return (version: version, sha: sha);
    } catch (_) {
      return (version: '', sha: '');
    }
  }

  static bool _identityMatches(String version, String sha) {
    if (boundVersion != version) return false;
    // When SHA is reported on either side, require equality.
    final boundSha = boundEncoderSha ?? '';
    if (sha.isNotEmpty || boundSha.isNotEmpty) {
      return boundSha == sha;
    }
    return true;
  }
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

  /// Stable [TajweedErrorCode] for download failures (localized in the view).
  String? _errorCode;
  String? get errorCode => _errorCode;

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

  /// DEBUG iOS: which CoreML pack is actually on disk / will score.
  String _activeCoreMlLabel = 'Unknown';
  String get activeCoreMlLabel => _activeCoreMlLabel;

  bool _officialCoreMlActive = false;
  bool get officialCoreMlActive => _officialCoreMlActive;

  bool _coreMlOverrideAllowed = false;
  bool get coreMlOverrideAllowed => _coreMlOverrideAllowed;

  bool _coreMlSwitchBusy = false;
  bool get coreMlSwitchBusy => _coreMlSwitchBusy;

  String? _coreMlSwitchStatus;
  String? get coreMlSwitchStatus => _coreMlSwitchStatus;

  StreamSubscription<double>? _progressSub;
  StreamSubscription<Map<String, dynamic>>? _eventsSub;
  StreamSubscription<PlayerState>? _referencePlayerSub;
  Timer? _elapsedTimer;
  AudioPlayer? _referencePlayer;
  bool _referencePlaying = false;
  double _referenceSpeed = 1.0;
  double _referenceVolume = 1.0;
  QuranRepeatMode _referenceRepeatMode = QuranRepeatMode.off;
  bool _disposed = false;

  bool get referencePlaying => _referencePlaying;
  double get referenceSpeed => _referenceSpeed;
  double get referenceVolume => _referenceVolume;
  QuranRepeatMode get referenceRepeatMode => _referenceRepeatMode;

  static bool get _showIosCoreMlToggle =>
      kDebugMode && !kIsWeb && Platform.isIOS;

  Future<void> start() async {
    _stage = TajweedFlowStage.checkingModel;
    _notify();
    unawaited(_loadReferenceAudioPrefs());

    if (!args.freePreview) {
      final enabled = await StorageService.tajweedEnabled;
      if (_disposed) return;
      if (!enabled) {
        _stage = TajweedFlowStage.downloadFailed;
        _errorCode = TajweedErrorCode.featureDisabled;
        _errorMessage = null;
        _notify();
        return;
      }
    } else {
      TajweedService.setFreePreviewSession(true);
    }

    _eventsSub ??= TajweedService.events().listen(_onNativeEvent);
    await _bootstrapModel();
  }

  /// Install / warm-load orchestration. Install UI only when the pack is
  /// missing; otherwise spinner → ready (no 0% flash, no reinstall chrome).
  /// Navigates to [TajweedFlowStage.recordingReady] only after prepare succeeds.
  Future<void> _bootstrapModel({bool forceInstallUi = false}) async {
    if (_disposed) return;
    _errorMessage = null;
    _errorCode = null;

    // Pack still bound from an earlier ayah / screen — skip install + ensure.
    if (!forceInstallUi && await TajweedModelSession.isReadyForInference()) {
      if (_disposed) return;
      _downloadProgress = 1;
      _stage = TajweedFlowStage.recordingReady;
      _notify();
      unawaited(_refreshActiveCoreMlInfo());
      return;
    }
    if (_disposed) return;

    var onDisk = false;
    try {
      onDisk = await TajweedService.isAvailable();
    } catch (_) {
      onDisk = false;
    }
    if (_disposed) return;

    final showInstallUi =
        forceInstallUi || (!onDisk && !TajweedModelSession.ready);

    if (showInstallUi) {
      _stage = TajweedFlowStage.downloadingModel;
      _downloadProgress = 0;
      _notify();
      _attachProgressListener();
    } else {
      // Pack already on disk — checking spinner only, never download at 0%.
      _stage = TajweedFlowStage.checkingModel;
      _downloadProgress = 1;
      _notify();
    }

    void afterEnsure() {
      if (_disposed) return;
      _downloadProgress = 1;
      // Leave download chrome before prepare so we never sit at 100% stuck.
      if (_stage == TajweedFlowStage.downloadingModel) {
        _stage = TajweedFlowStage.checkingModel;
      }
      _notify();
    }

    try {
      // Joins the single process-wide ensure+prepare Future when in flight.
      await TajweedModelSession.ensurePrepared(onAfterEnsure: afterEnsure);
      if (_disposed) return;
      if (!TajweedModelSession.ready) {
        // Should not happen — ensurePrepared only completes without throw when ready.
        _stage = TajweedFlowStage.downloadFailed;
        _errorCode = TajweedErrorCode.modelLoadFailed;
        _errorMessage = null;
        _notify();
        return;
      }
      _downloadProgress = 1;
      _stage = TajweedFlowStage.recordingReady;
      await _refreshActiveCoreMlInfo();
    } on TajweedException catch (e) {
      if (_disposed) return;
      _stage = TajweedFlowStage.downloadFailed;
      _errorCode = e.code;
      _errorMessage = _friendlyMessage(e);
    } catch (e) {
      if (_disposed) return;
      _stage = TajweedFlowStage.downloadFailed;
      _errorCode = TajweedErrorCode.modelLoadFailed;
      _errorMessage = null;
    }
    _notify();
  }

  void _attachProgressListener() {
    _progressSub ??= TajweedService.downloadProgress().listen((p) {
      if (_disposed) return;
      // Never flash backwards (e.g. late 0 event after success).
      if (p > _downloadProgress) {
        _downloadProgress = p;
        _notify();
      }
    });
  }

  Future<void> retryDownload() async {
    // prepare/ensure already cleared ready on failure — do not wipe a healthy
    // session. Only force the install chrome when the pack is still missing.
    var onDisk = false;
    try {
      onDisk = await TajweedService.isAvailable();
    } catch (_) {
      onDisk = false;
    }
    await _bootstrapModel(forceInstallUi: !onDisk);
  }

  Future<void> _refreshActiveCoreMlInfo() async {
    if (!_showIosCoreMlToggle) return;
    try {
      _coreMlOverrideAllowed =
          await TajweedService.isDevCoreMlOverrideAllowed();
      final info = await TajweedService.getActiveCoreMlInfo();
      final api = (info['encoderApi'] as String?) ??
          (info['resolvedApi'] as String?) ??
          '';
      final encoder = (info['encoder'] as String?) ?? '';
      final version = (info['version'] as String?) ?? '';
      _officialCoreMlActive = api != 'single_function_fixed' &&
          !encoder.contains('diy-');
      _activeCoreMlLabel = _officialCoreMlActive
          ? 'Official HF CoreML  ·  $version'
          : 'DIY CoreML  ·  $version';
      if (encoder.isNotEmpty) {
        _activeCoreMlLabel = '$_activeCoreMlLabel\n$encoder';
      }
    } catch (_) {
      _activeCoreMlLabel = 'Model info unavailable';
    }
    _notify();
  }

  /// DEBUG iOS: toggle Official (on) vs DIY (off). Downloads/activates then
  /// warm-loads so the next recording uses that pack.
  Future<void> setOfficialCoreMlEnabled(bool useOfficial) async {
    if (!_showIosCoreMlToggle || _coreMlSwitchBusy) return;
    if (!_coreMlOverrideAllowed) {
      _coreMlSwitchStatus =
          'Need a Debug rebuild (overrideAllowed=false). flutter clean && flutter run';
      _notify();
      return;
    }

    _coreMlSwitchBusy = true;
    _coreMlSwitchStatus = useOfficial
        ? 'Downloading Official HF CoreML (~261 MB)…'
        : 'Downloading DIY CoreML (~159 MB)…';
    _downloadProgress = 0;
    TajweedModelSession.invalidateBecauseDevSourceSwitch();
    _notify();

    _attachProgressListener();

    try {
      await TajweedService.setDevCoreMlSource(useOfficial ? 'official' : 'diy');
      await TajweedModelSession.ensurePrepared(
        onAfterEnsure: () {
          if (_disposed) return;
          _downloadProgress = 1;
          _notify();
        },
      );
      if (!TajweedModelSession.ready) {
        _coreMlSwitchStatus = 'Model prepare did not complete';
        await _refreshActiveCoreMlInfo();
        return;
      }
      await _refreshActiveCoreMlInfo();
      _coreMlSwitchStatus = useOfficial
          ? 'Active: Official HF — ready to record'
          : 'Active: DIY — ready to record';
      _downloadProgress = 1;
    } on TajweedException catch (e) {
      _coreMlSwitchStatus = _friendlyMessage(e);
      await _refreshActiveCoreMlInfo();
    } catch (e) {
      _coreMlSwitchStatus = 'Switch failed: $e';
      await _refreshActiveCoreMlInfo();
    } finally {
      _coreMlSwitchBusy = false;
      _notify();
    }
  }

  Future<void> toggleRecording() async {
    if (_actionInFlight) return;
    if (_stage == TajweedFlowStage.recording) {
      await _stopAndScore();
    } else if (_stage == TajweedFlowStage.recordingReady) {
      await _startRecording();
    }
  }

  Future<void> _loadReferenceAudioPrefs() async {
    final results = await Future.wait<Object>([
      StorageService.quranPlaybackSpeed,
      StorageService.quranPlaybackVolume,
      StorageService.quranRepeatMode,
    ]);
    if (_disposed) return;
    _referenceSpeed = results[0] as double;
    _referenceVolume = results[1] as double;
    _referenceRepeatMode = QuranRepeatMode.fromName(results[2] as String);
    _notify();
  }

  Future<void> setReferenceSpeed(double speed) async {
    _referenceSpeed = speed;
    _notify();
    final player = _referencePlayer;
    if (player != null) {
      try {
        await player.setSpeed(speed);
      } catch (_) {}
    }
    await StorageService.setQuranPlaybackSpeed(speed);
  }

  Future<void> setReferenceVolume(double volume) async {
    _referenceVolume = volume;
    _notify();
    final player = _referencePlayer;
    if (player != null) {
      try {
        await player.setVolume(volume);
      } catch (_) {}
    }
    await StorageService.setQuranPlaybackVolume(volume);
  }

  Future<void> setReferenceRepeatMode(QuranRepeatMode mode) async {
    _referenceRepeatMode = mode;
    _notify();
    final player = _referencePlayer;
    if (player != null) {
      try {
        await _applyReferenceLoopMode(player, mode);
      } catch (_) {}
    }
    await StorageService.setQuranRepeatMode(mode.name);
  }

  Future<void> _applyReferenceLoopMode(
    AudioPlayer player,
    QuranRepeatMode mode,
  ) async {
    switch (mode) {
      case QuranRepeatMode.off:
        await player.setLoopMode(LoopMode.off);
      case QuranRepeatMode.ayah:
      case QuranRepeatMode.surah:
        // Single-ayah reference: both ayah and surah repeat loop this clip.
        await player.setLoopMode(LoopMode.one);
    }
  }

  Future<void> toggleReferenceAudio() async {
    if (_stage == TajweedFlowStage.recording) return;
    final player = _referencePlayer;
    if (player != null) {
      if (_referencePlaying) {
        try {
          await player.pause();
        } catch (_) {}
        _referencePlaying = false;
        _notify();
        return;
      }
      try {
        if (player.processingState == ProcessingState.completed) {
          await player.seek(Duration.zero);
        }
        await player.play();
        _referencePlaying = true;
        _notify();
      } catch (e) {
        _recordingBanner = 'Could not play reference recitation: $e';
        await stopReferenceAudio();
        _notify();
      }
      return;
    }
    await _startReferenceAudio();
  }

  Future<void> _startReferenceAudio() async {
    if (_stage == TajweedFlowStage.recording) return;
    await stopReferenceAudio();
    try {
      final player = AudioPlayer();
      _referencePlayer = player;
      await player.setVolume(_referenceVolume);
      await player.setSpeed(_referenceSpeed);
      await player.setUrl(
        QuranRecitation.audioUrl(args.surah, args.ayah),
      );
      // Apply after setUrl — some platforms reset loop mode on source load.
      await _applyReferenceLoopMode(player, _referenceRepeatMode);
      _referencePlayerSub = player.playerStateStream.listen((state) {
        if (_disposed) return;
        if (state.processingState == ProcessingState.completed) {
          // Pause before seek: seek-while-playing after completed restarts
          // the clip and looks like a loop even with LoopMode.off.
          unawaited(_onReferencePlaybackCompleted(player));
          return;
        }
        final playing = state.playing;
        if (playing != _referencePlaying) {
          _referencePlaying = playing;
          _notify();
        }
      });
      await player.play();
      _referencePlaying = true;
      _notify();
    } catch (e) {
      _recordingBanner = 'Could not play reference recitation: $e';
      await stopReferenceAudio();
      _notify();
    }
  }

  Future<void> _onReferencePlaybackCompleted(AudioPlayer player) async {
    if (_disposed || !identical(_referencePlayer, player)) return;
    try {
      await player.pause();
      await player.seek(Duration.zero);
    } catch (_) {}
    if (_disposed || !identical(_referencePlayer, player)) return;
    _referencePlaying = false;
    _notify();
  }

  Future<void> stopReferenceAudio() async {
    _referencePlaying = false;
    await _referencePlayerSub?.cancel();
    _referencePlayerSub = null;
    final player = _referencePlayer;
    _referencePlayer = null;
    if (player != null) {
      try {
        await player.stop();
        await player.dispose();
      } catch (_) {}
    }
    _notify();
  }

  Future<void> _startRecording() async {
    _actionInFlight = true;
    _recordingBanner = null;
    _micPermissionDenied = false;
    _notify();

    try {
      await stopReferenceAudio();
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
        lexicalReferenceArabic: args.lexicalReferenceArabic,
      );
      _stage = TajweedFlowStage.recording;
      _startElapsedTimer();
    } on TajweedException catch (e) {
      _recordingBanner = _friendlyMessage(e);
    } catch (e) {
      _recordingBanner = 'Could not start recording: $e';
    } finally {
      _actionInFlight = false;
      _notify();
    }
  }

  Future<void> _stopAndScore() async {
    _actionInFlight = true;
    _stopElapsedTimer();
    _stage = TajweedFlowStage.scoring;
    _notify();

    final e2e = Stopwatch()..start();
    try {
      final score = await TajweedService.stopRecordingAndScore();
      final flutterCallbackMs = e2e.elapsedMilliseconds.toDouble();

      final uiApply = Stopwatch()..start();
      _result = score;
      _stage = TajweedFlowStage.result;
      _notify();
      final flutterUiApplyMs = uiApply.elapsedMilliseconds.toDouble();

      final timings = Map<String, double>.from(score.timingsMs);
      timings['flutterCallbackMs'] = flutterCallbackMs;
      timings['flutterUiApplyMs'] = flutterUiApplyMs;
      timings['flutterEndToEndMs'] = e2e.elapsedMilliseconds.toDouble();

      // First frame after result stage — approximates UI render cost.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        timings['flutterUiFirstFrameMs'] =
            e2e.elapsedMilliseconds.toDouble() - flutterCallbackMs;
        timings['flutterEndToEndMs'] = e2e.elapsedMilliseconds.toDouble();
        _logE2ETimings(timings, score.modelInfo);
      });

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
      _notify();
    }
  }

  void _logE2ETimings(Map<String, double> t, Map<String, dynamic> model) {
    final keys = <String>[
      'microphoneStopMs',
      'vadEndOfSpeechWaitMs',
      'audioValidateMs',
      'audioFileWriteMs',
      'melFrontendMs',
      'audioPaddingMs',
      'coremlModelObtainMs',
      'coremlInputCopyMs',
      'coremlEncoderMs',
      'coremlOutputParseMs',
      'ctcDecodingMs',
      'lexicalAlignmentMs',
      'pronunciationHeadMs',
      'scorePipelineMs',
      'totalPipelineMs',
      'nativeEndToEndMs',
      'flutterCallbackMs',
      'flutterUiApplyMs',
      'flutterUiFirstFrameMs',
      'flutterEndToEndMs',
    ];
    final parts = keys
        .where((k) => t.containsKey(k))
        .map((k) => '$k=${t[k]!.toStringAsFixed(1)}')
        .join(' ');
    debugPrint(
      '[TajweedE2E] coldLoad=${model['modelWasColdLoad']} '
      'api=${model['encoderApi']} function=${model['encoderFunctionName']} $parts',
    );
  }

  Future<void> cancelRecording() async {
    _stopElapsedTimer();
    try {
      await TajweedService.cancelRecording();
    } catch (_) {
      // Best-effort — fall through to idle regardless.
    }
    _stage = TajweedFlowStage.recordingReady;
    _notify();
  }

  void tryAgain() {
    _result = null;
    _recordingBanner = null;
    _stage = TajweedFlowStage.recordingReady;
    _notify();
  }

  void _startElapsedTimer() {
    _recordingElapsed = Duration.zero;
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordingElapsed += const Duration(seconds: 1);
      _notify();
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
          _notify();
        }
      case TajweedEventType.modelUnloaded:
        // Memory-pressure cleanup on the native side; next startRecording()
        // transparently reloads the model (warm-load path), no UI action needed.
        // Session stays "ready" for UI purposes (pack still on disk).
        break;
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
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
    _disposed = true;
    if (args.freePreview) {
      TajweedService.setFreePreviewSession(false);
    }
    _stopElapsedTimer();
    _progressSub?.cancel();
    _eventsSub?.cancel();
    unawaited(stopReferenceAudio());
    if (_stage == TajweedFlowStage.recording ||
        _stage == TajweedFlowStage.scoring) {
      unawaited(TajweedService.cancelRecording().catchError((_) {}));
    }
    super.dispose();
  }
}
