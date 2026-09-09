import Flutter
import UIKit
import FBSDKCoreKit
import AppTrackingTransparency

/// MethodChannel bridge for the official Meta/Facebook App Events iOS SDK.
enum MetaAppEventsBridge {
  static let channelName = "com.app.deenly.deenly/meta_app_events"

  private static var initialized = false

  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "initialize":
        let args = call.arguments as? [String: Any] ?? [:]
        let ok = initialize(
          appId: (args["appId"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
          clientToken: (args["clientToken"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
          displayName: (args["displayName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Deen Focus",
          debug: args["debug"] as? Bool ?? false
        )
        result(["ok": ok, "initialized": initialized])
      case "isInitialized":
        result(initialized)
      case "trackAppLaunch":
        trackAppLaunch()
        result(true)
      case "trackPurchase":
        trackPurchase(args: call.arguments as? [String: Any] ?? [:])
        result(true)
      case "trackSubscribe":
        trackStandard(name: .subscribe, args: call.arguments as? [String: Any] ?? [:])
        result(true)
      case "trackStartTrial":
        trackStandard(name: .startTrial, args: call.arguments as? [String: Any] ?? [:])
        result(true)
      case "setAdvertiserTrackingEnabled":
        let enabled = (call.arguments as? [String: Any])?["enabled"] as? Bool ?? false
        setAdvertiserTrackingEnabled(enabled)
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  /// Call from AppDelegate so deep links / URL opens are attributed.
  static func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) {
    ApplicationDelegate.shared.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
  }

  @discardableResult
  static func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    ApplicationDelegate.shared.application(
      app,
      open: url,
      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
      annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    )
  }

  @discardableResult
  private static func initialize(
    appId: String,
    clientToken: String,
    displayName: String,
    debug: Bool
  ) -> Bool {
    if initialized { return true }
    guard !appId.isEmpty, !clientToken.isEmpty else {
      NSLog("[MetaAppEvents] Skipping init; missing appId/clientToken")
      return false
    }

    Settings.shared.appID = appId
    Settings.shared.clientToken = clientToken
    Settings.shared.displayName = displayName.isEmpty ? "Deen Focus" : displayName
    Settings.shared.isAutoLogAppEventsEnabled = true
    Settings.shared.isAdvertiserIDCollectionEnabled = true
    if debug {
      Settings.shared.enableLoggingBehavior(.appEvents)
    }

    requestTrackingAuthorizationIfNeeded()
    AppEvents.shared.activateApp()
    initialized = true
    NSLog("[MetaAppEvents] Meta SDK initialized")
    return true
  }

  private static func requestTrackingAuthorizationIfNeeded() {
    guard #available(iOS 14, *) else {
      Settings.shared.isAdvertiserTrackingEnabled = true
      return
    }

    DispatchQueue.main.async {
      ATTrackingManager.requestTrackingAuthorization { status in
        let enabled = status == .authorized
        Settings.shared.isAdvertiserTrackingEnabled = enabled
        NSLog(
          "[MetaAppEvents] ATT status=%d advertiserTracking=%@",
          status.rawValue,
          enabled ? "true" : "false"
        )
      }
    }
  }

  private static func setAdvertiserTrackingEnabled(_ enabled: Bool) {
    Settings.shared.isAdvertiserTrackingEnabled = enabled
  }

  private static func trackAppLaunch() {
    guard initialized else { return }
    AppEvents.shared.activateApp()
  }

  private static func trackPurchase(args: [String: Any]) {
    guard initialized else { return }
    guard let value = number(args["value"]) else { return }
    guard let currency = string(args["currency"]), !currency.isEmpty else { return }

    var params: [AppEvents.ParameterName: Any] = [:]
    if let contentId = string(args["contentId"]), !contentId.isEmpty {
      params[.contentID] = contentId
    }
    params[.contentType] = string(args["contentType"]).flatMap { $0.isEmpty ? nil : $0 } ?? "product"
    if let eventId = string(args["eventId"]), !eventId.isEmpty {
      params[AppEvents.ParameterName("fb_order_id")] = eventId
    }

    AppEvents.shared.logPurchase(
      amount: value,
      currency: currency.uppercased(),
      parameters: params
    )
  }

  private static func trackStandard(name: AppEvents.Name, args: [String: Any]) {
    guard initialized else { return }

    var params: [AppEvents.ParameterName: Any] = [:]
    if let contentId = string(args["contentId"]), !contentId.isEmpty {
      params[.contentID] = contentId
    }
    if let currency = string(args["currency"]), !currency.isEmpty {
      params[.currency] = currency.uppercased()
    }
    if let eventId = string(args["eventId"]), !eventId.isEmpty {
      params[AppEvents.ParameterName("fb_order_id")] = eventId
    }

    if let value = number(args["value"]) {
      AppEvents.shared.logEvent(name, valueToSum: value, parameters: params)
    } else {
      AppEvents.shared.logEvent(name, parameters: params)
    }
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
