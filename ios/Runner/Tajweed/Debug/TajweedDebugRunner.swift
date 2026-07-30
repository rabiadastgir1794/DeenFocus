import AVFoundation
import Foundation

#if DEBUG
/// Native-only harness to validate CoreML pipeline without Flutter UI.
///
/// Usage (Debugger / temporary call from AppDelegate DEBUG):
/// ```
/// TajweedDebugRunner.runSamplePipeline(
///   modelDirectory: URL(fileURLWithPath: ".../Documents/TajweedImport"),
///   wavPath: URL(fileURLWithPath: ".../sample.wav"),
///   expectedArabic: "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
///   surah: 1,
///   ayah: 1
/// )
/// ```
enum TajweedDebugRunner {
  static func installModels(from directory: URL) throws {
    try ModelStore.shared.installFromDirectory(directory) { p in
      print("[TajweedDebug] install progress \(p)")
    }
  }

  static func runSamplePipeline(
    modelDirectory: URL?,
    wavPath: URL,
    expectedArabic: String,
    surah: Int,
    ayah: Int
  ) {
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let coldStart = CFAbsoluteTimeGetCurrent()
        if let modelDirectory {
          try installModels(from: modelDirectory)
        }
        guard ModelStore.shared.isAvailable() else {
          print("[TajweedDebug] MODEL_MISSING — place pack in Documents/TajweedImport")
          return
        }

        let pcm = try loadWavMono16k(wavPath)
        let coldMs = (CFAbsoluteTimeGetCurrent() - coldStart) * 1000

        // Force unload then warm for cold/warm measurements.
        TajweedEngine.shared.dispose()
        Thread.sleep(forTimeInterval: 0.2)

        let warmStart = CFAbsoluteTimeGetCurrent()
        let result = try TajweedEngine.shared.scorePCMForDebug(
          pcm: pcm,
          surah: surah,
          ayah: ayah,
          expectedArabic: expectedArabic
        )
        let warmMs = (CFAbsoluteTimeGetCurrent() - warmStart) * 1000

        let data = try JSONSerialization.data(
          withJSONObject: result.report,
          options: [.prettyPrinted, .sortedKeys]
        )
        let json = String(data: data, encoding: .utf8) ?? "{}"
        print("[TajweedDebug] === score JSON ===")
        print(json)
        print(
          "[TajweedDebug] timings coldSetupMs=\(String(format: "%.1f", coldMs)) totalWarmPathMs=\(String(format: "%.1f", warmMs)) detail=\(result.timingsMs)"
        )
      } catch let e as TajweedNativeError {
        print("[TajweedDebug] ERROR \(e.code): \(e.message)")
      } catch {
        print("[TajweedDebug] ERROR \(error)")
      }
    }
  }

  private static func loadWavMono16k(_ url: URL) throws -> [Float] {
    let file = try AVAudioFile(forReading: url)
    let format = file.processingFormat
    let frameCount = AVAudioFrameCount(file.length)
    guard
      let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
    else {
      throw TajweedNativeError(TajweedErrorCode.inferenceFailed, "Could not allocate wav buffer.")
    }
    try file.read(into: buffer)
    guard let channels = buffer.floatChannelData else {
      throw TajweedNativeError(TajweedErrorCode.inferenceFailed, "No float channel data.")
    }
    var mono = [Float](repeating: 0, count: Int(buffer.frameLength))
    let ch = Int(format.channelCount)
    for i in 0..<Int(buffer.frameLength) {
      var sum: Float = 0
      for c in 0..<ch {
        sum += channels[c][i]
      }
      mono[i] = sum / Float(ch)
    }
    if format.sampleRate == 16_000 {
      return mono
    }
    // Linear resample to 16 kHz
    let ratio = 16_000 / format.sampleRate
    let outCount = Int(Double(mono.count) * ratio)
    var out = [Float](repeating: 0, count: outCount)
    for i in 0..<outCount {
      let src = Double(i) / ratio
      let i0 = Int(src)
      let i1 = min(i0 + 1, mono.count - 1)
      let frac = Float(src - Double(i0))
      out[i] = mono[i0] * (1 - frac) + mono[i1] * frac
    }
    return out
  }
}
#endif
