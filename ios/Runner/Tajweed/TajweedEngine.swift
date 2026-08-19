import AVFoundation
import Foundation
import UIKit

/// Orchestrates native record → mel → CoreML ASR → CTC → align → head → JSON.
final class TajweedEngine {
  static let shared = TajweedEngine()

  private let workQueue = DispatchQueue(label: "com.rnr.deenfocus.tajweed.engine", qos: .userInitiated)
  /// Specialized CoreML preload must not sit on `workQueue` or it serializes
  /// behind/ahead of startRecording/score and re-blocks the UI path.
  private let preloadQueue = DispatchQueue(
    label: "com.rnr.deenfocus.tajweed.coreml-preload",
    qos: .utility
  )
  private let stateLock = NSLock()

  private let recorder = TajweedAudioRecorder()
  private let asr = OfflineAsrModel()
  private let head = PronunciationHeadModel()
  private var tokenizer: SentencePieceTokenizer?
  private var loadedTokensPath: String?

  private var state: TajweedRecordingState = .idle
  private var expectedArabic: String = ""
  /// Canonical boundary text (usually Uthmani) for `TajweedLexicalScoring.lexicalWords`.
  private var lexicalReferenceArabic: String = ""
  private var surah: Int = 0
  private var ayah: Int = 0
  private var cancelled = false
  /// Active encoder SHA from manifest when ASR specialized models were last bound.
  /// Detects in-place Official↔DIY swaps that keep the same filesystem path.
  private var loadedEncoderSha: String?

  var onEvent: (([String: Any]) -> Void)?

  private init() {
    recorder.onInterrupted = { [weak self] reason in
      self?.handleInterruption(reason: reason)
    }
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(memoryWarning),
      name: UIApplication.didReceiveMemoryWarningNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appBackground),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )
  }

  func getRecordingState() -> String {
    stateLock.lock()
    defer { stateLock.unlock() }
    return state.rawValue
  }

  /// Test/debug visibility only — true once ASR + head + tokenizer are warm-loaded.
  var isWarmedUpForTesting: Bool {
    tokenizer != nil && asr.isLoaded && head.isLoaded
  }

  func isAvailable() -> Bool {
    ModelStore.shared.isAvailable()
  }

  func ensureModel(completion: @escaping (Result<Void, TajweedNativeError>) -> Void) {
    workQueue.async {
      do {
        try self.ensureModelLockedPreferringOfficial()
        completion(.success(()))
      } catch let e as TajweedNativeError {
        completion(.failure(e))
      } catch {
        completion(
          .failure(
            TajweedNativeError(TajweedErrorCode.modelDownloadFailed, error.localizedDescription)
          )
        )
      }
    }
  }

  func prepareModel(completion: @escaping (Result<Void, TajweedNativeError>) -> Void) {
    workQueue.async {
      do {
        try self.warmLoadWithFailoverLocked()
        completion(.success(()))
        self.scheduleBackgroundSpecializedPreload()
      } catch let e as TajweedNativeError {
        completion(.failure(e))
      } catch {
        completion(
          .failure(TajweedNativeError(TajweedErrorCode.modelLoadFailed, error.localizedDescription))
        )
      }
    }
  }

  func startRecording(
    surah: Int,
    ayah: Int,
    expectedArabic: String,
    lexicalReferenceArabic: String? = nil,
    completion: @escaping (Result<Void, TajweedNativeError>) -> Void
  ) {
    workQueue.async {
      self.stateLock.lock()
      if self.state != .idle {
        self.stateLock.unlock()
        completion(
          .failure(TajweedNativeError(TajweedErrorCode.alreadyRecording, "Not idle."))
        )
        return
      }
      self.stateLock.unlock()

      do {
        try self.warmLoadWithFailoverLocked()
      } catch let e as TajweedNativeError {
        completion(.failure(e))
        return
      } catch {
        completion(
          .failure(TajweedNativeError(TajweedErrorCode.modelLoadFailed, error.localizedDescription))
        )
        return
      }

      AVAudioSession.sharedInstance().requestRecordPermission { granted in
        self.workQueue.async {
          guard granted else {
            completion(
              .failure(
                TajweedNativeError(
                  TajweedErrorCode.micPermissionDenied,
                  "Microphone permission denied."
                )
              )
            )
            return
          }
          do {
            self.cancelled = false
            self.surah = surah
            self.ayah = ayah
            self.expectedArabic = expectedArabic
            self.lexicalReferenceArabic =
              (lexicalReferenceArabic?.isEmpty == false)
              ? lexicalReferenceArabic!
              : expectedArabic
            try self.recorder.start()
            self.setState(.recording)
            completion(.success(()))
          } catch let e as TajweedNativeError {
            completion(.failure(e))
          } catch {
            completion(
              .failure(TajweedNativeError(TajweedErrorCode.micBusy, error.localizedDescription))
            )
          }
        }
      }
    }
  }

  func stopRecordingAndScore(completion: @escaping (Result<[String: Any], TajweedNativeError>) -> Void) {
    let e2eT0 = CFAbsoluteTimeGetCurrent()
    workQueue.async {
      var e2eTimings: [String: Double] = [:]
      // No VAD / end-of-speech wait — user taps stop. Keep explicit zero for reports.
      e2eTimings["vadEndOfSpeechWaitMs"] = 0

      self.stateLock.lock()
      guard self.state == .recording else {
        self.stateLock.unlock()
        completion(
          .failure(TajweedNativeError(TajweedErrorCode.notRecording, "Not recording."))
        )
        return
      }
      self.state = .scoring
      self.stateLock.unlock()
      self.emit(["type": "recordingState", "state": "scoring"])

      let tMic0 = CFAbsoluteTimeGetCurrent()
      let pcm = self.recorder.stop()
      e2eTimings["microphoneStopMs"] = (CFAbsoluteTimeGetCurrent() - tMic0) * 1000

      if self.cancelled {
        self.setState(.idle)
        completion(
          .failure(
            TajweedNativeError(TajweedErrorCode.inferenceCancelled, "Cancelled.")
          )
        )
        return
      }

      do {
        let tVal0 = CFAbsoluteTimeGetCurrent()
        try self.validateAudioQuality(pcm)
        e2eTimings["audioValidateMs"] = (CFAbsoluteTimeGetCurrent() - tVal0) * 1000

        var report = try self.scoreWithFailover(pcm: pcm)
        if var timings = report["timingsMs"] as? [String: Double] {
          for (k, v) in e2eTimings { timings[k] = v }
          timings["nativeEndToEndMs"] = (CFAbsoluteTimeGetCurrent() - e2eT0) * 1000
          report["timingsMs"] = timings
          self.logEndToEndTimings(timings, modelInfo: report["modelInfo"] as? [String: Any])
          self.emit([
            "type": "pipelineTimings",
            "timingsMs": timings,
            "modelInfo": report["modelInfo"] as Any,
          ])
        }
        self.setState(.idle)
        // Mark when native is about to hand back to Flutter (callback latency measured in Dart).
        report["nativeCompletedAtMs"] = Date().timeIntervalSince1970 * 1000
        completion(.success(report))
      } catch let e as TajweedNativeError {
        self.setState(.idle)
        completion(.failure(e))
      } catch {
        self.setState(.idle)
        completion(
          .failure(TajweedNativeError(TajweedErrorCode.inferenceFailed, error.localizedDescription))
        )
      }
    }
  }

  private func logEndToEndTimings(_ t: [String: Double], modelInfo: [String: Any]?) {
    func ms(_ key: String) -> Double { t[key] ?? 0 }
    func sum(_ keys: [String]) -> Double {
      var total: Double = 0
      for key in keys { total += ms(key) }
      return total
    }

    let scoreStageKeys = [
      "melFrontendMs",
      "audioPaddingMs",
      "coremlModelObtainMs",
      "coremlInputCopyMs",
      "coremlEncoderMs",
      "coremlOutputParseMs",
      "ctcDecodingMs",
      "lexicalAlignmentMs",
      "pronunciationHeadMs",
    ]
    let e2eKeys = [
      "microphoneStopMs",
      "vadEndOfSpeechWaitMs",
      "audioValidateMs",
      "audioFileWriteMs",
    ] + scoreStageKeys

    let accounted = sum(e2eKeys)
    let scoreStages = sum(scoreStageKeys)
    let scoreTotal = t["scorePipelineMs"] ?? t["totalPipelineMs"] ?? 0
    let gapInsideScore = scoreTotal - scoreStages

    let api = (modelInfo?["encoderApi"] as? String) ?? "?"
    let function = (modelInfo?["encoderFunctionName"] as? String) ?? "?"
    let cold = String(describing: modelInfo?["modelWasColdLoad"] ?? "?")

    NSLog(
      "[TajweedE2E] model=%@ function=%@ coldLoad=%@ micStop=%.1f vad=%.1f validate=%.1f wavWrite=%.1f mel=%.1f pad=%.1f modelObtain=%.1f inputCopy=%.1f encoder=%.1f outParse=%.1f ctc=%.1f lexical=%.1f pron=%.1f scoreTotal=%.1f scoreUnaccounted=%.1f nativeE2E=%.1f accounted=%.1f",
      api,
      function,
      cold,
      ms("microphoneStopMs"),
      ms("vadEndOfSpeechWaitMs"),
      ms("audioValidateMs"),
      ms("audioFileWriteMs"),
      ms("melFrontendMs"),
      ms("audioPaddingMs"),
      ms("coremlModelObtainMs"),
      ms("coremlInputCopyMs"),
      ms("coremlEncoderMs"),
      ms("coremlOutputParseMs"),
      ms("ctcDecodingMs"),
      ms("lexicalAlignmentMs"),
      ms("pronunciationHeadMs"),
      scoreTotal,
      gapInsideScore,
      ms("nativeEndToEndMs"),
      accounted
    )
  }

  func cancelRecording(completion: @escaping (Result<Void, TajweedNativeError>) -> Void) {
    workQueue.async {
      self.stateLock.lock()
      let current = self.state
      self.state = .cancelling
      self.stateLock.unlock()
      self.emit(["type": "recordingState", "state": "cancelling"])
      self.cancelled = true
      self.recorder.cancel()
      self.setState(.idle)
      if current == .idle {
        completion(.failure(TajweedNativeError(TajweedErrorCode.notRecording, "Not recording.")))
      } else {
        completion(.success(()))
      }
    }
  }

  func dispose() {
    workQueue.async {
      self.cancelled = true
      self.recorder.cancel()
      self.asr.unload()
      self.head.unload()
      self.tokenizer = nil
      self.loadedTokensPath = nil
      self.loadedEncoderSha = nil
      self.setState(.idle)
      self.emit(["type": "modelUnloaded"])
    }
  }

  // MARK: - Scoring pipeline

  private func score(pcm: [Float]) throws -> [String: Any] {
    let pipelineT0 = CFAbsoluteTimeGetCurrent()
    var timingsMs: [String: Double] = [:]

    let duration = Double(pcm.count) / Double(MelFrontend.sampleRate)
    let audioEdge = Self.audioEdgeEnergy(pcm)
    timingsMs["audioLeadingAbsMean"] = audioEdge.leadingAbsMean
    timingsMs["audioTrailingAbsMean"] = audioEdge.trailingAbsMean
    timingsMs["audioMidAbsMean"] = audioEdge.midAbsMean
    NSLog(
      "[TajweedAudio] samples=%d dur=%.2fs peak=%.3f leadAbsMean=%.5f midAbsMean=%.5f trailAbsMean=%.5f leadSilent50ms=%@ trailSilent50ms=%@ (no VAD/trim — full buffer scored)",
      pcm.count,
      duration,
      audioEdge.peak,
      audioEdge.leadingAbsMean,
      audioEdge.midAbsMean,
      audioEdge.trailingAbsMean,
      audioEdge.leadingSilent ? "YES" : "NO",
      audioEdge.trailingSilent ? "YES" : "NO"
    )

    let tMel0 = CFAbsoluteTimeGetCurrent()
    let (feats, time) = try MelFrontend.logMel(pcm: pcm)
    timingsMs["melFrontendMs"] = (CFAbsoluteTimeGetCurrent() - tMel0) * 1000

    let asrOut = try asr.predict(mel: feats, time: time)
    timingsMs["audioPaddingMs"] = asrOut.padMs
    timingsMs["coremlModelObtainMs"] = asrOut.modelObtainMs
    timingsMs["coremlInputCopyMs"] = asrOut.inputCopyMs
    timingsMs["coremlEncoderMs"] = asrOut.encoderMs
    timingsMs["coremlOutputParseMs"] = asrOut.outputParseMs
    NSLog(
      "[TajweedCoreML] predict function=%@ coldLoad=%@ modelObtainMs=%.1f encoderMs=%.1f cacheSize=%d",
      asrOut.functionName,
      asrOut.modelWasColdLoad ? "YES" : "NO",
      asrOut.modelObtainMs,
      asrOut.encoderMs,
      asr.cachedSpecializedModelCount
    )

    let tCtc0 = CFAbsoluteTimeGetCurrent()
    let argmax = asrOut.logprobs.map { row -> Int in
      var best = 0
      var bestV = -Float.greatestFiniteMagnitude
      for (i, v) in row.enumerated() where v > bestV {
        bestV = v
        best = i
      }
      return best
    }
    let collapsed = CtcDecoder.collapse(argmax)
    guard let tokenizer else {
      throw TajweedNativeError(TajweedErrorCode.modelLoadFailed, "Tokenizer missing.")
    }
    let hypothesis = tokenizer.decode(collapsed)
    timingsMs["ctcDecodingMs"] = (CFAbsoluteTimeGetCurrent() - tCtc0) * 1000

    let reference =
      lexicalReferenceArabic.isEmpty ? expectedArabic : lexicalReferenceArabic
    let hypWords = TajweedLexicalScoring.prepareHypothesisWords(hypothesis)

    let tLex0 = CFAbsoluteTimeGetCurrent()
    let ops: [TajweedLexicalScoring.WordAlignOp]
    let expectedWords: [String]
    let expectedNormForLog: [String]
    let hypNormForLog: [String]
    let lexicalAuthority: String

    if CanonicalLexicalAuthority.productionEnabled {
      NSLog(
        "[TajweedLexical] authority branch=canonical flag=ON ref=%d:%d",
        surah,
        ayah
      )
      guard let canonical = CanonicalLexicalEvaluator.evaluate(
        surah: surah,
        ayah: ayah,
        hypothesisWords: hypWords
      ) else {
        throw TajweedNativeError(
          TajweedErrorCode.inferenceFailed,
          "Canonical lexicon missing for \(surah):\(ayah) (fail closed)."
        )
      }
      ops = canonical.ops
      expectedWords = canonical.expectedCanonical
      expectedNormForLog = canonical.expectedCanonical
      hypNormForLog = canonical.hypCanonical
      lexicalAuthority = "canonical"
    } else {
      NSLog(
        "[TajweedLexical] authority branch=legacy flag=OFF ref=%d:%d",
        surah,
        ayah
      )
      expectedWords = TajweedLexicalScoring.prepareExpectedWords(
        expectedArabic,
        referenceText: reference
      )
      ops = TajweedLexicalScoring.alignWords(expected: expectedWords, hypothesis: hypWords)
      expectedNormForLog = expectedWords.map { TajweedLexicalScoring.normalizeArabic($0) }
      hypNormForLog = hypWords.map { TajweedLexicalScoring.normalizeArabic($0) }
      lexicalAuthority = "legacy"
    }
    timingsMs["lexicalAlignmentMs"] = (CFAbsoluteTimeGetCurrent() - tLex0) * 1000

    let (tokens, faMs, headMs) = buildLexicalFirstTokens(
      ops: ops, hypIds: collapsed, asrOut: asrOut, tokenizer: tokenizer
    )
    timingsMs["ctcForcedAlignMs"] = faMs
    timingsMs["pronunciationHeadInferMs"] = headMs
    // Backward-compatible aggregate (FA + head), matching historical key.
    timingsMs["pronunciationHeadMs"] = faMs + headMs

    timingsMs["scorePipelineMs"] = (CFAbsoluteTimeGetCurrent() - pipelineT0) * 1000
    // Keep old key for continuity with earlier logs.
    timingsMs["totalPipelineMs"] = timingsMs["scorePipelineMs"] ?? 0

    let wordAccuracy = TajweedLexicalScoring.wordAccuracyFromTokens(
      tokens,
      expectedWordCount: expectedWords.count
    )

    // Shadow still compares against a legacy pass (DEBUG) for measurement; never
    // feeds production tokens when canonical authority is on.
    let legacyOpsForShadow: [TajweedLexicalScoring.WordAlignOp]
    if CanonicalLexiconStore.shadowEnabled {
      let legacyExpected = TajweedLexicalScoring.prepareExpectedWords(
        expectedArabic,
        referenceText: reference
      )
      legacyOpsForShadow = TajweedLexicalScoring.alignWords(
        expected: legacyExpected,
        hypothesis: hypWords
      )
    } else {
      legacyOpsForShadow = ops
    }
    let shadowResult = CanonicalLexicalShadow.compare(
      surah: surah,
      ayah: ayah,
      hypWords: hypWords,
      legacyOps: legacyOpsForShadow,
      legacyWordAccuracy: wordAccuracy
    )

    let exact =
      TajweedLexicalScoring.normalizeArabic(hypothesis)
        == TajweedLexicalScoring.normalizeArabic(expectedArabic) && !expectedArabic.isEmpty

    let store = ModelStore.shared
    let modelInfo: [String: Any] = [
      "manifestVersion": store.activeManifestVersion(),
      "encoderSha256": store.activeEncoderSha256(),
      "encoderApi": store.activeEncoderApiLabel(),
      "encoderFunctionName": asrOut.functionName,
      "computeUnits": asrOut.computeUnits,
      "bucketOrFixedT": asrOut.bucketT,
      "encoderPackage": (try? store.encoderURL().lastPathComponent) ?? "",
      "modelWasColdLoad": asrOut.modelWasColdLoad,
      "specializedModelCacheSize": asr.cachedSpecializedModelCount,
    ]

    NSLog(
      "[TajweedPipeline] model version=%@ sha=%@ api=%@ function=%@ computeUnits=%@ bucketT=%d coldLoad=%@ cacheSize=%d",
      modelInfo["manifestVersion"] as? String ?? "",
      modelInfo["encoderSha256"] as? String ?? "",
      modelInfo["encoderApi"] as? String ?? "",
      asrOut.functionName,
      asrOut.computeUnits,
      asrOut.bucketT,
      asrOut.modelWasColdLoad ? "YES" : "NO",
      asr.cachedSpecializedModelCount
    )
    NSLog(
      "[TajweedPipeline] timingsMs mel=%.2f pad=%.2f modelObtain=%.2f inputCopy=%.2f encoder=%.2f outParse=%.2f ctc=%.2f lexical=%.2f fa=%.2f head=%.2f pron=%.2f scoreTotal=%.2f",
      timingsMs["melFrontendMs"] ?? 0,
      timingsMs["audioPaddingMs"] ?? 0,
      timingsMs["coremlModelObtainMs"] ?? 0,
      timingsMs["coremlInputCopyMs"] ?? 0,
      timingsMs["coremlEncoderMs"] ?? 0,
      timingsMs["coremlOutputParseMs"] ?? 0,
      timingsMs["ctcDecodingMs"] ?? 0,
      timingsMs["lexicalAlignmentMs"] ?? 0,
      timingsMs["ctcForcedAlignMs"] ?? 0,
      timingsMs["pronunciationHeadInferMs"] ?? 0,
      timingsMs["pronunciationHeadMs"] ?? 0,
      timingsMs["scorePipelineMs"] ?? 0
    )

    NSLog(
      "[TajweedLexical] ref=%d:%d authority=%@ expectedRaw='%@' expectedNorm=%@ hypRaw='%@' hypNorm=%@ ops=%@ acc=%f",
      surah,
      ayah,
      lexicalAuthority,
      expectedArabic,
      expectedNormForLog.description,
      hypothesis,
      hypNormForLog.description,
      ops.map { TajweedLexicalScoring.formatOpForLog($0) }.description,
      wordAccuracy
    )

    // Live compare dump = the only on-disk WAV write in this path (not used for inference).
    let trailingStart = max(0, time / 8)
    let trailingNonBlank = argmax.enumerated().filter { $0.offset >= trailingStart && $0.element != CtcDecoder.blankId }.count
    let tDump0 = CFAbsoluteTimeGetCurrent()
    TajweedLiveCaptureDump.dump(
      pcm: pcm,
      stages: [
        "platform": "ios",
        "ref": "\(surah):\(ayah)",
        "lexicalAuthority": lexicalAuthority,
        "originalExpectedAyah": expectedArabic,
        "normalizedExpectedWords": expectedNormForLog,
        "originalAsrHypothesis": hypothesis,
        "normalizedAsrWords": hypNormForLog,
        "lexicalOps": ops.map { op -> [String: Any] in
          var row: [String: Any] = [
            "op": String(describing: op.op),
            "text": op.text,
          ]
          if let reason = op.reason {
            row["reason"] = reason
          }
          if let ei = op.expectedIndex {
            row["expectedIndex"] = ei
            if expectedWords.indices.contains(ei) {
              row["expectedNorm"] = expectedNormForLog.indices.contains(ei)
                ? expectedNormForLog[ei]
                : expectedWords[ei]
            }
          }
          if let hi = op.hypIndex {
            row["hypIndex"] = hi
            if hypWords.indices.contains(hi) {
              row["hypNorm"] = TajweedLexicalScoring.normalizeArabic(hypWords[hi])
            }
          }
          return row
        },
        "expected": expectedArabic,
        "hypothesis": hypothesis,
        "durationSec": duration,
        "pcmSamples": pcm.count,
        "melTime": time,
        "logprobsFrames": asrOut.logprobs.count,
        "encoderFrames": asrOut.encoderOutput.count,
        "bucketT": asrOut.bucketT,
        "ctcTokenCount": collapsed.count,
        "trailingNonBlankArgmax": trailingNonBlank,
        "wordAccuracy": wordAccuracy,
        "exactMatch": exact,
        "tokens": tokens,
        "timingsMs": timingsMs,
        "modelInfo": modelInfo,
        "canonicalShadow": CanonicalLexicalShadow.toStagesPayload(shadowResult),
      ]
    )
    timingsMs["audioFileWriteMs"] = (CFAbsoluteTimeGetCurrent() - tDump0) * 1000

    let report: [String: Any] = [
      "ref": "\(surah):\(ayah)",
      "expected": expectedArabic,
      "hypothesis": hypothesis,
      "durationSec": duration,
      "wordAccuracy": wordAccuracy,
      "exactMatch": exact,
      "tokens": tokens,
      "timingsMs": timingsMs,
      "modelInfo": modelInfo,
    ]

    return report
  }

  /// Forced-alignment + pronunciation head only for matched hyp words.
  /// Returns tokens plus FA / head inference ms (scoring logic unchanged).
  private func buildLexicalFirstTokens(
    ops: [TajweedLexicalScoring.WordAlignOp],
    hypIds: [Int],
    asrOut: AsrInferenceResult,
    tokenizer: SentencePieceTokenizer
  ) -> (tokens: [[String: Any]], forcedAlignMs: Double, headInferMs: Double) {
    let matchHypIndices = Set(ops.compactMap { op -> Int? in
      op.op == .match ? op.hypIndex : nil
    })

    var matchPron: [Int: (prob: Float, start: Double?, end: Double?)] = [:]
    var forcedAlignMs = 0.0
    var headInferMs = 0.0
    if !matchHypIndices.isEmpty, !hypIds.isEmpty, !asrOut.logprobs.isEmpty {
      let tFa0 = CFAbsoluteTimeGetCurrent()
      let intervals = try? CtcAligner.forcedAlign(logprobs: asrOut.logprobs, tokenIds: hypIds)
      forcedAlignMs = (CFAbsoluteTimeGetCurrent() - tFa0) * 1000
      if let intervals {
        let pieceWordIndex = TajweedLexicalScoring.pieceWordIndices(tokenIds: hypIds) {
          tokenizer.startsNewWord($0)
        }
        let tHead0 = CFAbsoluteTimeGetCurrent()
        for interval in intervals {
          let pieceIdx = interval.tokenIndex
          guard pieceWordIndex.indices.contains(pieceIdx) else { continue }
          let hypWord = pieceWordIndex[pieceIdx]
          guard matchHypIndices.contains(hypWord) else { continue }

          var prob: Float = 1.0
          if !asrOut.encoderOutput.isEmpty {
            prob = (try? head.score(
              encoder: asrOut.encoderOutput,
              tokenId: interval.tokenId,
              startFrame: interval.startFrame,
              endFrame: interval.endFrame
            )) ?? 1.0
          }
          if let prev = matchPron[hypWord] {
            matchPron[hypWord] = (min(prev.prob, prob), prev.start, interval.endSec)
          } else {
            matchPron[hypWord] = (prob, interval.startSec, interval.endSec)
          }
        }
        headInferMs = (CFAbsoluteTimeGetCurrent() - tHead0) * 1000
      }
    }

    let tokens: [[String: Any]] = ops.map { op in
      switch op.op {
      case .match:
        let scored = op.hypIndex.flatMap { matchPron[$0] }
        let prob = scored?.prob ?? 1.0
        let pronStatus = PronunciationHeadModel.status(forProb: prob)
        return TajweedLexicalScoring.tokenMap(
          text: op.text,
          status: pronStatus,
          lexical: "match",
          pronunciation: pronStatus,
          prob: prob,
          startSec: scored?.start,
          endSec: scored?.end
        )
      case .sub:
        return TajweedLexicalScoring.tokenMap(
          text: op.text, status: "sub", lexical: "sub", pronunciation: nil, prob: 0.0,
          reason: op.reason)
      case .miss:
        return TajweedLexicalScoring.tokenMap(
          text: op.text, status: "miss", lexical: "miss", pronunciation: nil, prob: 0.0,
          reason: op.reason)
      case .extra:
        return TajweedLexicalScoring.tokenMap(
          text: op.text, status: "extra", lexical: "extra", pronunciation: nil, prob: 0.0,
          reason: op.reason)
      }
    }
    return (tokens, forcedAlignMs, headInferMs)
  }

  func wordAccuracyFromTokensForTesting(_ tokens: [[String: Any]], expectedWordCount: Int) -> Double {
    TajweedLexicalScoring.wordAccuracyFromTokens(tokens, expectedWordCount: expectedWordCount)
  }

  private func validateAudioQuality(_ pcm: [Float]) throws {
    let minSamples = Int(0.3 * Double(MelFrontend.sampleRate))
    let maxSamples = Int(48.0 * Double(MelFrontend.sampleRate))
    if pcm.count < minSamples {
      throw TajweedNativeError(TajweedErrorCode.audioTooShort, "Recording shorter than 0.3s.")
    }
    if pcm.count > maxSamples {
      throw TajweedNativeError(TajweedErrorCode.audioTooLong, "Recording longer than 48s.")
    }
    var sum: Float = 0
    var peak: Float = 0
    for x in pcm {
      let a = abs(x)
      sum += a
      if a > peak { peak = a }
    }
    let mean = sum / Float(pcm.count)
    if mean < 0.005 {
      throw TajweedNativeError(TajweedErrorCode.audioQualityPoor, "Mostly silence.")
    }
    if peak > 0.99 {
      throw TajweedNativeError(TajweedErrorCode.audioQualityPoor, "Clipping detected.")
    }
  }

  // MARK: - Official → DIY CoreML session failover

  /// Prefer Official (production catalog). If this session already failed over,
  /// or Official ensure fails, activate DIY CoreML silently.
  private func ensureModelLockedPreferringOfficial() throws {
    if shouldUseDiyPath {
      try runEnsureInstallingDiyIfNeeded()
      return
    }

    do {
      try runEnsureFromCurrentCatalog()
    } catch {
      let reason =
        "ensureModel Official/catalog failed: \((error as? TajweedNativeError)?.message ?? error.localizedDescription)"
      try activateDiyFailoverLocked(reason: reason)
    }
  }

  private var shouldUseDiyPath: Bool {
    if TajweedEngineFailover.sessionUsesDiy { return true }
    // DEBUG: user explicitly chose DIY — do not fight the override.
    if TajweedDevModelOverride.isAllowed,
       TajweedDevModelOverride.preferredSource == .diy
    {
      return true
    }
    return false
  }

  private func runEnsureFromCurrentCatalog() throws {
    let shaBefore = ModelStore.shared.activeEncoderSha256()
    let versionBefore = ModelStore.shared.activeManifestVersion()
    let availableBefore = ModelStore.shared.isAvailable()
    try ModelStore.shared.ensureModel { [weak self] p in
      self?.emit(["type": "downloadProgress", "progress": p])
    }
    notePackIdentityChangeIfNeeded(
      availableBefore: availableBefore,
      shaBefore: shaBefore,
      versionBefore: versionBefore
    )
  }

  private func runEnsureInstallingDiyIfNeeded() throws {
    let shaBefore = ModelStore.shared.activeEncoderSha256()
    let versionBefore = ModelStore.shared.activeManifestVersion()
    let availableBefore = ModelStore.shared.isAvailable()
    try ModelStore.shared.ensureDiyFailoverPack { [weak self] p in
      self?.emit(["type": "downloadProgress", "progress": p])
    }
    notePackIdentityChangeIfNeeded(
      availableBefore: availableBefore,
      shaBefore: shaBefore,
      versionBefore: versionBefore
    )
  }

  private func notePackIdentityChangeIfNeeded(
    availableBefore: Bool,
    shaBefore: String,
    versionBefore: String
  ) {
    let shaAfter = ModelStore.shared.activeEncoderSha256()
    let versionAfter = ModelStore.shared.activeManifestVersion()
    let packChanged =
      !availableBefore
      || shaBefore != shaAfter
      || versionBefore != versionAfter
    if packChanged {
      NSLog(
        "[TajweedCoreML] ensureModel pack changed version=%@→%@ shaPrefix=%@→%@ — unloading cache",
        versionBefore,
        versionAfter,
        String(shaBefore.prefix(12)),
        String(shaAfter.prefix(12))
      )
      unloadModelsLocked()
    } else {
      NSLog(
        "[TajweedCoreML] ensureModel kept in-memory cache specializedModels=%d",
        asr.cachedSpecializedModelCount
      )
    }
  }

  private func unloadModelsLocked() {
    asr.unload()
    head.unload()
    tokenizer = nil
    loadedTokensPath = nil
    loadedEncoderSha = nil
  }

  /// Install DIY, unload Official models, warm-load DIY. Marks session failover.
  private func activateDiyFailoverLocked(reason: String) throws {
    if ModelStore.shared.isDiyPackActive(), asr.isLoaded, head.isLoaded, tokenizer != nil {
      TajweedEngineFailover.markDiyForSession(reason: reason)
      return
    }
    TajweedEngineFailover.markDiyForSession(reason: reason)
    emit([
      "type": "engineFailover",
      "to": "diyCoreML",
      "reason": reason,
    ])
    try runEnsureInstallingDiyIfNeeded()
    unloadModelsLocked()
    try warmLoadLocked()
  }

  private func warmLoadWithFailoverLocked() throws {
    do {
      if shouldUseDiyPath, !ModelStore.shared.isDiyPackActive() {
        try activateDiyFailoverLocked(reason: "prepare: session prefers DIY, pack not active")
        return
      }
      try warmLoadLocked()
    } catch {
      if ModelStore.shared.isDiyPackActive(), TajweedEngineFailover.sessionUsesDiy {
        throw error
      }
      let reason =
        "warmLoad Official failed: \((error as? TajweedNativeError)?.message ?? error.localizedDescription)"
      try activateDiyFailoverLocked(reason: reason)
    }
  }

  /// Score with one silent Official→DIY retry on CoreML load/inference failure.
  private func scoreWithFailover(pcm: [Float]) throws -> [String: Any] {
    do {
      return try score(pcm: pcm)
    } catch let e as TajweedNativeError {
      guard Self.isEngineFailoverCandidate(e) else { throw e }
      if ModelStore.shared.isDiyPackActive(), TajweedEngineFailover.sessionUsesDiy {
        throw e
      }
      let reason = "score Official failed (\(e.code)): \(e.message)"
      try activateDiyFailoverLocked(reason: reason)
      return try score(pcm: pcm)
    } catch {
      if ModelStore.shared.isDiyPackActive(), TajweedEngineFailover.sessionUsesDiy {
        throw error
      }
      let reason = "score Official failed: \(error.localizedDescription)"
      try activateDiyFailoverLocked(reason: reason)
      return try score(pcm: pcm)
    }
  }

  /// Load / inference engine failures only — never audio/mic/cancel/lexicon miss.
  private static func isEngineFailoverCandidate(_ error: TajweedNativeError) -> Bool {
    switch error.code {
    case TajweedErrorCode.modelLoadFailed,
      TajweedErrorCode.modelDownloadFailed,
      TajweedErrorCode.modelMissing:
      return true
    case TajweedErrorCode.inferenceFailed:
      // Lexical fail-closed is not an engine failure — do not swap packs.
      let msg = error.message.lowercased()
      if msg.contains("canonical lexicon") { return false }
      return true
    default:
      return false
    }
  }

  private func warmLoadLocked() throws {
    guard ModelStore.shared.isAvailable() else {
      throw TajweedNativeError(TajweedErrorCode.modelMissing, "Model pack not on disk.")
    }

    let encoderURL = try ModelStore.shared.encoderURL()
    let desiredApi = ModelStore.shared.encoderApi()
    let desiredPrefix = ModelStore.shared.encoderFunctionPrefix()
    let desiredSha = ModelStore.shared.activeEncoderSha256()
    let asrNeedsReload =
      !asr.isLoaded
      || asr.loadedPackagePath != encoderURL.path
      || asr.loadedEncoderApi != desiredApi
      || asr.loadedFunctionPrefix != desiredPrefix
      || loadedEncoderSha != desiredSha
    if asrNeedsReload {
      NSLog(
        "[TajweedCoreML] warmLoad rebinding ASR path=%@ api=%@ shaPrefix=%@",
        encoderURL.lastPathComponent,
        ModelStore.shared.activeEncoderApiLabel(),
        String(desiredSha.prefix(12))
      )
      asr.unload()
      try asr.load(
        packageURL: encoderURL,
        encoderApi: desiredApi,
        functionPrefix: desiredPrefix
      )
      loadedEncoderSha = desiredSha
    }

    let headURL = try ModelStore.shared.headURL()
    if !head.isLoaded || head.loadedPackagePath != headURL.path {
      head.unload()
      try head.load(packageURL: headURL)
    }

    // Tokenizer is cheap; rebuild when the active pack's tokens path changes.
    let tokensURL = try ModelStore.shared.tokensURL()
    if tokenizer == nil || loadedTokensPath != tokensURL.path {
      tokenizer = try SentencePieceTokenizer(tokensFileURL: tokensURL)
      loadedTokensPath = tokensURL.path
    }
  }

  /// Preload specialized CoreML functions without blocking ensure/prepare
  /// completion (download UI advances at 100%). Uses `preloadQueue` so it
  /// cannot stall `workQueue` (startRecording / score).
  private func scheduleBackgroundSpecializedPreload() {
    preloadQueue.async { [weak self] in
      guard let self else { return }
      do {
        let preload = try self.asr.preloadAllSpecializedModels()
        NSLog(
          "[TajweedCoreML] background preload coldLoads=%d elapsedMs=%.1f cacheSize=%d",
          preload.coldLoads,
          preload.elapsedMs,
          self.asr.cachedSpecializedModelCount
        )
      } catch {
        NSLog(
          "[TajweedCoreML] background preload failed: %@",
          error.localizedDescription
        )
      }
    }
  }

  /// Diagnostic only — does not trim PCM. Flags near-silent first/last 50 ms.
  private static func audioEdgeEnergy(_ pcm: [Float]) -> (
    peak: Float,
    leadingAbsMean: Double,
    midAbsMean: Double,
    trailingAbsMean: Double,
    leadingSilent: Bool,
    trailingSilent: Bool
  ) {
    guard !pcm.isEmpty else {
      return (0, 0, 0, 0, true, true)
    }
    let window = min(pcm.count, Int(0.05 * Double(MelFrontend.sampleRate)))
    func absMean(_ slice: ArraySlice<Float>) -> Double {
      guard !slice.isEmpty else { return 0 }
      var sum: Double = 0
      for v in slice { sum += Double(abs(v)) }
      return sum / Double(slice.count)
    }
    var peak: Float = 0
    for v in pcm {
      let a = abs(v)
      if a > peak { peak = a }
    }
    let leading = absMean(pcm[..<window])
    let trailing = absMean(pcm[(pcm.count - window)...])
    let midStart = window
    let midEnd = max(midStart, pcm.count - window)
    let mid = absMean(pcm[midStart..<midEnd])
    let silentThreshold = 0.002
    return (
      peak,
      leading,
      mid,
      trailing,
      leading < silentThreshold,
      trailing < silentThreshold
    )
  }

  private func setState(_ new: TajweedRecordingState) {
    stateLock.lock()
    state = new
    stateLock.unlock()
    emit(["type": "recordingState", "state": new.rawValue])
  }

  private func emit(_ payload: [String: Any]) {
    DispatchQueue.main.async { self.onEvent?(payload) }
  }

  private func handleInterruption(reason: String) {
    workQueue.async {
      self.cancelled = true
      self.recorder.cancel()
      self.setState(.idle)
      self.emit(["type": "interrupted", "reason": reason])
    }
  }

  @objc private func memoryWarning() {
    workQueue.async {
      NSLog("[TajweedCoreML] memory warning — unloading specialized models (will reload on next prepare/score)")
      self.asr.unload()
      self.head.unload()
      self.loadedEncoderSha = nil
      self.emit(["type": "modelUnloaded", "reason": "memory"])
    }
  }

  @objc private func appBackground() {
    workQueue.async {
      self.stateLock.lock()
      let recording = self.state == .recording
      self.stateLock.unlock()
      if recording {
        self.cancelled = true
        self.recorder.cancel()
        self.setState(.idle)
        self.emit(["type": "interrupted", "reason": "app_background"])
      }
    }
  }

  // MARK: - Text helpers

  /// Internal (not private) so unit tests can validate the lexical scoring
  /// building blocks that feed the ADR-006 JSON, without a loaded CoreML model.
  func normalizeArabicForTesting(_ text: String) -> String {
    TajweedLexicalScoring.normalizeArabic(text)
  }

  func wordAccuracyForTesting(expected: [String], hypothesis: [String]) -> Double {
    TajweedLexicalScoring.wordAccuracyScore(expected: expected, hypothesis: hypothesis)
  }

  func lexicalTokenReportForTesting(expected: [String], hypothesis: [String]) -> [[String: Any]] {
    TajweedLexicalScoring.lexicalTokenReport(expected: expected, hypothesis: hypothesis)
  }

  // MARK: - Debug helpers

  /// Score a PCM buffer without recording (for TajweedDebugRunner).
  func scorePCMForDebug(
    pcm: [Float],
    surah: Int,
    ayah: Int,
    expectedArabic: String
  ) throws -> (report: [String: Any], timingsMs: [String: Double]) {
    var timings: [String: Double] = [:]
    let t0 = CFAbsoluteTimeGetCurrent()
    try warmLoadWithFailoverLocked()
    timings["warmOrReuseMs"] = (CFAbsoluteTimeGetCurrent() - t0) * 1000

    self.surah = surah
    self.ayah = ayah
    self.expectedArabic = expectedArabic
    self.lexicalReferenceArabic = expectedArabic

    let t1 = CFAbsoluteTimeGetCurrent()
    let report = try scoreWithFailover(pcm: pcm)
    timings["inferenceMs"] = (CFAbsoluteTimeGetCurrent() - t1) * 1000
    if let detailed = report["timingsMs"] as? [String: Double] {
      for (k, v) in detailed {
        timings[k] = v
      }
    }
    return (report, timings)
  }
}
