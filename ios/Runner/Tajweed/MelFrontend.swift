import Accelerate
import Foundation

/// NeMo-compatible log-mel frontend (see tajweed-lab/web/asr/mel.py + COREML_CONTRACT.md).
enum MelFrontend {
  static let sampleRate = 16_000
  static let nFFT = 512
  static let hopLen = 160
  static let nMels = 80
  static let preemph: Float = 0.97
  static let logEps: Float = 1e-5

  private static let melFilterbank: [Float] = makeMelFilterbank()
  private static let hannWindow: [Float] = makeHannWindow(nFFT)

  /// Returns mel features shaped as flat `[80 * T]` in row-major (mel, time), plus time `T`.
  static func logMel(pcm: [Float]) throws -> (features: [Float], time: Int) {
    guard pcm.count > nFFT else {
      throw TajweedNativeError(TajweedErrorCode.audioTooShort, "Audio too short for mel features.")
    }

    var wav = pcm
    // Pre-emphasis
    if wav.count > 1 {
      var prev = wav[0]
      for i in 1..<wav.count {
        let x = wav[i]
        wav[i] = x - preemph * prev
        prev = x
      }
    }

    // Reflect pad nFFT/2 on both sides
    let pad = nFFT / 2
    var padded = [Float](repeating: 0, count: wav.count + pad * 2)
    for i in 0..<pad {
      padded[pad - 1 - i] = wav[min(i + 1, wav.count - 1)]
      padded[pad + wav.count + i] = wav[max(0, wav.count - 2 - i)]
    }
    for i in 0..<wav.count {
      padded[pad + i] = wav[i]
    }

    let nFrames = 1 + (padded.count - nFFT) / hopLen
    guard nFrames > 0 else {
      throw TajweedNativeError(TajweedErrorCode.audioTooShort, "No mel frames.")
    }

    let window = hannWindow

    var powerSpec = [Float](repeating: 0, count: nFrames * (nFFT / 2 + 1))
    var frame = [Float](repeating: 0, count: nFFT)
    var realp = [Float](repeating: 0, count: nFFT / 2)
    var imagp = [Float](repeating: 0, count: nFFT / 2)
    var magnitudes = [Float](repeating: 0, count: nFFT / 2 + 1)

    let log2n = vDSP_Length(log2(Float(nFFT)))
    guard let setup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else {
      throw TajweedNativeError(TajweedErrorCode.inferenceFailed, "FFT setup failed.")
    }
    defer { vDSP_destroy_fftsetup(setup) }

    for t in 0..<nFrames {
      let start = t * hopLen
      for i in 0..<nFFT {
        frame[i] = padded[start + i] * window[i]
      }
      // Pack for real FFT
      realp.withUnsafeMutableBufferPointer { rp in
        imagp.withUnsafeMutableBufferPointer { ip in
          var split = DSPSplitComplex(realp: rp.baseAddress!, imagp: ip.baseAddress!)
          frame.withUnsafeBufferPointer { fb in
            fb.baseAddress!.withMemoryRebound(to: DSPComplex.self, capacity: nFFT / 2) { complex in
              vDSP_ctoz(complex, 2, &split, 1, vDSP_Length(nFFT / 2))
            }
          }
          vDSP_fft_zrip(setup, &split, 1, log2n, FFTDirection(kFFTDirection_Forward))
          // Power spectrum
          magnitudes[0] = split.realp[0] * split.realp[0]
          magnitudes[nFFT / 2] = split.imagp[0] * split.imagp[0]
          for k in 1..<(nFFT / 2) {
            let re = split.realp[k]
            let im = split.imagp[k]
            magnitudes[k] = re * re + im * im
          }
        }
      }
      // Scale for real FFT convention (vDSP)
      var scale: Float = 1.0 / 4.0
      vDSP_vsmul(magnitudes, 1, &scale, &magnitudes, 1, vDSP_Length(nFFT / 2 + 1))
      for k in 0...(nFFT / 2) {
        powerSpec[t * (nFFT / 2 + 1) + k] = magnitudes[k]
      }
    }

    // Mel projection: (nMels, nFFT/2+1) @ (nFFT/2+1, T) → (nMels, T)
    var mel = [Float](repeating: 0, count: nMels * nFrames)
    let bins = nFFT / 2 + 1
    for m in 0..<nMels {
      for t in 0..<nFrames {
        var sum: Float = 0
        let fbRow = m * bins
        let psRow = t * bins
        for k in 0..<bins {
          sum += melFilterbank[fbRow + k] * powerSpec[psRow + k]
        }
        mel[m * nFrames + t] = logf(sum + logEps)
      }
    }

    // Per-bin mean/var normalize across time
    for m in 0..<nMels {
      let offset = m * nFrames
      var mean: Float = 0
      mel.withUnsafeBufferPointer { buf in
        vDSP_meanv(buf.baseAddress! + offset, 1, &mean, vDSP_Length(nFrames))
      }
      var negMean = -mean
      mel.withUnsafeMutableBufferPointer { buf in
        let row = buf.baseAddress! + offset
        vDSP_vsadd(row, 1, &negMean, row, 1, vDSP_Length(nFrames))
        var variance: Float = 0
        vDSP_measqv(row, 1, &variance, vDSP_Length(nFrames))
        var inv = 1.0 / (sqrtf(variance) + 1e-5)
        vDSP_vsmul(row, 1, &inv, row, 1, vDSP_Length(nFrames))
      }
    }

    return (mel, nFrames)
  }

  /// Default mel-time buckets for the official HF offline-ANE multifunction
  /// pack (`predict_T80…T4800`). Prefer the active manifest's `encoderBuckets`
  /// at runtime so alternate packs can ship different bucket lists without a
  /// Swift change — see `ModelStore.encoderApi()`.
  static let defaultOfficialBuckets = [80, 200, 400, 800, 1600, 2400, 4800]

  /// Nearest supported CoreML bucket ≥ `time` from `buckets` (ascending).
  static func padToBucket(
    _ features: [Float],
    time: Int,
    buckets: [Int] = MelFrontend.defaultOfficialBuckets
  ) throws -> (padded: [Float], bucketT: Int) {
    let sorted = buckets.sorted()
    guard !sorted.isEmpty else {
      throw TajweedNativeError(TajweedErrorCode.modelLoadFailed, "encoderBuckets is empty.")
    }
    guard let bucket = sorted.first(where: { $0 >= time }) else {
      throw TajweedNativeError(
        TajweedErrorCode.audioTooLong,
        "Audio exceeds \(sorted.last!)-frame CoreML limit."
      )
    }
    if time == bucket { return (features, bucket) }
    var out = [Float](repeating: 0, count: nMels * bucket)
    // Copy each mel-row prefix; trailing pad stays 0 (identical to nested loops).
    features.withUnsafeBufferPointer { src in
      out.withUnsafeMutableBufferPointer { dst in
        guard let s = src.baseAddress, let d = dst.baseAddress else { return }
        for m in 0..<nMels {
          d.advanced(by: m * bucket).update(from: s.advanced(by: m * time), count: time)
        }
      }
    }
    return (out, bucket)
  }

  /// Zero-pads `features` (row-major `[80 * time]`) up to a single fixed `T`,
  /// used by non-multifunction (e.g. DIY-exported) CoreML encoders that only
  /// support one static input shape. Unlike `padToBucket`, callers must also
  /// pass the true `time` as a separate `length` model input — the DIY encoder
  /// keeps `length` as an explicit graph input (unlike the official multifunction
  /// packages, whose per-bucket functions bake the length in).
  static func padToFixed(_ features: [Float], time: Int, fixedT: Int) throws -> [Float] {
    guard time <= fixedT else {
      throw TajweedNativeError(
        TajweedErrorCode.audioTooLong, "Audio exceeds \(fixedT)-frame CoreML limit."
      )
    }
    if time == fixedT { return features }
    var out = [Float](repeating: 0, count: nMels * fixedT)
    for m in 0..<nMels {
      for t in 0..<time {
        out[m * fixedT + t] = features[m * time + t]
      }
    }
    return out
  }

  /// Symmetric Hann window matching numpy's `np.hanning(N)` exactly (denominator N-1) —
  /// same formula as Android's `MelFrontend.kt` `makeHannWindow` and the Python reference
  /// (`tajweed-lab/web/asr/mel.py`, `np.hanning(N_FFT)`). Computed manually in `Double`
  /// precision (matching Android) rather than via `vDSP_hann_window`'s `vDSP_HANN_NORM`
  /// flag, which applies Accelerate's own normalization and produces a measurably
  /// different window shape (TD-009) — not just a per-frame constant scale, which is why
  /// per-bin CMVN normalization did not fully cancel the discrepancy on real audio.
  private static func makeHannWindow(_ n: Int) -> [Float] {
    var w = [Float](repeating: 0, count: n)
    for i in 0..<n {
      w[i] = Float(0.5 - 0.5 * cos(2.0 * Double.pi * Double(i) / Double(n - 1)))
    }
    return w
  }

  private static func makeMelFilterbank() -> [Float] {
    let sr = Float(sampleRate)
    let nFft = nFFT
    let nMelsLocal = nMels
    let melMax = 1127.0 * logf(1.0 + (sr / 2) / 700.0)
    var melPts = [Float](repeating: 0, count: nMelsLocal + 2)
    for i in 0..<melPts.count {
      melPts[i] = melMax * Float(i) / Float(nMelsLocal + 1)
    }
    var hzPts = melPts.map { 700.0 * (expf($0 / 1127.0) - 1.0) }
    var binPts = hzPts.map { Int(floor((Float(nFft + 1) * $0) / sr)) }
    var fb = [Float](repeating: 0, count: nMelsLocal * (nFft / 2 + 1))
    for m in 1...nMelsLocal {
      let left = binPts[m - 1]
      let center = binPts[m]
      let right = binPts[m + 1]
      if center != left {
        for k in left..<center {
          fb[(m - 1) * (nFft / 2 + 1) + k] = Float(k - left) / Float(center - left)
        }
      }
      if right != center {
        for k in center..<right {
          fb[(m - 1) * (nFft / 2 + 1) + k] = Float(right - k) / Float(right - center)
        }
      }
    }
    return fb
  }
}
