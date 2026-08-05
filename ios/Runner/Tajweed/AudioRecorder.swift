import AVFoundation
import Foundation

/// Native PCM capture at 16 kHz mono via AVAudioEngine.
final class TajweedAudioRecorder {
  /// Lazy — constructing `AVAudioEngine` during AppDelegate launch has caused
  /// launch-screen hangs on device when TajweedEngine was eagerly created.
  private var _engine: AVAudioEngine?
  private var engine: AVAudioEngine {
    if let existing = _engine { return existing }
    let created = AVAudioEngine()
    _engine = created
    return created
  }

  private var buffers: [Float] = []
  private let lock = NSLock()
  private(set) var isRecording = false
  var onInterrupted: ((String) -> Void)?

  private let targetSampleRate: Double = 16_000

  func start() throws {
    lock.lock()
    defer { lock.unlock() }
    guard !isRecording else {
      throw TajweedNativeError(TajweedErrorCode.alreadyRecording, "Already recording.")
    }

    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(
        .playAndRecord,
        mode: .measurement,
        options: [.defaultToSpeaker, .allowBluetoothHFP]
      )
      try session.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      throw TajweedNativeError(
        TajweedErrorCode.micPermissionDenied,
        "Failed to activate audio session: \(error.localizedDescription)"
      )
    }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleInterruption(_:)),
      name: AVAudioSession.interruptionNotification,
      object: session
    )

    buffers.removeAll(keepingCapacity: true)
    let audioEngine = engine
    let input = audioEngine.inputNode
    let format = input.outputFormat(forBus: 0)
    guard format.sampleRate > 0, format.channelCount > 0 else {
      throw TajweedNativeError(TajweedErrorCode.micBusy, "Input format unavailable.")
    }

    let converterFormat = AVAudioFormat(
      commonFormat: .pcmFormatFloat32,
      sampleRate: targetSampleRate,
      channels: 1,
      interleaved: false
    )!

    input.removeTap(onBus: 0)
    input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
      self?.append(buffer: buffer, sourceFormat: format, targetFormat: converterFormat)
    }

    audioEngine.prepare()
    do {
      try audioEngine.start()
    } catch {
      input.removeTap(onBus: 0)
      throw TajweedNativeError(TajweedErrorCode.micBusy, error.localizedDescription)
    }
    isRecording = true
  }

  func stop() -> [Float] {
    lock.lock()
    defer { lock.unlock() }
    if isRecording, let audioEngine = _engine {
      audioEngine.inputNode.removeTap(onBus: 0)
      audioEngine.stop()
      isRecording = false
    }
    NotificationCenter.default.removeObserver(
      self,
      name: AVAudioSession.interruptionNotification,
      object: nil
    )
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    return buffers
  }

  func cancel() {
    _ = stop()
    lock.lock()
    buffers.removeAll(keepingCapacity: false)
    lock.unlock()
  }

  private func append(
    buffer: AVAudioPCMBuffer,
    sourceFormat: AVAudioFormat,
    targetFormat: AVAudioFormat
  ) {
    guard let channelData = buffer.floatChannelData else { return }
    let frameCount = Int(buffer.frameLength)
    if sourceFormat.sampleRate == targetSampleRate, sourceFormat.channelCount == 1 {
      let ptr = channelData[0]
      lock.lock()
      buffers.append(contentsOf: UnsafeBufferPointer(start: ptr, count: frameCount))
      lock.unlock()
      return
    }

    // Downmix + resample via converter when needed.
    guard let converter = AVAudioConverter(from: sourceFormat, to: targetFormat) else { return }
    let ratio = targetFormat.sampleRate / sourceFormat.sampleRate
    let outCapacity = AVAudioFrameCount(Double(frameCount) * ratio) + 32
    guard let outBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: outCapacity)
    else { return }

    var error: NSError?
    var consumed = false
    converter.convert(to: outBuffer, error: &error) { _, outStatus in
      if consumed {
        outStatus.pointee = .noDataNow
        return nil
      }
      consumed = true
      outStatus.pointee = .haveData
      return buffer
    }
    if error != nil { return }
    guard let outData = outBuffer.floatChannelData else { return }
    let outFrames = Int(outBuffer.frameLength)
    lock.lock()
    buffers.append(contentsOf: UnsafeBufferPointer(start: outData[0], count: outFrames))
    lock.unlock()
  }

  @objc private func handleInterruption(_ note: Notification) {
    guard
      let info = note.userInfo,
      let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
      let type = AVAudioSession.InterruptionType(rawValue: typeValue),
      type == .began
    else { return }
    cancel()
    onInterrupted?("phone_call")
  }
}
