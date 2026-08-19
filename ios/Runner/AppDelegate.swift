import CoreFoundation
import Flutter
import UIKit
import SwiftUI
import WidgetKit
import FamilyControls
import DeviceActivity
import ManagedSettings
import CoreLocation
import MapKit
import UserNotifications

/// Shared with `FocusDeviceActivityScheduler` / shield extension (no iOS 16 gate — used for theme prefs from any OS version).
private enum FocusShieldThemeUserDefaults {
  static let suiteName = "group.com.rnr.deenfocus"
  static let appThemeIsDarkKey = "focus_shield_app_theme_is_dark"
}

@available(iOS 16.0, *)
private enum ManagedSettingsStoreHolder {
  static let name = ManagedSettingsStore.Name("FocusShield")
  static let shared = ManagedSettingsStore(named: name)
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let focusMethodChannelName = "com.app.deenly.deenly/focus"
  private let screenTimeChannelName = "com.app.deenly.deenly/screen_time"
  private let qiblaMethodChannelName = "com.app.deenly.deenly/qibla_compass_method"
  private let qiblaEventChannelName = "com.app.deenly.deenly/qibla_compass_events"
  private let widgetChannelName = "com.app.deenly.deenly/widgets"
  private let locationSearchChannelName = "com.app.deenly.deenly/location_search"
  // Prayer alarms use PrayerAlarmBridge (`com.app.deenly.deenly/prayer_alarm`).
  private let qiblaHeadingStreamHandler = QiblaHeadingStreamHandler()
  private let widgetAppGroup = "group.com.rnr.deenfocus"
  private let tajweedChannelHandler = TajweedChannelHandler()
  private let quranTranslationChannelHandler = QuranTranslationChannelHandler()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let launchT0 = CFAbsoluteTimeGetCurrent()
    func logPhase(_ name: String, since: CFAbsoluteTime = launchT0) {
      let deltaMs = (CFAbsoluteTimeGetCurrent() - since) * 1000
      let absMs = (CFAbsoluteTimeGetCurrent() - launchT0) * 1000
      // Use interpolation — NSLog("%s", swiftString) crashes (expects C string).
      NSLog("[DeenFocus][Startup] \(name) +\(String(format: "%.1f", deltaMs)) ms (abs \(String(format: "%.1f", absMs)) ms)")
    }

    NSLog("[DeenFocus][Startup] didFinishLaunching begin")

    // CRITICAL: plugins MUST register before any Dart code that uses
    // SharedPreferences / path_provider / etc. Commenting this out leaves the
    // process on the white LaunchScreen while MethodChannels hang.
    let pluginsT0 = CFAbsoluteTimeGetCurrent()
    #if DEBUG
    TimedPluginRegistrant.register(with: self)
    #else
    GeneratedPluginRegistrant.register(with: self)
    #endif
    logPhase("1_GeneratedPluginRegistrant done", since: pluginsT0)

    // Use a dedicated registrar key for app channels (not a real plugin class).
    let channelsT0 = CFAbsoluteTimeGetCurrent()
    if let registrar = self.registrar(forPlugin: "DeenFocusAppChannels") {
      let messenger = registrar.messenger()
      let focusMethodChannel = FlutterMethodChannel(
        name: focusMethodChannelName,
        binaryMessenger: messenger
      )
      let screenTimeChannel = FlutterMethodChannel(
        name: screenTimeChannelName,
        binaryMessenger: messenger
      )
      let qiblaMethodChannel = FlutterMethodChannel(
        name: qiblaMethodChannelName,
        binaryMessenger: messenger
      )
      let widgetChannel = FlutterMethodChannel(
        name: widgetChannelName,
        binaryMessenger: messenger
      )
      let locationSearchChannel = FlutterMethodChannel(
        name: locationSearchChannelName,
        binaryMessenger: messenger
      )
      let qiblaEventChannel = FlutterEventChannel(
        name: qiblaEventChannelName,
        binaryMessenger: messenger
      )

      PrayerAlarmBridge.register(messenger: messenger)
      PrayerLiveActivityBridge.register(messenger: messenger)

      focusMethodChannel.setMethodCallHandler { call, result in
        switch call.method {
        case "presentFamilyActivityPicker":
          self.presentFamilyActivityPicker(call: call, result: result)
        case "syncFocusState":
          self.syncFocusState(call: call, result: result)
        case "setFocusShieldTheme":
          self.setFocusShieldTheme(call: call, result: result)
        case "appendFocusDebugLog":
          self.appendFocusDebugLog(call: call, result: result)
        case "clearFocusDebugLog":
          FocusIOSDebugLogger.clear()
          result(FocusIOSDebugLogger.path())
        case "getFocusDebugLogPath":
          result(FocusIOSDebugLogger.path())
        case "cancelPendingNotificationRange":
          self.cancelPendingNotificationRange(call: call, result: result)
        case "readIosFocusBridgeState":
          self.readIosFocusBridgeState(result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

      screenTimeChannel.setMethodCallHandler { call, result in
        switch call.method {
        case "requestScreenTime":
          self.requestScreenTimeAuthorization(result: result)
        case "openAppSettings":
          self.openAppSettings(result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

      qiblaMethodChannel.setMethodCallHandler { call, result in
        switch call.method {
        case "setLocation":
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

      widgetChannel.setMethodCallHandler { call, result in
        switch call.method {
        case "saveWidgetTimeline":
          self.saveWidgetTimeline(call: call, result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

      locationSearchChannel.setMethodCallHandler { call, result in
        switch call.method {
        case "search":
          guard
            let args = call.arguments as? [String: Any],
            let query = args["query"] as? String
          else {
            result(
              FlutterError(
                code: "INVALID_QUERY",
                message: "Query missing.",
                details: nil
              )
            )
            return
          }
          self.searchMapItems(query: query, result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

      qiblaEventChannel.setStreamHandler(qiblaHeadingStreamHandler)
      tajweedChannelHandler.register(messenger: messenger)
      quranTranslationChannelHandler.register(messenger: messenger)
      logPhase("2_app method channels registered", since: channelsT0)
    } else {
      NSLog("[DeenFocus][Startup] ERROR: could not obtain Flutter registrar")
    }

    UNUserNotificationCenter.current().delegate = self
    // File I/O for debug log must not block first frame — defer.
    DispatchQueue.global(qos: .utility).async {
      FocusIOSDebugLogger.append(
        "ios.app.launch",
        "app launched exportedLogPath=\(FocusIOSDebugLogger.path() ?? "nil")"
      )
    }

    // FlutterAppDelegate creates/attaches the FlutterEngine and runs the Dart
    // entrypoint (main). Dart-side [STARTUP] markers continue from there.
    logPhase("3_calling super.application (FlutterEngine + entrypoint)")
    let engineT0 = CFAbsoluteTimeGetCurrent()
    let ok = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    logPhase("4_FlutterEngine+entrypoint returned", since: engineT0)
    logPhase("5_didFinishLaunching complete")
    return ok
  }

  private func appendFocusDebugLog(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard
      let args = call.arguments as? [String: Any],
      let tag = args["tag"] as? String,
      let message = args["message"] as? String
    else {
      result(nil)
      return
    }

    FocusIOSDebugLogger.append(tag, message)
    result(nil)
  }

  private func cancelPendingNotificationRange(
    call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    guard
      let args = call.arguments as? [String: Any],
      let start = args["startInclusive"] as? Int,
      let end = args["endInclusive"] as? Int
    else {
      result(0)
      return
    }

    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
      let identifiersToRemove = requests.compactMap { request -> String? in
        guard let id = Int(request.identifier) else { return nil }
        guard id >= start, id <= end else { return nil }
        return request.identifier
      }

      if !identifiersToRemove.isEmpty {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
          withIdentifiers: identifiersToRemove
        )
      }

      FocusIOSDebugLogger.append(
        "ios.notifications.cancelPending",
        "range=\(start)-\(end) removed=\(identifiersToRemove.count)"
      )
      result(identifiersToRemove.count)
    }
  }

  private func searchMapItems(query: String, result: @escaping FlutterResult) {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      result([])
      return
    }

    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = trimmed
    if #available(iOS 13.0, *) {
      request.resultTypes = [.address, .pointOfInterest]
    }

    let search = MKLocalSearch(request: request)
    search.start { response, error in
      // FlutterMethodChannel expects results on the main queue.
      DispatchQueue.main.async {
        if error != nil {
          result([])
          return
        }
        guard let response = response else {
          result([])
          return
        }

        var payload: [[String: Any]] = []
        for item in response.mapItems {
          let pm = item.placemark
          let title = item.name ?? pm.name ?? trimmed
          var subtitleParts: [String] = []
          if let locality = pm.locality { subtitleParts.append(locality) }
          if let country = pm.country { subtitleParts.append(country) }
          let subtitle = subtitleParts.joined(separator: ", ")

          payload.append([
            "title": title,
            "subtitle": subtitle,
            "latitude": pm.coordinate.latitude,
            "longitude": pm.coordinate.longitude,
          ])
        }
        result(payload)
      }
    }
  }

  private func saveWidgetTimeline(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard
      let args = call.arguments as? [String: Any],
      let timelineJson = args["timelineJson"] as? String,
      !timelineJson.isEmpty
    else {
      result(
        FlutterError(
          code: "INVALID_WIDGET_TIMELINE",
          message: "Timeline JSON missing.",
          details: nil
        )
      )
      return
    }

    let defaults = UserDefaults(suiteName: widgetAppGroup)
    defaults?.set(timelineJson, forKey: "widget_timeline_json")
    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
    }
    result(nil)
  }

  private func requestScreenTimeAuthorization(result: @escaping FlutterResult) {
    guard #available(iOS 16.0, *) else {
      result([
        "authorized": false,
        "errorCode": "IOS_VERSION_UNSUPPORTED",
        "errorMessage": "Family Controls requires iOS 16 or later."
      ])
      return
    }

    Task { @MainActor in
      do {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        result([
          "authorized": true,
          "errorCode": nil,
          "errorMessage": nil
        ])
      } catch {
        let authError = error as? FamilyControlsError
        let errorCode: String
        let errorMessage: String

        switch authError {
        case .authenticationMethodUnavailable:
          errorCode = "AUTHENTICATION_METHOD_UNAVAILABLE"
          errorMessage = "This iPhone must have a device passcode set before Apple can grant Screen Time access."
        case .authorizationCanceled:
          errorCode = "AUTHORIZATION_CANCELED"
          errorMessage = "Screen Time access was canceled before it was granted."
        case .authorizationConflict:
          errorCode = "AUTHORIZATION_CONFLICT"
          errorMessage = "Another app is already managing Family Controls on this iPhone."
        case .invalidAccountType:
          errorCode = "INVALID_ACCOUNT_TYPE"
          errorMessage = "Sign in with a valid iCloud account to use Screen Time access."
        case .networkError:
          errorCode = "NETWORK_ERROR"
          errorMessage = "Connect this iPhone to the internet, then try Screen Time access again."
        case .restricted:
          errorCode = "RESTRICTED"
          errorMessage = "Family Controls is restricted on this iPhone."
        case .unavailable:
          errorCode = "UNAVAILABLE"
          errorMessage = "Family Controls is currently unavailable on this iPhone."
        case .invalidArgument:
          errorCode = "INVALID_ARGUMENT"
          errorMessage = "The Screen Time authorization request was invalid."
        case .none:
          errorCode = "SCREEN_TIME_AUTH_FAILED"
          errorMessage = error.localizedDescription
        @unknown default:
          errorCode = "SCREEN_TIME_AUTH_FAILED"
          errorMessage = error.localizedDescription
        }

        result(
          [
            "authorized": false,
            "errorCode": errorCode,
            "errorMessage": errorMessage
          ]
        )
      }
    }
  }

  private func presentFamilyActivityPicker(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(iOS 16.0, *) else {
      result(
        FlutterError(
          code: "IOS_VERSION_UNSUPPORTED",
          message: "FamilyActivityPicker requires iOS 16 or later.",
          details: nil
        )
      )
      return
    }

    let encodedExisting = (call.arguments as? [String: Any])?["iosSelectionData"] as? String

    DispatchQueue.main.async {
      guard let controller = self.topViewController() else {
        result(
          FlutterError(
            code: "PICKER_PRESENTATION_FAILED",
            message: "No active view controller available.",
            details: nil
          )
        )
        return
      }

      let presenter = FocusPickerPresenter(encodedSelection: encodedExisting) { payload in
        result(payload)
      }
      presenter.present(from: controller)
    }
  }

  private func openAppSettings(result: @escaping FlutterResult) {
    guard let url = URL(string: UIApplication.openSettingsURLString) else {
      result(false)
      return
    }

    guard UIApplication.shared.canOpenURL(url) else {
      result(false)
      return
    }

    UIApplication.shared.open(url, options: [:]) { success in
      result(success)
    }
  }

  /// Resolves in-app dark mode for the Managed Settings shield (same key the extension reads).
  private static func resolveShieldThemeIsDark(from args: [String: Any]) -> Bool {
    switch args["shieldThemeIsDark"] {
    case let b as Bool:
      return b
    case let n as NSNumber:
      return n.boolValue
    default:
      let defaults = UserDefaults(suiteName: FocusShieldThemeUserDefaults.suiteName)
      return defaults?.bool(forKey: FocusShieldThemeUserDefaults.appThemeIsDarkKey) ?? false
    }
  }

  private static func writeShieldThemeToAppGroup(isDark: Bool) {
    let defaults = UserDefaults(suiteName: FocusShieldThemeUserDefaults.suiteName)
    defaults?.set(isDark, forKey: FocusShieldThemeUserDefaults.appThemeIsDarkKey)
    defaults?.synchronize()
    CFPreferencesAppSynchronize(FocusShieldThemeUserDefaults.suiteName as CFString)
  }

  /// Parses Flutter `nextChangeAt` (epoch millis string or ISO local) into milliseconds since 1970.
  private static func parseFocusNextChangeAtToMillis(_ raw: String?) -> Double? {
    guard let raw, !raw.isEmpty else { return nil }
    let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
    if let v = Int64(trimmed), v > 0 {
      return Double(v)
    }
    let tz = TimeZone.current
    let patterns = [
      "yyyy-MM-dd'T'HH:mm:ss.SSSX",
      "yyyy-MM-dd'T'HH:mm:ssX",
      "yyyy-MM-dd'T'HH:mm:ss.SSS",
      "yyyy-MM-dd'T'HH:mm:ss",
    ]
    for pattern in patterns {
      let df = DateFormatter()
      df.locale = Locale(identifier: "en_US_POSIX")
      df.timeZone = tz
      df.dateFormat = pattern
      if let d = df.date(from: trimmed) {
        return d.timeIntervalSince1970 * 1000
      }
    }
    return nil
  }

  private func setFocusShieldTheme(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "BAD_ARGS", message: "Missing arguments", details: nil))
      return
    }
    let isDark: Bool
    switch args["isDark"] {
    case let b as Bool:
      isDark = b
    case let n as NSNumber:
      isDark = n.boolValue
    default:
      result(FlutterError(code: "BAD_IS_DARK", message: "isDark must be bool", details: nil))
      return
    }
    Self.writeShieldThemeToAppGroup(isDark: isDark)
    result(nil)
  }

  private func readIosFocusBridgeState(result: @escaping FlutterResult) {
    guard #available(iOS 16.0, *) else {
      result([String: Any]())
      return
    }
    let defaults = UserDefaults(suiteName: FocusDeviceActivityScheduler.appGroupId)
    let latchMs = defaults?.double(forKey: FocusDeviceActivityScheduler.salahShieldLatchEpochMsKey) ?? 0
    let nightEndMs = defaults?.double(forKey: FocusDeviceActivityScheduler.nightDisciplineLastEndedMsKey) ?? 0
    result([
      "nativeShieldLocked": defaults?.bool(forKey: FocusDeviceActivityScheduler.shieldNativeLockedKey) ?? false,
      "shieldActiveMode": defaults?.string(forKey: FocusDeviceActivityScheduler.shieldActiveModeKey) as Any,
      "salahLatchEpochMs": (latchMs > 0 ? NSNumber(value: Int(latchMs)) : NSNull()) as Any,
      "nightDisciplineLastEndedEpochMs": (nightEndMs > 0 ? NSNumber(value: Int(nightEndMs)) : NSNull()) as Any,
    ])
  }

  private func syncFocusState(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(iOS 16.0, *) else {
      result(nil)
      return
    }

    guard let args = call.arguments as? [String: Any] else {
      result(nil)
      return
    }

    let shieldThemeIsDark = Self.resolveShieldThemeIsDark(from: args)
    Self.writeShieldThemeToAppGroup(isDark: shieldThemeIsDark)

    let sharedDefaults = UserDefaults(suiteName: FocusDeviceActivityScheduler.appGroupId)

    let isLocked = args["isLocked"] as? Bool ?? false
    let activeMode = args["activeMode"] as? String
    let encodedSelection = args["iosSelectionData"] as? String
    let salahModeEnabled = args["salahModeEnabled"] as? Bool ?? false
    let nightDisciplineEnabled = args["nightDisciplineEnabled"] as? Bool ?? false
    let clearLatch = args["clearIosSalahShieldLatch"] as? Bool ?? false
    let latchMs: Double = {
      if let n = args["iosSalahShieldLatchEpochMillis"] as? NSNumber {
        return n.doubleValue
      }
      if let i = args["iosSalahShieldLatchEpochMillis"] as? Int {
        return Double(i)
      }
      if let i = args["iosSalahShieldLatchEpochMillis"] as? Int64 {
        return Double(i)
      }
      return 0
    }()
    if clearLatch || latchMs <= 0 {
      sharedDefaults?.removeObject(forKey: FocusDeviceActivityScheduler.salahShieldLatchEpochMsKey)
    } else {
      sharedDefaults?.set(latchMs, forKey: FocusDeviceActivityScheduler.salahShieldLatchEpochMsKey)
    }
    let nightStartHour = args["nightStartHour"] as? Int ?? 22
    let nightStartMinute = args["nightStartMinute"] as? Int ?? 0
    let nightEndHour = args["nightEndHour"] as? Int ?? 6
    let nightEndMinute = args["nightEndMinute"] as? Int ?? 0
    let rawTransitions = args["scheduledTransitions"] as? [Any] ?? []
    let transitions: [[String: Any]] = rawTransitions.compactMap { $0 as? [String: Any] }
    let lockReason = args["lockReason"] as? String
    let isTemporarilyUnlocked = args["isTemporarilyUnlocked"] as? Bool ?? false
    let nextChangeAtStr = args["nextChangeAt"] as? String
    if isTemporarilyUnlocked, let ms = Self.parseFocusNextChangeAtToMillis(nextChangeAtStr) {
      sharedDefaults?.set(ms, forKey: FocusDeviceActivityScheduler.tempUnlockUntilMsKey)
    } else {
      sharedDefaults?.removeObject(forKey: FocusDeviceActivityScheduler.tempUnlockUntilMsKey)
    }
    FocusIOSDebugLogger.append(
      "ios.sync",
      "isLocked=\(isLocked) activeMode=\(activeMode ?? "nil") nightEnabled=\(nightDisciplineEnabled) transitions=\(transitions.count) nextChange=\(args["nextChangeAt"] as? String ?? "nil")"
    )

    // Always apply Flutter sync: it runs only after a full focus recompute, so `isLocked`
    // matches persisted settings. A previous guard here skipped sync when `nativeShieldLocked`
    // was true and any mode stayed enabled (e.g. Salah), which left shields up after the user
    // turned off Night Discipline while Salah remained on.

    FocusDeviceActivityScheduler.sync(
      activeMode: activeMode,
      encodedSelection: encodedSelection,
      transitions: transitions,
      nightDisciplineEnabled: nightDisciplineEnabled,
      nightStartHour: nightStartHour,
      nightStartMinute: nightStartMinute,
      nightEndHour: nightEndHour,
      nightEndMinute: nightEndMinute
    )
    let store = ManagedSettingsStoreHolder.shared

    if !isLocked {
      let latchMs = sharedDefaults?.double(forKey: FocusDeviceActivityScheduler.salahShieldLatchEpochMsKey) ?? 0
      let nativeStillLocked = sharedDefaults?.bool(forKey: FocusDeviceActivityScheduler.shieldNativeLockedKey) ?? false
      if clearLatch {
        sharedDefaults?.removeObject(forKey: FocusDeviceActivityScheduler.salahShieldLatchEpochMsKey)
      }
      if salahModeEnabled && latchMs > 0 && nativeStillLocked && !isTemporarilyUnlocked && !clearLatch {
        FocusIOSDebugLogger.append(
          "ios.sync",
          "skipped clear because native salah latch is active latchMs=\(Int(latchMs)) activeMode=\(sharedDefaults?.string(forKey: FocusDeviceActivityScheduler.shieldActiveModeKey) ?? "nil")"
        )
        result(nil)
        return
      }
      sharedDefaults?.set(false, forKey: FocusDeviceActivityScheduler.shieldFlutterLockedKey)
      sharedDefaults?.set(false, forKey: FocusDeviceActivityScheduler.shieldNativeLockedKey)
      sharedDefaults?.removeObject(forKey: FocusDeviceActivityScheduler.shieldActiveModeKey)
      sharedDefaults?.removeObject(forKey: FocusDeviceActivityScheduler.shieldLockReasonKey)
      store.clearAllSettings()
      FocusIOSDebugLogger.append(
        "ios.sync",
        "cleared managed settings because flutter state is unlocked"
      )
      result(nil)
      return
    }

    guard
      let encodedSelection,
      let data = Data(base64Encoded: encodedSelection),
      let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    else {
      sharedDefaults?.set(false, forKey: FocusDeviceActivityScheduler.shieldNativeLockedKey)
      sharedDefaults?.removeObject(forKey: FocusDeviceActivityScheduler.shieldActiveModeKey)
      sharedDefaults?.removeObject(forKey: FocusDeviceActivityScheduler.shieldLockReasonKey)
      store.clearAllSettings()
      FocusIOSDebugLogger.append(
        "ios.sync",
        "cleared managed settings because selection data could not be decoded"
      )
      result(nil)
      return
    }

    if let activeMode, !activeMode.isEmpty {
      sharedDefaults?.set(activeMode, forKey: FocusDeviceActivityScheduler.shieldActiveModeKey)
    } else {
      sharedDefaults?.removeObject(forKey: FocusDeviceActivityScheduler.shieldActiveModeKey)
    }
    if let lockReason, !lockReason.isEmpty {
      sharedDefaults?.set(lockReason, forKey: FocusDeviceActivityScheduler.shieldLockReasonKey)
    } else {
      sharedDefaults?.removeObject(forKey: FocusDeviceActivityScheduler.shieldLockReasonKey)
    }
    sharedDefaults?.set(true, forKey: FocusDeviceActivityScheduler.shieldFlutterLockedKey)
    sharedDefaults?.set(true, forKey: FocusDeviceActivityScheduler.shieldNativeLockedKey)

    store.shield.applications = selection.applicationTokens
    store.shield.applicationCategories = selection.categoryTokens.isEmpty
      ? nil
      : ShieldSettings.ActivityCategoryPolicy.specific(selection.categoryTokens)
    store.shield.webDomains = selection.webDomainTokens
    store.shield.webDomainCategories = nil
    FocusIOSDebugLogger.append(
      "ios.sync",
      "applied immediate shield apps=\(selection.applicationTokens.count) categories=\(selection.categoryTokens.count) domains=\(selection.webDomainTokens.count)"
    )
    result(nil)
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    FocusIOSDebugLogger.append(
      "ios.notification.foreground",
      "identifier=\(notification.request.identifier) title=\(notification.request.content.title)"
    )
    if #available(iOS 14.0, *) {
      completionHandler([.list, .banner, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    FocusIOSDebugLogger.append(
      "ios.notification.tap",
      "identifier=\(response.notification.request.identifier) title=\(response.notification.request.content.title)"
    )
    completionHandler()
  }

  private func topViewController(
    from controller: UIViewController? = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first(where: { $0.isKeyWindow })?.rootViewController
  ) -> UIViewController? {
    if let navigation = controller as? UINavigationController {
      return topViewController(from: navigation.visibleViewController)
    }

    if let tab = controller as? UITabBarController {
      return topViewController(from: tab.selectedViewController)
    }

    if let presented = controller?.presentedViewController {
      return topViewController(from: presented)
    }

    return controller
  }
}

@available(iOS 16.0, *)
final class FocusPickerPresenter {
  private let encodedSelection: String?
  private let onComplete: ([String: Any?]) -> Void

  init(encodedSelection: String?, onComplete: @escaping ([String: Any?]) -> Void) {
    self.encodedSelection = encodedSelection
    self.onComplete = onComplete
  }

  func present(from controller: UIViewController) {
    let pickerController = FocusPickerViewController(
      encodedSelection: encodedSelection,
      onComplete: onComplete
    )
    pickerController.modalPresentationStyle = .pageSheet
    controller.present(pickerController, animated: true)
  }
}

@available(iOS 16.0, *)
private final class FocusPickerViewController: UIHostingController<FocusPickerRootView> {
  init(encodedSelection: String?, onComplete: @escaping ([String: Any?]) -> Void) {
    let rootView = FocusPickerRootView(encodedSelection: encodedSelection, onComplete: onComplete)
    super.init(rootView: rootView)
  }

  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

@available(iOS 16.0, *)
private struct FocusPickerRootView: View {
  @Environment(\.dismiss) private var dismiss
  // Include all apps from selected categories so we persist app tokens, not
  // only category/group tokens.
  @State private var selection: FamilyActivitySelection

  /// Snapshot when the sheet opened — used for Cancel so we do not clear Flutter state.
  private let initialSelection: FamilyActivitySelection

  let onComplete: ([String: Any?]) -> Void

  @State private var didFinish = false

  init(encodedSelection: String?, onComplete: @escaping ([String: Any?]) -> Void) {
    let loaded = Self.decodeSelection(from: encodedSelection)
    _selection = State(initialValue: loaded)
    initialSelection = loaded
    self.onComplete = onComplete
  }

  var body: some View {
    NavigationStack {
      FamilyActivityPicker(selection: $selection)
        .navigationTitle("Select Apps")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
              didFinish = true
              dismiss()
              onComplete(serializeSelection(initialSelection))
            }
          }

          ToolbarItem(placement: .confirmationAction) {
            Button("Done") {
              didFinish = true
              let payload = serializeSelection(selection)
              dismiss()
              onComplete(payload)
            }
          }
        }
    }
    .onDisappear {
      if !didFinish {
        didFinish = true
        onComplete(serializeSelection(initialSelection))
      }
    }
  }

  private static func decodeSelection(from encoded: String?) -> FamilyActivitySelection {
    guard let encoded,
          let data = Data(base64Encoded: encoded),
          let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    else {
      return FamilyActivitySelection(includeEntireCategory: true)
    }
    return decoded
  }

  private func serializeSelection(_ selection: FamilyActivitySelection) -> [String: Any?] {
    let encoded = try? JSONEncoder().encode(selection)
    let applicationCount = selection.applicationTokens.count
    let categoryCount = selection.categoryTokens.count
    let webDomainCount = selection.webDomainTokens.count
    let totalCount = applicationCount + categoryCount + webDomainCount
    return [
      "selectionData": encoded?.base64EncodedString(),
      "applicationCount": applicationCount,
      "categoryCount": categoryCount,
      "webDomainCount": webDomainCount,
      "selectionCount": totalCount,
    ]
  }
}

final class QiblaHeadingStreamHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()
  private var eventSink: FlutterEventSink?

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.headingFilter = 1
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    guard CLLocationManager.headingAvailable() else {
      events(FlutterEndOfEventStream)
      return nil
    }

    eventSink = events
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    locationManager.stopUpdatingHeading()
    locationManager.stopUpdatingLocation()
    return nil
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    let heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
    eventSink?(normalizedHeading(heading))
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    eventSink?(FlutterEndOfEventStream)
  }

  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    return true
  }

  private func normalizedHeading(_ value: CLLocationDirection) -> Double {
    let normalized = value.truncatingRemainder(dividingBy: 360)
    return normalized >= 0 ? normalized : normalized + 360
  }
}
