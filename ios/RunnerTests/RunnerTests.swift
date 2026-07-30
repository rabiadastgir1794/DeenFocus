import AVFoundation
import Flutter
import UIKit
import XCTest

@testable import Runner

/// Phase 2 iOS validation pass (functional/JSON/memory/threading/error-mapping)
/// per the reviewer's pre-Phase-3 checklist. Does not require the gated CoreML
/// weight pack — exercises everything that doesn't need real inference, plus
/// pure-Swift algorithm correctness (mel bucketing, CTC decode/align).
class RunnerTests: XCTestCase {
  // Force the Tajweed network asset path off for this whole test class: none
  // of these tests exercise real downloads, and
  // `TajweedAssetDistributionConfig.catalogURL` now points at the real
  // production Cloudflare R2 bucket (see ADR-009 migration). Both the config
  // (in case the lazy `ModelStore`
  // registration hasn't fired yet in this process) and the live
  // `AIAssetManager.shared.catalogURL` (in case it already has) are
  // overridden, so ordering relative to other test classes can't matter.
  private var previousConfigCatalogURL: URL?
  private var previousManagerCatalogURL: URL?

  override func setUp() {
    super.setUp()
    previousConfigCatalogURL = TajweedAssetDistributionConfig.catalogURL
    previousManagerCatalogURL = AIAssetManager.shared.catalogURL
    TajweedAssetDistributionConfig.catalogURL = nil
    AIAssetManager.shared.catalogURL = nil
  }

  override func tearDown() {
    TajweedAssetDistributionConfig.catalogURL = previousConfigCatalogURL
    AIAssetManager.shared.catalogURL = previousManagerCatalogURL
    super.tearDown()
  }

  func testExample() {
    // If you add code to the Runner application, consider adding tests here.
    // See https://developer.apple.com/documentation/xctest for more information about using XCTest.
  }

  // MARK: - Pure algorithm correctness

  func testCtcDecoderCollapsesRepeatsAndBlanks() {
    let blank = CtcDecoder.blankId
    let ids = [blank, 5, 5, blank, 6, 6, 6, blank, blank, 7]
    XCTAssertEqual(CtcDecoder.collapse(ids, blankId: blank), [5, 6, 7])
  }

  func testMelFrontendProducesExpectedFrameCountAndBucket() throws {
    let sampleCount = MelFrontend.sampleRate // 1 second of audio
    let pcm = (0..<sampleCount).map { i in
      Float(sin(Double(i) * 0.01))
    }
    let (features, time) = try MelFrontend.logMel(pcm: pcm)
    XCTAssertEqual(features.count, MelFrontend.nMels * time)
    XCTAssertGreaterThan(time, 0)

    let (padded, bucket) = try MelFrontend.padToBucket(features, time: time)
    XCTAssertGreaterThanOrEqual(bucket, time)
    XCTAssertEqual(padded.count, MelFrontend.nMels * bucket)
    XCTAssertTrue([80, 160, 320, 640, 1280, 2560, 4800].contains(bucket))
  }

  func testMelFrontendRejectsTooShortAudio() {
    let tooShort = [Float](repeating: 0, count: 10)
    XCTAssertThrowsError(try MelFrontend.logMel(pcm: tooShort)) { error in
      guard let e = error as? TajweedNativeError else {
        return XCTFail("Expected TajweedNativeError")
      }
      XCTAssertEqual(e.code, TajweedErrorCode.audioTooShort)
    }
  }

  func testMelFrontendRejectsAudioLongerThan48Seconds() throws {
    // 49 seconds of silence at 16kHz mel-frame time would exceed the T4800 bucket.
    let frames = 4900
    let features = [Float](repeating: 0, count: MelFrontend.nMels * frames)
    XCTAssertThrowsError(try MelFrontend.padToBucket(features, time: frames)) { error in
      guard let e = error as? TajweedNativeError else {
        return XCTFail("Expected TajweedNativeError")
      }
      XCTAssertEqual(e.code, TajweedErrorCode.audioTooLong)
    }
  }

  // MARK: - Phase 4A: cross-platform golden mel-spectrogram parity (real audio)

  /// Repo root, resolved from this file's compile-time path (`<repo>/ios/RunnerTests/RunnerTests.swift`)
  /// so the harness works on any machine that clones the repo, not just the one it was written on.
  private static var repoRoot: URL {
    URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()  // RunnerTests/
      .deletingLastPathComponent()  // ios/
      .deletingLastPathComponent()  // <repo>/
  }

  private func loadPCM16kMono(_ url: URL) throws -> [Float] {
    let file = try AVAudioFile(forReading: url)
    let format = file.processingFormat
    guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length)) else {
      throw NSError(domain: "RunnerTests", code: 1, userInfo: [NSLocalizedDescriptionKey: "buffer alloc failed"])
    }
    try file.read(into: buffer)
    guard let data = buffer.floatChannelData else {
      throw NSError(domain: "RunnerTests", code: 2, userInfo: [NSLocalizedDescriptionKey: "no float channel data"])
    }
    let n = Int(buffer.frameLength)
    let channelCount = Int(format.channelCount)
    if channelCount == 1 {
      return Array(UnsafeBufferPointer(start: data[0], count: n))
    }
    var mono = [Float](repeating: 0, count: n)
    for c in 0..<channelCount {
      let chan = data[c]
      for i in 0..<n { mono[i] += chan[i] }
    }
    let scale = 1.0 / Float(channelCount)
    for i in 0..<n { mono[i] *= scale }
    return mono
  }

  /// Dumps iOS's real MelFrontend output on the actual golden Quran recitation clips
  /// (`tajweed-lab/samples/*.wav`) to `/tmp/tajweed_parity/ios/<name>.json`, so
  /// `tajweed-lab/scripts/parity_compare_mel.py` can diff it against the Python
  /// reference (`tajweed-lab/parity/python/`) and Android's dump
  /// (`tajweed-lab/parity/android/`) on the exact same audio. Skips gracefully if the
  /// golden samples aren't present (e.g. CI without tajweed-lab checked out).
  func testPhase4AMelParityDumpOnGoldenSamples() throws {
    let samplesDir = Self.repoRoot.appendingPathComponent("tajweed-lab/samples")
    let fm = FileManager.default
    guard let entries = try? fm.contentsOfDirectory(at: samplesDir, includingPropertiesForKeys: nil) else {
      throw XCTSkip("Golden samples not found at \(samplesDir.path) — skipping Phase 4A mel parity dump.")
    }
    let wavs = entries.filter { $0.pathExtension.lowercased() == "wav" }.sorted { $0.lastPathComponent < $1.lastPathComponent }
    XCTAssertFalse(wavs.isEmpty, "Expected golden .wav samples in \(samplesDir.path)")

    let outDir = URL(fileURLWithPath: "/tmp/tajweed_parity/ios")
    try fm.createDirectory(at: outDir, withIntermediateDirectories: true)

    for wav in wavs {
      let pcm = try loadPCM16kMono(wav)
      let (features, time) = try MelFrontend.logMel(pcm: pcm)
      let name = wav.deletingPathExtension().lastPathComponent
      let payload: [String: Any] = [
        "sample": wav.lastPathComponent,
        "n_mels": MelFrontend.nMels,
        "time": time,
        "features": features.map { Double($0) },
      ]
      let json = try JSONSerialization.data(withJSONObject: payload)
      try json.write(to: outDir.appendingPathComponent("\(name).json"))
      print("Phase4A: dumped iOS mel for \(wav.lastPathComponent) -> \(outDir.path)/\(name).json (T=\(time))")
    }
  }

  func testCtcAlignerProducesMonotonicIntervalsForSyntheticLogprobs() throws {
    // CtcAligner hardcodes blankId = 1024, so the synthetic vocab must be wider
    // than that even though only 3 ids are actually exercised.
    let blank = CtcAligner.blankId
    let vocab = blank + 1
    let T = 8
    var logprobs = [[Float]](repeating: [Float](repeating: -5, count: vocab), count: T)
    let favored: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 1, 4: 1, 5: 1, 6: blank, 7: blank]
    for t in 0..<T {
      let win = favored[t] ?? blank
      logprobs[t][win] = 0
    }
    let intervals = try CtcAligner.forcedAlign(logprobs: logprobs, tokenIds: [0, 1])
    XCTAssertEqual(intervals.map(\.tokenId), [0, 1])
    // tokenIndex (position within the input tokenIds array) is what word-grouping keys off —
    // must track tokenId 1:1 here since there are no duplicate ids in this vocab.
    XCTAssertEqual(intervals.map(\.tokenIndex), [0, 1])
    XCTAssertLessThanOrEqual(intervals[0].endFrame, intervals[1].startFrame + 1)
    XCTAssertGreaterThan(intervals[1].endFrame, intervals[0].startFrame)
  }

  func testSentencePieceTokenizerRoundTripsSimpleVocab() throws {
    let tmp = FileManager.default.temporaryDirectory
      .appendingPathComponent("tokens_\(UUID().uuidString).txt")
    let content = "<unk> 0\n▁بسم 1\n▁الله 2\nم 3\n"
    try content.write(to: tmp, atomically: true, encoding: .utf8)
    defer { try? FileManager.default.removeItem(at: tmp) }

    let tokenizer = try SentencePieceTokenizer(tokensFileURL: tmp)
    let ids = tokenizer.encode("بسم الله")
    XCTAssertFalse(ids.isEmpty)
    let decoded = tokenizer.decode(ids)
    XCTAssertTrue(decoded.contains("بسم"))
  }

  /// Pins the raw "▁" word-boundary detection that TajweedEngine.buildWordLevelTokens relies
  /// on to group per-piece forced-align intervals into whole-word tokens.
  func testStartsNewWordDetectsSentencePieceWordBoundary() throws {
    let tmp = FileManager.default.temporaryDirectory
      .appendingPathComponent("tokens_\(UUID().uuidString).txt")
    // ids: 0=<unk> 1=▁بسم(word start) 2=▁الله(word start) 3=م(continuation, no ▁)
    let content = "<unk> 0\n▁بسم 1\n▁الله 2\nم 3\n"
    try content.write(to: tmp, atomically: true, encoding: .utf8)
    defer { try? FileManager.default.removeItem(at: tmp) }

    let tokenizer = try SentencePieceTokenizer(tokensFileURL: tmp)
    XCTAssertTrue(tokenizer.startsNewWord(1))
    XCTAssertTrue(tokenizer.startsNewWord(2))
    XCTAssertFalse(tokenizer.startsNewWord(3))
    XCTAssertFalse(tokenizer.startsNewWord(99)) // out-of-range id must not throw/crash
  }

  // MARK: - JSON schema (ADR-006) — lexical helpers without a loaded model

  func testLexicalTokenReportMatchesAdr006Shape() {
    let engine = TajweedEngine.shared
    let expected = ["بِسْمِ", "اللَّهِ"]
    let hypothesis = ["بِسْمِ", "اللَّهِ"]
    let tokens = engine.lexicalTokenReportForTesting(expected: expected, hypothesis: hypothesis)
    XCTAssertEqual(tokens.count, 2)
    let allowedKeys: Set<String> = [
      "text", "status", "prob", "startSec", "endSec", "lexical", "pronunciation",
    ]
    for token in tokens {
      XCTAssertNotNil(token["text"] as? String)
      XCTAssertEqual(token["status"] as? String, "ok")
      XCTAssertEqual(token["lexical"] as? String, "match")
      XCTAssertTrue(
        Set(token.keys).isSubset(of: allowedKeys),
        "Unexpected key in \(token.keys) — no platform-specific fields allowed per ADR-006"
      )
    }
  }

  func testWordAccuracyIsOneForExactMatch() {
    let engine = TajweedEngine.shared
    let words = ["بِسْمِ", "اللَّهِ", "الرَّحْمَٰنِ"]
    XCTAssertEqual(engine.wordAccuracyForTesting(expected: words, hypothesis: words), 1.0)
  }

  /// Lexical-first: pronunciation severity on matched words does not reduce wordAccuracy.
  func testWordAccuracyFromTokensIsLexicalOnly() {
    let engine = TajweedEngine.shared
    let tokens: [[String: Any]] = [
      ["text": "بِسْمِ", "status": "ok", "lexical": "match", "pronunciation": "ok"],
      ["text": "اللَّهِ", "status": "minor", "lexical": "match", "pronunciation": "minor"],
      ["text": "الرَّحْمَٰنِ", "status": "major", "lexical": "match", "pronunciation": "major"],
      ["text": "الرَّحِيمِ", "status": "miss", "lexical": "miss"],
    ]
    XCTAssertEqual(engine.wordAccuracyFromTokensForTesting(tokens, expectedWordCount: 4), 0.75)
  }

  func testWordAccuracyFromTokensHandlesEmptyExpected() {
    let engine = TajweedEngine.shared
    XCTAssertEqual(engine.wordAccuracyFromTokensForTesting([], expectedWordCount: 0), 1.0)
    let extraOnly: [[String: Any]] = [["text": "زَائِد", "status": "extra", "lexical": "extra"]]
    XCTAssertEqual(engine.wordAccuracyFromTokensForTesting(extraOnly, expectedWordCount: 0), 0.0)
  }

  /// Regression: completely different ayah → near-zero lexical accuracy.
  func testCompletelyDifferentAyahYieldsZeroLexicalAccuracy() {
    let expected = TajweedLexicalScoring.splitWords("قُلْ هُوَ اللَّهُ أَحَدٌ")
    let hypothesis = TajweedLexicalScoring.splitWords("مَالِكِ يَوْمِ الدِّينِ")
    let ops = TajweedLexicalScoring.alignWords(expected: expected, hypothesis: hypothesis)
    XCTAssertEqual(ops.filter { $0.op == .match }.count, 0)
    let tokens = TajweedLexicalScoring.tokensFromAlignment(ops)
    XCTAssertEqual(
      TajweedLexicalScoring.wordAccuracyFromTokens(tokens, expectedWordCount: expected.count),
      0.0
    )
    XCTAssertTrue(tokens.contains { ($0["status"] as? String) == "sub" || ($0["status"] as? String) == "miss" })
  }

  func testSubstitutionStatusDistinctFromMajor() {
    let tokens = TajweedLexicalScoring.tokensFromAlignment(
      TajweedLexicalScoring.alignWords(expected: ["قُلْ", "هُوَ"], hypothesis: ["مَالِكِ", "يَوْمِ"])
    )
    XCTAssertTrue(tokens.allSatisfy { ($0["status"] as? String) == "sub" })
    XCTAssertFalse(tokens.contains { ($0["status"] as? String) == "major" })
  }

  func testMatchedWordPreservesPronunciationSeparately() {
    var token = TajweedLexicalScoring.tokenMap(
      text: "قُلْ", status: "ok", lexical: "match", pronunciation: "ok", prob: 1.0)
    let bad = PronunciationHeadModel.status(forProb: 0.2)
    token["status"] = bad
    token["pronunciation"] = bad
    token["prob"] = Float(0.2)
    XCTAssertEqual(token["lexical"] as? String, "match")
    XCTAssertEqual(token["pronunciation"] as? String, "major")
    XCTAssertEqual(
      TajweedLexicalScoring.wordAccuracyFromTokens([token], expectedWordCount: 1),
      1.0
    )
  }

  func testArabicNormalizationStripsDiacriticsForComparison() {
    let engine = TajweedEngine.shared
    let withDiacritics = "بِسْمِ"
    let without = "بسم"
    XCTAssertEqual(
      engine.normalizeArabicForTesting(withDiacritics),
      engine.normalizeArabicForTesting(without)
    )
  }

  func testNormalizeArabicMapsDaggerAlifMalikToImlaei() {
    let uthmani = "مَٰلِكِ"
    let imlaei = "مَالِكِ"
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic(uthmani), "مالك")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic(imlaei), "مالك")
    XCTAssertEqual(
      TajweedLexicalScoring.normalizeArabic(uthmani),
      TajweedLexicalScoring.normalizeArabic(imlaei)
    )
  }

  func testNormalizeArabicMapsAlefWasla() {
    let uthmani = "ٱلدِّينِ"
    let imlaei = "الدِّينِ"
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic(uthmani), "الدين")
    XCTAssertEqual(
      TajweedLexicalScoring.normalizeArabic(uthmani),
      TajweedLexicalScoring.normalizeArabic(imlaei)
    )
  }

  func testNormalizeArabicMapsQuranicSukun() {
    let uthmani = "يَوۡمِ"
    let imlaei = "يَوْمِ"
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic(uthmani), "يوم")
    XCTAssertEqual(
      TajweedLexicalScoring.normalizeArabic(uthmani),
      TajweedLexicalScoring.normalizeArabic(imlaei)
    )
  }

  func testNormalizeArabicFatihah14UthmaniMatchesImlaeiAsr() {
    let uthmaniExpected = "مَٰلِكِ يَوۡمِ ٱلدِّينِ"
    let asrHypothesis = "مَالِكِ يَوْمِ الدِّينِ"
    let expWords = TajweedLexicalScoring.splitWords(uthmaniExpected)
    let hypWords = TajweedLexicalScoring.splitWords(asrHypothesis)
    XCTAssertEqual(expWords.count, 3)
    for i in expWords.indices {
      XCTAssertEqual(
        TajweedLexicalScoring.normalizeArabic(expWords[i]),
        TajweedLexicalScoring.normalizeArabic(hypWords[i]),
        "word[\(i)] must match after normalize"
      )
    }
    let ops = TajweedLexicalScoring.alignWords(expected: expWords, hypothesis: hypWords)
    XCTAssertEqual(ops.count, 3)
    XCTAssertTrue(ops.allSatisfy { $0.op == .match })
    XCTAssertEqual(
      TajweedLexicalScoring.wordAccuracyScore(expected: expWords, hypothesis: hypWords),
      1.0
    )
  }

  func testNormalizeArabicKeepsGenuinelyDifferentWordsDistinct() {
    XCTAssertNotEqual(
      TajweedLexicalScoring.normalizeArabic("ملك"),
      TajweedLexicalScoring.normalizeArabic("مالك")
    )
    XCTAssertNotEqual(
      TajweedLexicalScoring.normalizeArabic("قُلْ"),
      TajweedLexicalScoring.normalizeArabic("قَالَ")
    )
    XCTAssertNotEqual(
      TajweedLexicalScoring.normalizeArabic("رَبِّ"),
      TajweedLexicalScoring.normalizeArabic("رَبِّكَ")
    )
  }

  // MARK: - Functional: engine methods without a model pack (MODEL_MISSING path)

  func testGetRecordingStateStartsIdle() {
    XCTAssertEqual(TajweedEngine.shared.getRecordingState(), "idle")
  }

  func testEnsureModelFailsWithModelMissingWhenNoPackInstalled() {
    let expectation = expectation(description: "ensureModel completes")
    TajweedEngine.shared.ensureModel { outcome in
      switch outcome {
      case .success:
        XCTFail("Expected failure without an installed model pack")
      case .failure(let error):
        XCTAssertEqual(error.code, TajweedErrorCode.modelMissing)
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5)
  }

  func testPrepareModelFailsWithModelMissingWhenNoPackInstalled() {
    let expectation = expectation(description: "prepareModel completes")
    TajweedEngine.shared.prepareModel { outcome in
      switch outcome {
      case .success:
        XCTFail("Expected failure without an installed model pack")
      case .failure(let error):
        XCTAssertEqual(error.code, TajweedErrorCode.modelMissing)
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5)
  }

  func testStopRecordingAndScoreFailsWithNotRecordingWhenIdle() {
    let expectation = expectation(description: "stopRecordingAndScore completes")
    TajweedEngine.shared.stopRecordingAndScore { outcome in
      switch outcome {
      case .success:
        XCTFail("Expected NOT_RECORDING while idle")
      case .failure(let error):
        XCTAssertEqual(error.code, TajweedErrorCode.notRecording)
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5)
  }

  func testCancelRecordingFailsWithNotRecordingWhenIdle() {
    let expectation = expectation(description: "cancelRecording completes")
    TajweedEngine.shared.cancelRecording { outcome in
      switch outcome {
      case .success:
        XCTFail("Expected NOT_RECORDING while idle")
      case .failure(let error):
        XCTAssertEqual(error.code, TajweedErrorCode.notRecording)
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5)
  }

  func testDisposeIsIdempotentAndReturnsToIdle() {
    TajweedEngine.shared.dispose()
    TajweedEngine.shared.dispose()
    TajweedEngine.shared.dispose()
    XCTAssertEqual(TajweedEngine.shared.getRecordingState(), "idle")
    XCTAssertFalse(TajweedEngine.shared.isWarmedUpForTesting)
  }

  // MARK: - Threading: engine completions must NOT be on the main thread
  // (TajweedChannelHandler is what hops back to main before calling FlutterResult —
  // verified by code inspection: every case in handle() routes through deliver()/
  // deliverJSON(), which wrap in DispatchQueue.main.async exactly once.)

  func testEngineCallbacksRunOffMainThread() {
    let expectation = expectation(description: "ensureModel callback thread")
    TajweedEngine.shared.ensureModel { _ in
      XCTAssertFalse(Thread.isMainThread, "Engine should complete on its background work queue")
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5)
  }

  // MARK: - Memory: repeated ensure/dispose cycles should not crash or leak state

  func testRepeatedEnsureAndDisposeCyclesRemainStable() {
    for _ in 0..<20 {
      let expectation = expectation(description: "cycle")
      TajweedEngine.shared.ensureModel { _ in
        TajweedEngine.shared.dispose()
        expectation.fulfill()
      }
      waitForExpectations(timeout: 5)
    }
    XCTAssertEqual(TajweedEngine.shared.getRecordingState(), "idle")
  }

  // MARK: - ModelStore

  func testModelStoreReportsUnavailableWhenNothingInstalled() throws {
    // Clean environment assumption: no prior install in this test run/sandbox.
    if FileManager.default.fileExists(atPath: ModelStore.shared.manifestURL.path) {
      // A previous manual debug install exists on this machine — skip rather than
      // assert false, since this test doesn't own that shared sandbox state.
      throw XCTSkip("A model pack is already installed on this simulator; skipping clean-state assertion.")
    }
    XCTAssertFalse(ModelStore.shared.isAvailable())
  }

  // MARK: - Error mapping surface

  func testFlutterErrorMappingPreservesNativeCode() {
    let native = TajweedNativeError(TajweedErrorCode.audioQualityPoor, "too quiet")
    let flutterError = TajweedChannelHandler.flutterError(native)
    XCTAssertEqual(flutterError.code, TajweedErrorCode.audioQualityPoor)
    XCTAssertEqual(flutterError.message, "too quiet")
  }
}
