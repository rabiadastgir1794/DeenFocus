import AVFoundation
import CoreML
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

    let (padded, bucket) = try MelFrontend.padToBucket(
      features, time: time, buckets: MelFrontend.defaultOfficialBuckets
    )
    XCTAssertGreaterThanOrEqual(bucket, time)
    XCTAssertEqual(padded.count, MelFrontend.nMels * bucket)
    XCTAssertTrue(MelFrontend.defaultOfficialBuckets.contains(bucket))
  }

  func testMelFrontendPadToBucketUsesManifestBucketList() throws {
    // Alternate pack with a different bucket ladder must pad to *its* buckets,
    // not the hard-coded official defaults — dual-model / future-proof contract.
    let features = [Float](repeating: 0.1, count: MelFrontend.nMels * 250)
    let (padded, bucket) = try MelFrontend.padToBucket(
      features, time: 250, buckets: [80, 160, 320, 640, 1280, 2560, 4800]
    )
    XCTAssertEqual(bucket, 320)
    XCTAssertEqual(padded.count, MelFrontend.nMels * 320)
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
    XCTAssertThrowsError(
      try MelFrontend.padToBucket(
        features, time: frames, buckets: MelFrontend.defaultOfficialBuckets
      )
    ) { error in
      guard let e = error as? TajweedNativeError else {
        return XCTFail("Expected TajweedNativeError")
      }
      XCTAssertEqual(e.code, TajweedErrorCode.audioTooLong)
    }
  }

  func testMelFrontendPadToFixedForDiyEncoder() throws {
    let time = 200
    let features = [Float](repeating: 0.25, count: MelFrontend.nMels * time)
    let padded = try MelFrontend.padToFixed(features, time: time, fixedT: 4800)
    XCTAssertEqual(padded.count, MelFrontend.nMels * 4800)
    XCTAssertEqual(padded[0], 0.25)
    XCTAssertEqual(padded[MelFrontend.nMels * time], 0) // first pad cell
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

  /// Nested-array DP (pre-optimization reference). Must match production intervals.
  private func forcedAlignNestedReference(logprobs: [[Float]], tokenIds: [Int]) throws -> [TokenInterval] {
    let blankId = CtcAligner.blankId
    let negInf = -1e18
    let T = logprobs.count
    guard T > 0, let V = logprobs.first?.count, V > blankId else {
      throw TajweedNativeError(TajweedErrorCode.inferenceFailed, "Invalid logprobs.")
    }
    guard !tokenIds.isEmpty else { return [] }
    var seq: [Int] = [blankId]
    for t in tokenIds {
      seq.append(t)
      seq.append(blankId)
    }
    let S = seq.count
    guard T >= S / 2 else {
      throw TajweedNativeError(TajweedErrorCode.audioTooShort, "short")
    }
    var alpha = Array(repeating: Array(repeating: negInf, count: S), count: T)
    var back = Array(repeating: Array(repeating: Int8(0), count: S), count: T)
    var skipOk = Array(repeating: false, count: S)
    if S >= 3 {
      for s in 2..<S {
        skipOk[s] = seq[s] != blankId && seq[s] != seq[s - 2]
      }
    }
    func emit(_ t: Int, _ s: Int) -> Double { Double(logprobs[t][seq[s]]) }
    alpha[0][0] = emit(0, 0)
    if S > 1 { alpha[0][1] = emit(0, 1) }
    for t in 1..<T {
      for s in 0..<S {
        var best = alpha[t - 1][s]
        var bestIdx: Int8 = 0
        if s >= 1, alpha[t - 1][s - 1] > best {
          best = alpha[t - 1][s - 1]
          bestIdx = 1
        }
        if s >= 2, skipOk[s], alpha[t - 1][s - 2] > best {
          best = alpha[t - 1][s - 2]
          bestIdx = 2
        }
        alpha[t][s] = best + emit(t, s)
        back[t][s] = -bestIdx
      }
    }
    var s = S - 1
    if S >= 2, alpha[T - 1][S - 2] > alpha[T - 1][S - 1] { s = S - 2 }
    var path = Array(repeating: 0, count: T)
    path[T - 1] = s
    for t in stride(from: T - 1, through: 1, by: -1) {
      s = s + Int(back[t][s])
      path[t - 1] = s
    }
    var intervals: [TokenInterval] = []
    var tokenIndex = 0
    var start: Int?
    for t in 0..<T {
      let state = path[t]
      let isToken = state % 2 == 1
      if isToken {
        let thisToken = state / 2
        if start == nil {
          start = t
          tokenIndex = thisToken
        } else if thisToken != tokenIndex {
          intervals.append(
            TokenInterval(tokenId: tokenIds[tokenIndex], tokenIndex: tokenIndex, startFrame: start!, endFrame: t)
          )
          start = t
          tokenIndex = thisToken
        }
      } else if let st = start {
        intervals.append(
          TokenInterval(tokenId: tokenIds[tokenIndex], tokenIndex: tokenIndex, startFrame: st, endFrame: t)
        )
        start = nil
      }
    }
    if let st = start, tokenIndex < tokenIds.count {
      intervals.append(
        TokenInterval(tokenId: tokenIds[tokenIndex], tokenIndex: tokenIndex, startFrame: st, endFrame: T)
      )
    }
    return intervals
  }

  func testCtcAlignerFlatMatchesNestedAndIsFaster() throws {
    let blank = CtcAligner.blankId
    let vocab = blank + 1
    let T = 400
    let tokenIds = Array(repeating: [0, 1, 2, 3, 4], count: 8).flatMap { $0 }
    var logprobs = [[Float]](repeating: [Float](repeating: -8, count: vocab), count: T)
    for t in 0..<T {
      let id = tokenIds[min(t / max(1, T / tokenIds.count), tokenIds.count - 1)]
      logprobs[t][id] = 0
      logprobs[t][blank] = -1
    }

    let nested = try forcedAlignNestedReference(logprobs: logprobs, tokenIds: tokenIds)
    let flat = try CtcAligner.forcedAlign(logprobs: logprobs, tokenIds: tokenIds)
    XCTAssertEqual(nested.map(\.tokenId), flat.map(\.tokenId))
    XCTAssertEqual(nested.map(\.tokenIndex), flat.map(\.tokenIndex))
    XCTAssertEqual(nested.map(\.startFrame), flat.map(\.startFrame))
    XCTAssertEqual(nested.map(\.endFrame), flat.map(\.endFrame))

    let rounds = 8
    // Warmup
    _ = try forcedAlignNestedReference(logprobs: logprobs, tokenIds: tokenIds)
    _ = try CtcAligner.forcedAlign(logprobs: logprobs, tokenIds: tokenIds)

    let tNest0 = CFAbsoluteTimeGetCurrent()
    for _ in 0..<rounds {
      _ = try forcedAlignNestedReference(logprobs: logprobs, tokenIds: tokenIds)
    }
    let nestedMs = (CFAbsoluteTimeGetCurrent() - tNest0) * 1000 / Double(rounds)

    let tFlat0 = CFAbsoluteTimeGetCurrent()
    for _ in 0..<rounds {
      _ = try CtcAligner.forcedAlign(logprobs: logprobs, tokenIds: tokenIds)
    }
    let flatMs = (CFAbsoluteTimeGetCurrent() - tFlat0) * 1000 / Double(rounds)

    print(
      String(
        format: "[TajweedPerf] ctcForcedAlign T=%d tokens=%d nested=%.2fms flat=%.2fms speedup=%.2fx",
        T, tokenIds.count, nestedMs, flatMs, nestedMs / max(flatMs, 0.001)
      )
    )
    // Flat should not be meaningfully slower (allow noise); primary gate is identity.
    XCTAssertLessThanOrEqual(flatMs, nestedMs * 1.35)
  }

  func testMLMultiArrayFloatCopyMatchesNSNumberPath() throws {
    let rows = 120
    let cols = 1025
    var source = [Float](repeating: 0, count: rows * cols)
    for i in 0..<source.count {
      source[i] = Float(i % 997) * 0.001
    }
    let array = try MLMultiArray(shape: [1, NSNumber(value: rows), NSNumber(value: cols)], dataType: .float32)
    for i in 0..<source.count {
      array[i] = NSNumber(value: source[i])
    }

    // Baseline NSNumber parse
    let tOld0 = CFAbsoluteTimeGetCurrent()
    var oldRows = [[Float]](repeating: [Float](repeating: 0, count: cols), count: rows)
    for t in 0..<rows {
      for v in 0..<cols {
        oldRows[t][v] = array[t * cols + v].floatValue
      }
    }
    let oldParseMs = (CFAbsoluteTimeGetCurrent() - tOld0) * 1000

    let tNew0 = CFAbsoluteTimeGetCurrent()
    let newRows = MLMultiArrayFloatCopy.copyRows(from: array, rows: rows, cols: cols)
    let newParseMs = (CFAbsoluteTimeGetCurrent() - tNew0) * 1000

    XCTAssertEqual(oldRows.count, newRows.count)
    for t in 0..<rows {
      XCTAssertEqual(oldRows[t], newRows[t])
    }

    let shaped = try MLMultiArray(shape: [1, NSNumber(value: rows), NSNumber(value: cols)], dataType: .float32)
    let tFillOld0 = CFAbsoluteTimeGetCurrent()
    for i in 0..<source.count {
      shaped[i] = NSNumber(value: source[i])
    }
    let oldFillMs = (CFAbsoluteTimeGetCurrent() - tFillOld0) * 1000

    let shapedFast = try MLMultiArray(shape: [1, NSNumber(value: rows), NSNumber(value: cols)], dataType: .float32)
    let tFillNew0 = CFAbsoluteTimeGetCurrent()
    MLMultiArrayFloatCopy.copy(source, into: shapedFast)
    let newFillMs = (CFAbsoluteTimeGetCurrent() - tFillNew0) * 1000

    for i in 0..<source.count {
      XCTAssertEqual(shaped[i].floatValue, shapedFast[i].floatValue, accuracy: 0)
    }

    print(
      String(
        format: "[TajweedPerf] mlmultiarray parse NSNumber=%.2fms ptr=%.2fms | fill NSNumber=%.2fms ptr=%.2fms",
        oldParseMs, newParseMs, oldFillMs, newFillMs
      )
    )
    XCTAssertLessThan(newParseMs, oldParseMs)
    XCTAssertLessThan(newFillMs, oldFillMs)
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

  func testNormalizeArabicFatihah14IndoPakMatchesImlaeiAsr() {
    let indoPakExpected = "مٰلِکِ یَوۡمِ الدِّیۡنِ ؕ"
    let asrHypothesis = "مَالِكِ يَوْمِ الدِّينِ"
    let expWords = TajweedLexicalScoring.splitWords(indoPakExpected)
    let hypWords = TajweedLexicalScoring.splitWords(asrHypothesis)
    XCTAssertEqual(
      expWords.map { TajweedLexicalScoring.normalizeArabic($0) },
      ["مالك", "يوم", "الدين"]
    )
    XCTAssertEqual(
      hypWords.map { TajweedLexicalScoring.normalizeArabic($0) },
      ["مالك", "يوم", "الدين"]
    )
    let ops = TajweedLexicalScoring.alignWords(expected: expWords, hypothesis: hypWords)
    XCTAssertEqual(ops.count, 3)
    XCTAssertTrue(ops.allSatisfy { $0.op == .match })
  }

  func testNormalizeArabicFoldsIndoPakKehehAndFarsiYeh() {
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ک"), "ك")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ی"), "ي")
  }

  func testNormalizeArabicFoldsHehFamilyAcrossMushafScripts() {
    let canonical = "ه"
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ه"), canonical)
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ہ"), canonical)
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ھ"), canonical)
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ة"), canonical)
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ە"), canonical)
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ۃ"), canonical)
  }

  func testNormalizeArabicLillahIdenticalAcrossScripts() {
    let expected = "لله"
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("لله"), expected)
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("لِلَّهِ"), expected)
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("لِلّٰہِ"), expected)
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("لِلّهِ"), expected)
    XCTAssertEqual(
      TajweedLexicalScoring.normalizeArabic("لله"),
      TajweedLexicalScoring.normalizeArabic("لِلّٰہِ")
    )
  }

  func testNormalizeArabicAllahIdenticalAcrossScripts() {
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ٱللَّهِ"), "الله")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("اللّٰہُ"), "الله")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("الله"), "الله")
  }

  /// IndoPak 1:6 presentation space → lexicalWords merges to اهدنا (generic tokenizer).
  func testLexicalWordsMergesIndoPakIhdinaPresentationSpace() {
    let indoPak = "اِہۡدِ نَا الصِّرَاطَ الۡمُسۡتَقِیۡمَ ۙ"
    let uthmani = "ٱهۡدِنَا ٱلصِّرَٰطَ ٱلۡمُسۡتَقِيمَ"
    let asr = "اهدنا الصراط المستقيم"

    XCTAssertTrue(indoPak.contains("\u{0020}"))
    XCTAssertEqual(
      TajweedLexicalScoring.lexicalWords(indoPak, referenceText: uthmani),
      ["اهدنا", "الصراط", "المستقيم"]
    )
    XCTAssertEqual(
      TajweedLexicalScoring.lexicalWords(uthmani, referenceText: uthmani),
      TajweedLexicalScoring.lexicalWords(indoPak, referenceText: uthmani)
    )
    XCTAssertEqual(
      TajweedLexicalScoring.lexicalWords(asr, referenceText: asr),
      TajweedLexicalScoring.lexicalWords(indoPak, referenceText: uthmani)
    )
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("اِہۡدِ نَا"), "اهدنا")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ٱهۡدِنَا"), "اهدنا")
  }

  /// Every known IndoPak↔Uthmani presentation-boundary case (from corpora on disk).
  func testLexicalWordsAllPresentationSpaceCasesMatchUthmani() throws {
    let uthmaniAyahs = try Self.loadQuranScriptAyahs(fileName: "uthmani.json")
    let indoPakAyahs = try Self.loadQuranScriptAyahs(fileName: "indopak.json")
    XCTAssertGreaterThan(uthmaniAyahs.count, 6000)
    XCTAssertGreaterThan(indoPakAyahs.count, 6000)

    var indoByRef: [String: String] = [:]
    for a in indoPakAyahs {
      indoByRef["\(a.surah):\(a.ayah)"] = a.text
    }

    var checked = 0
    for a in uthmaniAyahs {
      guard let indopak = indoByRef["\(a.surah):\(a.ayah)"] else { continue }
      let uthmani = a.text
      let uthStream = TajweedLexicalScoring.normalizeArabic(uthmani)
      let indoStream = TajweedLexicalScoring.normalizeArabic(indopak)
      guard uthStream == indoStream else { continue }

      let fromUth = TajweedLexicalScoring.lexicalWords(uthmani, referenceText: uthmani)
      let whitespaceSplitIndo = TajweedLexicalScoring.splitWords(indopak).map {
        TajweedLexicalScoring.normalizeArabic($0)
      }
      guard whitespaceSplitIndo != fromUth else { continue }

      let fromIndo = TajweedLexicalScoring.lexicalWords(indopak, referenceText: uthmani)
      XCTAssertEqual(fromUth, fromIndo, "parity \(a.surah):\(a.ayah)")
      checked += 1
    }
    XCTAssertGreaterThan(checked, 100, "expected hundreds of presentation cases, got \(checked)")
    XCTAssertGreaterThanOrEqual(checked, 763)
  }

  private static func loadQuranScriptAyahs(fileName: String) throws -> [(surah: Int, ayah: Int, text: String)] {
    let url = URL(fileURLWithPath: #file)
      .deletingLastPathComponent() // RunnerTests
      .deletingLastPathComponent() // ios
      .deletingLastPathComponent() // repo
      .appendingPathComponent("assets/quran/text/\(fileName)")
    let data = try Data(contentsOf: url)
    let root = try JSONSerialization.jsonObject(with: data) as! [String: Any]
    let ayahs = root["ayahs"] as! [[String: Any]]
    return ayahs.map { a in
      (
        surah: a["surah"] as! Int,
        ayah: a["ayah"] as! Int,
        text: a["text"] as! String
      )
    }
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

  func testNormalizeArabicPhase1OrthographyParity() {
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("عَلٰی"), "علي")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("عَلَىٰ"), "علي")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("عَلَى"), "علي")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ذٰلِکَ"), "ذلك")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ذَٰلِكَ"), "ذلك")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("اُولٰٓئِکَ"), "اولئك")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("أُولَئِكَ"), "اولئك")
  }

  func testNormalizeArabicStripsExtendedQuranicDiacritics() {
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("هُدٗى"), "هدي")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("٭"), "")
  }

  func testNormalizeArabicDaggerAlifAtEndDoesNotTrap() {
    // Regression: UInt32(-1) when next/prev sentinel — must not fatal-error on device.
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("\u{0670}"), "ا")
    XCTAssertEqual(TajweedLexicalScoring.normalizeArabic("ي\u{0670}"), "ي")
  }

  func testSplitAttachedWawHypothesisWordsPeelsClitic() {
    let split = TajweedLexicalScoring.splitAttachedWawHypothesisWords(["وَعَلَى", "وَأُولَئِكَ"])
    XCTAssertEqual(split.map { TajweedLexicalScoring.normalizeArabic($0) }, ["و", "علي", "اولئك"])
  }

  func testPhase1Baqarah25IndoPakExpectedMatchesImlaeiHypothesis() {
    let indoExpected =
      "اُولٰٓئِکَ عَلٰی ہُدًی مِّنۡ رَّبِّہِمۡ ٭ وَ اُولٰٓئِکَ ہُمُ الۡمُفۡلِحُوۡنَ "
    let imlaeiHyp =
      "أُولَئِكَ عَلَى هُدًى مِّن رَّبِّهِمْ وَأُولَئِكَ هُمُ الْمُفْلِحُونَ"
    let uthmaniRef =
      "أُوْلَٰٓئِكَ عَلَىٰ هُدٗى مِّن رَّبِّهِمۡۖ وَأُوْلَٰٓئِكَ هُمُ ٱلۡمُفۡلِحُونَ"
    let expected = TajweedLexicalScoring.prepareExpectedWords(indoExpected, referenceText: uthmaniRef)
    let hyp = TajweedLexicalScoring.prepareHypothesisWords(imlaeiHyp)
    let ops = TajweedLexicalScoring.alignWords(expected: expected, hypothesis: hyp)
    XCTAssertTrue(ops.allSatisfy { $0.op == .match })
    XCTAssertEqual(TajweedLexicalScoring.wordAccuracyScore(expected: expected, hypothesis: hyp), 1.0, accuracy: 0.0001)
  }

  func testMismatchReasonModelForGenuineAsrError() {
    let ops = TajweedLexicalScoring.alignWords(expected: ["الضالين"], hypothesis: ["الاين"])
    XCTAssertEqual(ops.count, 1)
    XCTAssertEqual(ops[0].op, .sub)
    XCTAssertEqual(ops[0].reason, TajweedLexicalScoring.MismatchReason.model)
    XCTAssertEqual(TajweedLexicalScoring.formatOpForLog(ops[0]), "sub(reason=model)")
  }

  // MARK: - ADR-010 M3 canonical lexical authority

  func testCanonicalEvaluatorMatchesDhalikaWithoutDisplayNormalize() {
    CanonicalLexiconStore.installForTesting(
      ayahs: [
        "2:2": CanonicalLexiconStore.AyahLexicon(
          ref: "2:2",
          words: [
            CanonicalLexiconStore.CanonicalWord(
              id: "2:2:0",
              canonical: "ذلك",
              surfaceUthmani: "ذَٰلِكَ",
              surfaceIndopak: "ذٰلِکَ",
              surfaceImlaei: "ذَٰلِكَ"
            ),
          ]
        ),
      ]
    )
    defer { CanonicalLexiconStore.resetForTesting() }

    // IndoPak display would normalize to ذالك under legacy; ASR says ذلك.
    let hyp = TajweedLexicalScoring.prepareHypothesisWords("ذَٰلِكَ")
    let eval = CanonicalLexicalEvaluator.evaluate(surah: 2, ayah: 2, hypothesisWords: hyp)
    XCTAssertNotNil(eval)
    XCTAssertEqual(eval?.ops.count, 1)
    XCTAssertEqual(eval?.ops.first?.op, .match)
    XCTAssertEqual(eval?.ops.first?.text, "ذَٰلِكَ")
  }

  func testCanonicalEvaluatorRematerializesAttachedWaw() {
    CanonicalLexiconStore.installForTesting(
      ayahs: [
        "1:7": CanonicalLexiconStore.AyahLexicon(
          ref: "1:7",
          words: [
            CanonicalLexiconStore.CanonicalWord(
              id: "1:7:0", canonical: "غير", surfaceUthmani: "غَيۡرِ",
              surfaceIndopak: "", surfaceImlaei: ""
            ),
            CanonicalLexiconStore.CanonicalWord(
              id: "1:7:1", canonical: "المغضوب", surfaceUthmani: "ٱلۡمَغۡضُوبِ",
              surfaceIndopak: "", surfaceImlaei: ""
            ),
            CanonicalLexiconStore.CanonicalWord(
              id: "1:7:2", canonical: "عليهم", surfaceUthmani: "عَلَيۡهِمۡ",
              surfaceIndopak: "", surfaceImlaei: ""
            ),
            CanonicalLexiconStore.CanonicalWord(
              id: "1:7:3", canonical: "ولا", surfaceUthmani: "وَلَا",
              surfaceIndopak: "", surfaceImlaei: ""
            ),
            CanonicalLexiconStore.CanonicalWord(
              id: "1:7:4", canonical: "الضالين", surfaceUthmani: "ٱلضَّآلِّينَ",
              surfaceIndopak: "", surfaceImlaei: ""
            ),
          ]
        ),
      ]
    )
    defer { CanonicalLexiconStore.resetForTesting() }

    let hyp = TajweedLexicalScoring.prepareHypothesisWords("غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ")
    let eval = CanonicalLexicalEvaluator.evaluate(surah: 1, ayah: 7, hypothesisWords: hyp)
    XCTAssertNotNil(eval)
    XCTAssertTrue(eval!.ops.allSatisfy { $0.op == .match }, "ops=\(eval!.ops.map { TajweedLexicalScoring.formatOpForLog($0) })")
  }

  func testCanonicalAuthorityAlwaysOn() {
    CanonicalLexicalAuthority.clearOverride()
    XCTAssertTrue(CanonicalLexicalAuthority.productionEnabled)
    CanonicalLexicalAuthority.productionEnabled = false
    XCTAssertTrue(
      CanonicalLexicalAuthority.productionEnabled,
      "Canonical remains on even if a client attempts to disable it"
    )
    CanonicalLexicalAuthority.clearOverride()
    XCTAssertTrue(CanonicalLexicalAuthority.productionEnabled)
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
