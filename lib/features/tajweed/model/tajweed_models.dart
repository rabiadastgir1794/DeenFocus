// Shared Tajweed models — MethodChannel JSON + local history.
// See `memory/decisions/ADR-006-tajweed-cross-platform-contract.md`.

/// Stable native error codes (identical on iOS and Android). Add-only; never rename.
abstract final class TajweedErrorCode {
  static const featureDisabled = 'FEATURE_DISABLED';
  static const micPermissionDenied = 'MIC_PERMISSION_DENIED';
  static const micBusy = 'MIC_BUSY';
  static const notRecording = 'NOT_RECORDING';
  static const alreadyRecording = 'ALREADY_RECORDING';
  static const audioTooShort = 'AUDIO_TOO_SHORT';
  static const audioTooLong = 'AUDIO_TOO_LONG';
  static const audioQualityPoor = 'AUDIO_QUALITY_POOR';
  static const modelMissing = 'MODEL_MISSING';
  static const modelDownloadFailed = 'MODEL_DOWNLOAD_FAILED';
  static const modelLoadFailed = 'MODEL_LOAD_FAILED';
  static const inferenceFailed = 'INFERENCE_FAILED';
  static const inferenceCancelled = 'INFERENCE_CANCELLED';
  static const interrupted = 'INTERRUPTED';
  static const unsupported = 'UNSUPPORTED';
  static const invalidArgs = 'INVALID_ARGS';
}

enum TajweedRecordingState {
  idle,
  recording,
  scoring,
  cancelling;

  static TajweedRecordingState fromName(String? raw) {
    switch (raw) {
      case 'recording':
        return TajweedRecordingState.recording;
      case 'scoring':
        return TajweedRecordingState.scoring;
      case 'cancelling':
        return TajweedRecordingState.cancelling;
      case 'idle':
      default:
        return TajweedRecordingState.idle;
    }
  }

  String get wireName => name;
}

enum TajweedTokenStatus {
  ok,
  minor,
  major,
  sub,
  miss,
  extra;

  static TajweedTokenStatus fromName(String? raw) {
    switch (raw) {
      case 'minor':
        return TajweedTokenStatus.minor;
      case 'major':
        return TajweedTokenStatus.major;
      case 'sub':
        return TajweedTokenStatus.sub;
      case 'miss':
        return TajweedTokenStatus.miss;
      case 'extra':
        return TajweedTokenStatus.extra;
      case 'ok':
      default:
        return TajweedTokenStatus.ok;
    }
  }

  String get wireName => name;
}

class TajweedException implements Exception {
  const TajweedException({
    required this.code,
    this.message,
    this.details,
  });

  final String code;
  final String? message;
  final Object? details;

  @override
  String toString() =>
      'TajweedException($code${message == null ? '' : ': $message'})';
}

class TajweedToken {
  const TajweedToken({
    required this.text,
    required this.status,
    this.prob,
    this.startSec,
    this.endSec,
    this.lexical,
    this.pronunciation,
  });

  final String text;
  final TajweedTokenStatus status;
  final double? prob;
  final double? startSec;
  final double? endSec;

  /// Lexical identity: `match` | `sub` | `miss` | `extra` (ADR-006 additive).
  final String? lexical;

  /// Pronunciation quality for matched words only: `ok` | `minor` | `major`.
  final String? pronunciation;

  factory TajweedToken.fromJson(Map<String, dynamic> json) {
    return TajweedToken(
      text: json['text'] as String? ?? '',
      status: TajweedTokenStatus.fromName(json['status'] as String?),
      prob: (json['prob'] as num?)?.toDouble(),
      startSec: (json['startSec'] as num?)?.toDouble(),
      endSec: (json['endSec'] as num?)?.toDouble(),
      lexical: json['lexical'] as String?,
      pronunciation: json['pronunciation'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'text': text,
    'status': status.wireName,
    if (prob != null) 'prob': prob,
    if (startSec != null) 'startSec': startSec,
    if (endSec != null) 'endSec': endSec,
    if (lexical != null) 'lexical': lexical,
    if (pronunciation != null) 'pronunciation': pronunciation,
  };
}

class TajweedScoreResult {
  const TajweedScoreResult({
    required this.ref,
    required this.expected,
    required this.hypothesis,
    required this.durationSec,
    required this.wordAccuracy,
    required this.exactMatch,
    required this.tokens,
    this.timingsMs = const <String, double>{},
    this.modelInfo = const <String, dynamic>{},
  });

  final String ref;
  final String expected;
  final String hypothesis;
  final double durationSec;
  final double wordAccuracy;
  final bool exactMatch;
  final List<TajweedToken> tokens;
  /// Native + Flutter end-to-end stage timings (ms). Instrumentation only.
  final Map<String, double> timingsMs;
  final Map<String, dynamic> modelInfo;

  factory TajweedScoreResult.fromJson(Map<String, dynamic> json) {
    final rawTokens = json['tokens'];
    final tokens = <TajweedToken>[];
    if (rawTokens is List) {
      for (final item in rawTokens) {
        if (item is Map) {
          tokens.add(
            TajweedToken.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
    return TajweedScoreResult(
      ref: json['ref'] as String? ?? '',
      expected: json['expected'] as String? ?? '',
      hypothesis: json['hypothesis'] as String? ?? '',
      durationSec: (json['durationSec'] as num?)?.toDouble() ?? 0,
      wordAccuracy: (json['wordAccuracy'] as num?)?.toDouble() ?? 0,
      exactMatch: json['exactMatch'] as bool? ?? false,
      tokens: tokens,
      timingsMs: _doubleMap(json['timingsMs']),
      modelInfo: json['modelInfo'] is Map
          ? Map<String, dynamic>.from(json['modelInfo'] as Map)
          : const <String, dynamic>{},
    );
  }

  static Map<String, double> _doubleMap(Object? raw) {
    if (raw is! Map) return const <String, double>{};
    final out = <String, double>{};
    for (final e in raw.entries) {
      final v = e.value;
      if (v is num) out['${e.key}'] = v.toDouble();
    }
    return out;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'ref': ref,
    'expected': expected,
    'hypothesis': hypothesis,
    'durationSec': durationSec,
    'wordAccuracy': wordAccuracy,
    'exactMatch': exactMatch,
    'tokens': tokens.map((t) => t.toJson()).toList(),
    if (timingsMs.isNotEmpty) 'timingsMs': timingsMs,
    if (modelInfo.isNotEmpty) 'modelInfo': modelInfo,
  };

  TajweedTokenSummary get tokenSummary => TajweedTokenSummary.fromTokens(tokens);
}

class TajweedTokenSummary {
  const TajweedTokenSummary({
    required this.ok,
    required this.minor,
    required this.major,
    required this.sub,
    required this.miss,
    required this.extra,
  });

  final int ok;
  final int minor;
  final int major;
  final int sub;
  final int miss;
  final int extra;

  factory TajweedTokenSummary.fromTokens(List<TajweedToken> tokens) {
    var ok = 0, minor = 0, major = 0, sub = 0, miss = 0, extra = 0;
    for (final t in tokens) {
      switch (t.status) {
        case TajweedTokenStatus.ok:
          ok++;
        case TajweedTokenStatus.minor:
          minor++;
        case TajweedTokenStatus.major:
          major++;
        case TajweedTokenStatus.sub:
          sub++;
        case TajweedTokenStatus.miss:
          miss++;
        case TajweedTokenStatus.extra:
          extra++;
      }
    }
    return TajweedTokenSummary(
      ok: ok,
      minor: minor,
      major: major,
      sub: sub,
      miss: miss,
      extra: extra,
    );
  }

  factory TajweedTokenSummary.fromJson(Map<String, dynamic> json) {
    return TajweedTokenSummary(
      ok: json['ok'] as int? ?? 0,
      minor: json['minor'] as int? ?? 0,
      major: json['major'] as int? ?? 0,
      sub: json['sub'] as int? ?? 0,
      miss: json['miss'] as int? ?? 0,
      extra: json['extra'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'ok': ok,
    'minor': minor,
    'major': major,
    'sub': sub,
    'miss': miss,
    'extra': extra,
  };
}

/// Local practice history row — scores only, never PCM.
class TajweedHistoryEntry {
  const TajweedHistoryEntry({
    required this.id,
    required this.surah,
    required this.ayah,
    required this.ref,
    required this.practicedAt,
    required this.durationSec,
    required this.wordAccuracy,
    required this.exactMatch,
    required this.tokenSummary,
  });

  final String id;
  final int surah;
  final int ayah;
  final String ref;
  final DateTime practicedAt;
  final double durationSec;
  final double wordAccuracy;
  final bool exactMatch;
  final TajweedTokenSummary tokenSummary;

  factory TajweedHistoryEntry.fromScore({
    required int surah,
    required int ayah,
    required TajweedScoreResult score,
    DateTime? practicedAt,
  }) {
    final at = practicedAt ?? DateTime.now().toUtc();
    return TajweedHistoryEntry(
      id: '${at.microsecondsSinceEpoch}_${surah}_$ayah',
      surah: surah,
      ayah: ayah,
      ref: score.ref.isEmpty ? '$surah:$ayah' : score.ref,
      practicedAt: at,
      durationSec: score.durationSec,
      wordAccuracy: score.wordAccuracy,
      exactMatch: score.exactMatch,
      tokenSummary: score.tokenSummary,
    );
  }

  factory TajweedHistoryEntry.fromJson(Map<String, dynamic> json) {
    return TajweedHistoryEntry(
      id: json['id'] as String? ?? '',
      surah: json['surah'] as int? ?? 0,
      ayah: json['ayah'] as int? ?? 0,
      ref: json['ref'] as String? ?? '',
      practicedAt:
          DateTime.tryParse(json['practicedAt'] as String? ?? '')?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      durationSec: (json['durationSec'] as num?)?.toDouble() ?? 0,
      wordAccuracy: (json['wordAccuracy'] as num?)?.toDouble() ?? 0,
      exactMatch: json['exactMatch'] as bool? ?? false,
      tokenSummary: TajweedTokenSummary.fromJson(
        Map<String, dynamic>.from(
          (json['tokenSummary'] as Map?) ?? const <String, dynamic>{},
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'surah': surah,
    'ayah': ayah,
    'ref': ref,
    'practicedAt': practicedAt.toUtc().toIso8601String(),
    'durationSec': durationSec,
    'wordAccuracy': wordAccuracy,
    'exactMatch': exactMatch,
    'tokenSummary': tokenSummary.toJson(),
  };
}

/// EventChannel envelope types used by `TajweedService`.
abstract final class TajweedEventType {
  static const downloadProgress = 'downloadProgress';
  static const recordingState = 'recordingState';
  static const interrupted = 'interrupted';
  static const modelUnloaded = 'modelUnloaded';
  static const pipelineTimings = 'pipelineTimings';
}
