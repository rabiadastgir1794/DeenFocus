import Flutter
import Foundation

/// MethodChannel + EventChannel wiring for Tajweed (ADR-006).
final class TajweedChannelHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  private var didBindEngineEvents = false

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
    // Do not touch TajweedEngine.shared here — constructing it creates
    // AVAudioEngine and would run on the launch path before first Flutter frame.
    method.setMethodCallHandler { [weak self] call, result in
      self?.handle(call: call, result: result)
    }
  }

  private func bindEngineEventsIfNeeded() {
    guard !didBindEngineEvents else { return }
    didBindEngineEvents = true
    TajweedEngine.shared.onEvent = { [weak self] payload in
      self?.eventSink?(payload)
    }
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    // Do not construct TajweedEngine here — practice VM may listen before
    // ensureModel; engine is created on the first method that needs it.
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
    // Flag get/set must not construct TajweedEngine — Settings can call these
    // while IndexedStack builds the Settings tab during first home paint.
    switch call.method {
    case "getCanonicalLexicalProductionEnabled":
      DispatchQueue.main.async {
        result(
          [
            "enabled": CanonicalLexicalAuthority.productionEnabled,
            "defaultsKey": CanonicalLexicalAuthority.defaultsKey,
          ] as [String: Any]
        )
      }
      return
    case "setCanonicalLexicalProductionEnabled":
      guard
        let args = call.arguments as? [String: Any],
        let enabled = CanonicalLexicalAuthority.parseEnabledArgument(args["enabled"])
      else {
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: TajweedErrorCode.invalidArgs,
              message: "enabled: Bool required (got \(String(describing: (call.arguments as? [String: Any])?["enabled"])))",
              details: nil
            )
          )
        }
        return
      }
      CanonicalLexicalAuthority.productionEnabled = enabled
      DispatchQueue.main.async {
        result(
          [
            "enabled": CanonicalLexicalAuthority.productionEnabled,
            "defaultsKey": CanonicalLexicalAuthority.defaultsKey,
          ] as [String: Any]
        )
      }
      return
    default:
      break
    }

    bindEngineEventsIfNeeded()
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
      let lexicalRef = args["lexicalReferenceArabic"] as? String
      TajweedEngine.shared.startRecording(
        surah: surah,
        ayah: ayah,
        expectedArabic: expected,
        lexicalReferenceArabic: lexicalRef
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
    case "getDevCoreMlSource":
      DispatchQueue.main.async {
        result(
          [
            "source": TajweedDevModelOverride.preferredSource.rawValue,
            "overrideAllowed": TajweedDevModelOverride.isAllowed,
          ] as [String: Any]
        )
      }
    case "setDevCoreMlSource":
      guard TajweedDevModelOverride.isAllowed else {
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: TajweedErrorCode.unsupported,
              message:
                "CoreML debug override requires a Debug build (SWIFT DEBUG flag). "
                + "Do a full rebuild: flutter clean && flutter run (not Profile/Release).",
              details: nil
            )
          )
        }
        return
      }
      guard
        let args = call.arguments as? [String: Any],
        let raw = args["source"] as? String,
        let source = TajweedDevModelSource(rawValue: raw)
      else {
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: TajweedErrorCode.invalidArgs,
              message: "source must be catalog|official|diy",
              details: nil
            )
          )
        }
        return
      }
      TajweedDevModelOverride.preferredSource = source
      TajweedDevModelOverride.markForceResync()
      TajweedEngine.shared.dispose()
      DispatchQueue.main.async { result(nil) }
    case "getActiveCoreMlInfo":
      var info: [String: Any] = [
        "available": ModelStore.shared.isAvailable(),
        "overrideAllowed": TajweedDevModelOverride.isAllowed,
        "devSource": TajweedDevModelOverride.preferredSource.rawValue,
        "packMatchesSelection": TajweedDevModelOverride.activePackMatchesSelection(
          manifest: {
            guard let data = try? Data(contentsOf: ModelStore.shared.manifestURL),
                  let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { return nil }
            return obj
          }()
        ),
      ]
      if let m = try? Data(contentsOf: ModelStore.shared.manifestURL),
         let obj = try? JSONSerialization.jsonObject(with: m) as? [String: Any]
      {
        info["version"] = obj["version"] as? String ?? ""
        info["encoderApi"] = obj["encoderApi"] as? String ?? "multifunction"
        info["encoder"] = obj["encoder"] as? String ?? ""
      }
      info["encoderSha256"] = ModelStore.shared.activeEncoderSha256()
      info["manifestVersion"] = ModelStore.shared.activeManifestVersion()
      switch ModelStore.shared.encoderApi() {
      case .multifunction(let buckets):
        info["resolvedApi"] = "multifunction"
        info["encoderBuckets"] = buckets
      case .singleFunctionFixedLength(let t):
        info["resolvedApi"] = "single_function_fixed"
        info["encoderFixedT"] = t
      }
      DispatchQueue.main.async { result(info) }
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
