import Flutter
import UIKit
import TikTokBusinessSDK

/// MethodChannel bridge for the official TikTok App Events iOS SDK.
enum TikTokAppEventsBridge {
  static let channelName = "com.app.deenly.deenly/tiktok_app_events"

  private static var initialized = false

  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "initialize":
        let args = call.arguments as? [String: Any] ?? [:]
        let ok = initialize(
          appId: (args["appId"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
          ttAppId: (args["ttAppId"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
          appSecret: (args["appSecret"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
          debug: args["debug"] as? Bool ?? false
        )
        result(["ok": ok, "initialized": initialized])
      case "isInitialized":
        result(initialized)
      case "trackPurchase":
        trackPurchase(args: call.arguments as? [String: Any] ?? [:])
        result(true)
      case "trackSubscribe":
        trackStandard(eventName: "Subscribe", args: call.arguments as? [String: Any] ?? [:])
        result(true)
      case "trackStartTrial":
        trackStandard(eventName: "StartTrial", args: call.arguments as? [String: Any] ?? [:])
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  /// Call from AppDelegate so install/launch events are attributed.
  static func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) {
    // TikTok SDK initialization happens via Flutter MethodChannel after credentials
    // are loaded from dart-defines. Early call here is optional for auto-events.
  }

  @discardableResult
  private static func initialize(
    appId: String,
    ttAppId: String,
    appSecret: String,
    debug: Bool
  ) -> Bool {
    if initialized { return true }
    guard !appId.isEmpty, !ttAppId.isEmpty, !appSecret.isEmpty else {
      NSLog("[TikTokAppEvents] Skipping init; missing appId/ttAppId/appSecret")
      return false
    }

    // TikTokConfig(accessToken, appId, tiktokAppId) - accessToken is the app secret
    guard let config = TikTokConfig(accessToken: appSecret, appId: appId, tiktokAppId: ttAppId) else {
      NSLog("[TikTokAppEvents] Failed to create TikTokConfig")
      return false
    }

    // Disable automatic payment tracking; we'll track manually after Superwall confirmation
    config.disablePaymentTracking()

    if debug {
      config.enableDebugMode()
    }

    TikTokBusiness.initializeSdk(config) { success, error in
      if success {
        NSLog("[TikTokAppEvents] TikTok SDK initialized")
      } else {
        NSLog("[TikTokAppEvents] TikTok SDK init failed: \(error?.localizedDescription ?? "unknown")")
      }
    }

    initialized = true
    return true
  }

  private static func trackPurchase(args: [String: Any]) {
    guard initialized else { return }

    let event = TikTokBaseEvent(eventName: "Purchase")
    
    if let contentId = string(args["contentId"]), !contentId.isEmpty {
      event.addProperty(withKey: "content_id", value: contentId)
    }
    if let contentType = string(args["contentType"]), !contentType.isEmpty {
      event.addProperty(withKey: "content_type", value: contentType)
    }
    if let description = string(args["description"]), !description.isEmpty {
      event.addProperty(withKey: "description", value: description)
    }
    if let currencyCode = string(args["currency"]), !currencyCode.isEmpty {
      event.addProperty(withKey: "currency", value: currencyCode.uppercased())
    }
    if let value = number(args["value"]) {
      event.addProperty(withKey: "value", value: NSNumber(value: value))
    }

    TikTokBusiness.trackTTEvent(event)
  }

  private static func trackStandard(eventName: String, args: [String: Any]) {
    guard initialized else { return }

    let event = TikTokBaseEvent(eventName: eventName)
    
    if let contentId = string(args["contentId"]), !contentId.isEmpty {
      event.addProperty(withKey: "content_id", value: contentId)
    }
    if let currencyCode = string(args["currency"]), !currencyCode.isEmpty {
      event.addProperty(withKey: "currency", value: currencyCode.uppercased())
    }
    if let value = number(args["value"]) {
      event.addProperty(withKey: "value", value: NSNumber(value: value))
    }

    TikTokBusiness.trackTTEvent(event)
  }

  private static func string(_ value: Any?) -> String? {
    if let s = value as? String {
      return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return nil
  }

  private static func number(_ value: Any?) -> Double? {
    if let n = value as? NSNumber { return n.doubleValue }
    if let d = value as? Double { return d }
    if let i = value as? Int { return Double(i) }
    if let s = value as? String { return Double(s) }
    return nil
  }
}
