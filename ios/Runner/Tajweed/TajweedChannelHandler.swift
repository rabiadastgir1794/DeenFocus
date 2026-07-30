import Flutter
import Foundation

/// MethodChannel + EventChannel wiring for Tajweed (ADR-006).
final class TajweedChannelHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  func register(messenger: FlutterBinaryMessenger) {
    let method = FlutterMethodChannel(
      name: "com.app.deenly.deenly/tajweed",
      binaryMessenger: messenger
    )
    let events = FlutterEventChannel(
      name: "com.app.deenly.deenly/tajweed_events",
      binaryMessenger: messenger
    )
    events.setStreamHandler(self)
    TajweedEngine.shared.onEvent = { [weak self] payload in
      self?.eventSink?(payload)
    }
    method.setMethodCallHandler { [weak self] call, result in
      self?.handle(call: call, result: result)
    }
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      result(TajweedEngine.shared.isAvailable())
    case "getRecordingState":
      result(TajweedEngine.shared.getRecordingState())
    case "ensureModel":
      TajweedEngine.shared.ensureModel { [weak self] outcome in
        self?.deliver(outcome, result: result)
      }
    case "prepareModel":
      TajweedEngine.shared.prepareModel { [weak self] outcome in
        self?.deliver(outcome, result: result)
      }
    case "startRecording":
      guard
        let args = call.arguments as? [String: Any],
        let surah = args["surah"] as? Int,
        let ayah = args["ayah"] as? Int,
        let expected = args["expectedArabic"] as? String
      else {
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: TajweedErrorCode.invalidArgs,
              message: "surah, ayah, expectedArabic required",
              details: nil
            )
          )
        }
        return
      }
      TajweedEngine.shared.startRecording(
        surah: surah,
        ayah: ayah,
        expectedArabic: expected
      ) { [weak self] outcome in
        self?.deliver(outcome, result: result)
      }
    case "stopRecordingAndScore":
      TajweedEngine.shared.stopRecordingAndScore { [weak self] outcome in
        self?.deliverJSON(outcome, result: result)
      }
    case "cancelRecording":
      TajweedEngine.shared.cancelRecording { [weak self] outcome in
        self?.deliver(outcome, result: result)
      }
    case "dispose":
      TajweedEngine.shared.dispose()
      DispatchQueue.main.async { result(nil) }
    default:
      DispatchQueue.main.async { result(FlutterMethodNotImplemented) }
    }
  }

  /// Every native completion crosses back to the main thread exactly once here —
  /// Flutter's platform channels require FlutterResult to be invoked on the main thread.
  private func deliver(
    _ outcome: Result<Void, TajweedNativeError>,
    result: @escaping FlutterResult
  ) {
    DispatchQueue.main.async {
      switch outcome {
      case .success: result(nil)
      case .failure(let e): result(Self.flutterError(e))
      }
    }
  }

  private func deliverJSON(
    _ outcome: Result<[String: Any], TajweedNativeError>,
    result: @escaping FlutterResult
  ) {
    DispatchQueue.main.async {
      switch outcome {
      case .success(let json): result(json)
      case .failure(let e): result(Self.flutterError(e))
      }
    }
  }

  static func flutterError(_ e: TajweedNativeError) -> FlutterError {
    FlutterError(code: e.code, message: e.message, details: nil)
  }
}
