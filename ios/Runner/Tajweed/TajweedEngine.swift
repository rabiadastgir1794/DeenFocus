import AVFoundation
import Foundation
import UIKit

/// Orchestrates native record → mel → CoreML ASR → CTC → align → head → JSON.
final class TajweedEngine {
  static let shared = TajweedEngine()

  private let workQueue = DispatchQueue(label: "com.rnr.deenfocus.tajweed.engine", qos: .userInitiated)
  private let stateLock = NSLock()

  private let recorder = TajweedAudioRecorder()
  private let asr = OfflineAsrModel()
  private let head = PronunciationHeadModel()
  private var tokenizer: SentencePieceTokenizer?

  private var state: TajweedRecordingState = .idle
  private var expectedArabic: String = ""
  private var surah: Int = 0
  private var ayah: Int = 0
  private var cancelled = false

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
        try ModelStore.shared.ensureModel { [weak self] p in
          self?.emit(["type": "downloadProgress", "progress": p])
        }
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
        try self.warmLoadLocked()
        completion(.success(()))
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
        try self.warmLoadLocked()
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
    workQueue.async {
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

      let pcm = self.recorder.stop()
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
        try self.validateAudioQuality(pcm)
        let report = try self.score(pcm: pcm)
        self.setState(.idle)
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
      self.setState(.idle)
      self.emit(["type": "modelUnloaded"])
    }
  }

  // MARK: - Scoring pipeline

  private func score(pcm: [Float]) throws -> [String: Any] {
    let duration = Double(pcm.count) / Double(MelFrontend.sampleRate)
    let (feats, time) = try MelFrontend.logMel(pcm: pcm)
    let asrOut = try asr.predict(mel: feats, time: time)

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
    let expectedWords = TajweedLexicalScoring.splitWords(expectedArabic)
    let hypWords = TajweedLexicalScoring.splitWords(hypothesis)

    // Lexical-first (ADR-006): word DP decides identity; pronunciation head runs
    // only on matched words using FA of the *hypothesis* (spoken) token path.
    let ops = TajweedLexicalScoring.alignWords(expected: expectedWords, hypothesis: hypWords)
    let tokens = buildLexicalFirstTokens(ops: ops, hypIds: collapsed, asrOut: asrOut, tokenizer: tokenizer)

    let wordAccuracy = TajweedLexicalScoring.wordAccuracyFromTokens(
      tokens,
      expectedWordCount: expectedWords.count
    )

    let exact =
      TajweedLexicalScoring.normalizeArabic(hypothesis)
        == TajweedLexicalScoring.normalizeArabic(expectedArabic) && !expectedArabic.isEmpty

    return [
      "ref": "\(surah):\(ayah)",
      "expected": expectedArabic,
      "hypothesis": hypothesis,
      "durationSec": duration,
      "wordAccuracy": wordAccuracy,
      "exactMatch": exact,
      "tokens": tokens,
    ]
  }

  /// Forced-alignment + pronunciation head only for matched hyp words.
  private func buildLexicalFirstTokens(
    ops: [TajweedLexicalScoring.WordAlignOp],
    hypIds: [Int],
    asrOut: AsrInferenceResult,
    tokenizer: SentencePieceTokenizer
  ) -> [[String: Any]] {
    let matchHypIndices = Set(ops.compactMap { op -> Int? in
      op.op == .match ? op.hypIndex : nil
    })

    var matchPron: [Int: (prob: Float, start: Double?, end: Double?)] = [:]
    if !matchHypIndices.isEmpty, !hypIds.isEmpty, !asrOut.logprobs.isEmpty {
      if let intervals = try? CtcAligner.forcedAlign(logprobs: asrOut.logprobs, tokenIds: hypIds) {
        let pieceWordIndex = TajweedLexicalScoring.pieceWordIndices(tokenIds: hypIds) {
          tokenizer.startsNewWord($0)
        }
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
      }
    }

    return ops.map { op in
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
          text: op.text, status: "sub", lexical: "sub", pronunciation: nil, prob: 0.0)
      case .miss:
        return TajweedLexicalScoring.tokenMap(
          text: op.text, status: "miss", lexical: "miss", pronunciation: nil, prob: 0.0)
      case .extra:
        return TajweedLexicalScoring.tokenMap(
          text: op.text, status: "extra", lexical: "extra", pronunciation: nil, prob: 0.0)
      }
    }
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

  private func warmLoadLocked() throws {
    guard ModelStore.shared.isAvailable() else {
      throw TajweedNativeError(TajweedErrorCode.modelMissing, "Model pack not on disk.")
    }
    if tokenizer == nil {
      tokenizer = try SentencePieceTokenizer(tokensFileURL: ModelStore.shared.tokensURL())
    }
    if !asr.isLoaded {
      try asr.load(
        packageURL: ModelStore.shared.encoderURL(),
        encoderApi: ModelStore.shared.encoderApi()
      )
    }
    if !head.isLoaded {
      try head.load(packageURL: ModelStore.shared.headURL())
    }
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
      self.asr.unload()
      self.head.unload()
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
    try warmLoadLocked()
    timings["warmOrReuseMs"] = (CFAbsoluteTimeGetCurrent() - t0) * 1000

    self.surah = surah
    self.ayah = ayah
    self.expectedArabic = expectedArabic

    let t1 = CFAbsoluteTimeGetCurrent()
    let report = try score(pcm: pcm)
    timings["inferenceMs"] = (CFAbsoluteTimeGetCurrent() - t1) * 1000
    return (report, timings)
  }
}
