import Flutter
import Foundation
import UIKit

#if canImport(AlarmKit)
import AlarmKit
import AppIntents
import ActivityKit
import SwiftUI
#endif

/// Native Prayer Alarm bridge: AlarmKit on iOS 26+, notification fallback otherwise.
enum PrayerAlarmBridge {
  private static let channelName = "com.app.deenly.deenly/prayer_alarm"
  private static let appGroup = "group.com.rnr.deenfocus"
  private static let pendingPrayedKey = "pending_prayed_prayer"
  private static let alarmIdMapKey = "prayer_alarm_id_map"

  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "getCapabilities":
        result(capabilities())
      case "getAuthorizationStatus":
        authorizationStatus(result: result)
      case "requestAuthorization":
        requestAuthorization(result: result)
      case "scheduleAlarms":
        scheduleAlarms(call: call, result: result)
      case "cancelAll":
        cancelAll(result: result)
      case "cancelAlarm":
        cancelAlarm(call: call, result: result)
      case "consumePendingPrayedAction":
        result(consumePendingPrayed())
      case "canUseFullScreenIntent", "openFullScreenIntentSettings",
           "openExactAlarmSettings":
        result(false)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  static func setPendingPrayed(_ prayer: String) {
    UserDefaults(suiteName: appGroup)?.set(prayer, forKey: pendingPrayedKey)
    UserDefaults.standard.set(prayer, forKey: pendingPrayedKey)
  }

  private static func consumePendingPrayed() -> String? {
    let suite = UserDefaults(suiteName: appGroup)
    let value = suite?.string(forKey: pendingPrayedKey)
      ?? UserDefaults.standard.string(forKey: pendingPrayedKey)
    suite?.removeObject(forKey: pendingPrayedKey)
    UserDefaults.standard.removeObject(forKey: pendingPrayedKey)
    return value
  }

  private static func capabilities() -> [String: Any] {
#if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      return [
        "platform": "ios",
        "implementation": "alarmkit",
        "supportsNativeAlarm": true,
        "supportsFullScreen": false,
        "requiresAlarmKitEntitlement": true,
        "iosVersion": UIDevice.current.systemVersion,
      ]
    }
#endif
    return [
      "platform": "ios",
      "implementation": "notification_fallback",
      "supportsNativeAlarm": false,
      "supportsFullScreen": false,
      "requiresAlarmKitEntitlement": false,
      "iosVersion": UIDevice.current.systemVersion,
    ]
  }

  private static func authorizationStatus(result: @escaping FlutterResult) {
#if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      // authorizationState is synchronous per current AlarmKit docs.
      let state = AlarmManager.shared.authorizationState
      switch state {
      case .authorized: result("authorized")
      case .denied: result("denied")
      case .notDetermined: result("notDetermined")
      @unknown default: result("unavailable")
      }
      return
    }
#endif
    result("unavailable")
  }

  private static func requestAuthorization(result: @escaping FlutterResult) {
#if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      Task {
        do {
          let state = try await AlarmManager.shared.requestAuthorization()
          await MainActor.run {
            switch state {
            case .authorized: result("authorized")
            case .denied: result("denied")
            case .notDetermined: result("notDetermined")
            @unknown default: result("unavailable")
            }
          }
        } catch {
          await MainActor.run {
            result(
              FlutterError(
                code: "ALARMKIT_AUTH",
                message: error.localizedDescription,
                details: nil
              )
            )
          }
        }
      }
      return
    }
#endif
    result("unavailable")
  }

  private static func scheduleAlarms(call: FlutterMethodCall, result: @escaping FlutterResult) {
#if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      guard let args = call.arguments as? [String: Any],
            let alarms = args["alarms"] as? [[String: Any]]
      else {
        result(FlutterError(code: "INVALID_ARGS", message: "alarms required", details: nil))
        return
      }
      let replaceAll = (args["replaceAll"] as? Bool) ?? true
      Task {
        do {
          if replaceAll {
            try await cancelAllAlarms()
          }
          for alarm in alarms {
            try await scheduleOne(alarm)
          }
          await MainActor.run { result(nil) }
        } catch {
          await MainActor.run {
            result(
              FlutterError(
                code: "ALARMKIT_SCHEDULE",
                message: error.localizedDescription,
                details: nil
              )
            )
          }
        }
      }
      return
    }
#endif
    // iOS <26 / no AlarmKit SDK: soft notifications remain the fallback.
    result(nil)
  }

  private static func cancelAll(result: @escaping FlutterResult) {
#if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      Task {
        do {
          try await cancelAllAlarms()
          await MainActor.run { result(nil) }
        } catch {
          await MainActor.run {
            result(
              FlutterError(
                code: "ALARMKIT_CANCEL",
                message: error.localizedDescription,
                details: nil
              )
            )
          }
        }
      }
      return
    }
#endif
    result(nil)
  }

  private static func cancelAlarm(call: FlutterMethodCall, result: @escaping FlutterResult) {
#if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      guard let args = call.arguments as? [String: Any],
            let id = args["id"] as? String
      else {
        result(FlutterError(code: "INVALID_ARGS", message: "id required", details: nil))
        return
      }
      Task {
        do {
          if let uuid = mappedUUID(for: id) {
            try AlarmManager.shared.cancel(id: uuid)
            unmap(id: id)
          }
          await MainActor.run { result(nil) }
        } catch {
          await MainActor.run {
            result(
              FlutterError(
                code: "ALARMKIT_CANCEL",
                message: error.localizedDescription,
                details: nil
              )
            )
          }
        }
      }
      return
    }
#endif
    result(nil)
  }

#if canImport(AlarmKit)
  @available(iOS 26.0, *)
  private static func cancelAllAlarms() async throws {
    // Prefer daemon-owned list so we clear even if local id map is stale.
    if let scheduled = try? AlarmManager.shared.alarms {
      for alarm in scheduled {
        try? AlarmManager.shared.cancel(id: alarm.id)
      }
    } else {
      for (_, uuidString) in idMap() {
        if let uuid = UUID(uuidString: uuidString) {
          try? AlarmManager.shared.cancel(id: uuid)
        }
      }
    }
    UserDefaults.standard.removeObject(forKey: alarmIdMapKey)
  }

  @available(iOS 26.0, *)
  private static func scheduleOne(_ alarm: [String: Any]) async throws {
    guard let alarmId = alarm["id"] as? String,
          let prayer = alarm["prayer"] as? String,
          let fireAtMs = numberValue(alarm["fireAtMs"])
    else { return }

    let fireDate = Date(timeIntervalSince1970: fireAtMs / 1000.0)
    guard fireDate > Date() else { return }

    // AlarmKit Alert only accepts a single title string. Typography, layout,
    // fire time, and the app name ("Deen Focus") are system-controlled —
    // keep our title Clock-like: short prayer label only (not
    // "Maghrib — Time to Pray").
    let prayerLabel = (alarm["prayerLabel"] as? String)?
      .trimmingCharacters(in: .whitespacesAndNewlines)
    let title: String = {
      if let prayerLabel, !prayerLabel.isEmpty { return prayerLabel }
      if let raw = alarm["title"] as? String, !raw.isEmpty { return raw }
      return NSLocalizedString("prayer_alarm_subtitle", comment: "Time to Pray")
    }()
    let ivePrayedLabel = (alarm["ivePrayedLabel"] as? String)
      ?? NSLocalizedString("prayer_alarm_ive_prayed", comment: "I've Prayed")
    let soundName = alarm["sound"] as? String

    if let existing = mappedUUID(for: alarmId) {
      try? AlarmManager.shared.cancel(id: existing)
    }

    let uuid = UUID()
    map(id: alarmId, uuid: uuid)

    // Primary custom action. Stop/Dismiss sizing & style stay system-owned.
    let secondaryButton = AlarmButton(
      text: LocalizedStringResource(stringLiteral: ivePrayedLabel),
      textColor: .white,
      systemImageName: "checkmark"
    )
    let alertTitle = LocalizedStringResource(stringLiteral: title)
    let alert: AlarmPresentation.Alert
    if #available(iOS 26.1, *) {
      // System provides Stop; avoid a custom stopButton chrome.
      alert = AlarmPresentation.Alert(
        title: alertTitle,
        secondaryButton: secondaryButton,
        secondaryButtonBehavior: .custom
      )
    } else {
      let dismissLabel = (alarm["dismissLabel"] as? String)
        ?? NSLocalizedString("prayer_alarm_dismiss", comment: "Dismiss")
      let stopButton = AlarmButton(
        text: LocalizedStringResource(stringLiteral: dismissLabel),
        textColor: .white,
        systemImageName: "xmark"
      )
      alert = AlarmPresentation.Alert(
        title: alertTitle,
        stopButton: stopButton,
        secondaryButton: secondaryButton,
        secondaryButtonBehavior: .custom
      )
    }
    let presentation = AlarmPresentation(alert: alert)
    let tint = Color(red: 78.0 / 255.0, green: 154.0 / 255.0, blue: 124.0 / 255.0)
    let attributes = AlarmAttributes<PrayerAlarmMetadata>(
      presentation: presentation,
      metadata: PrayerAlarmMetadata(prayer: prayer, alarmId: alarmId),
      tintColor: tint
    )

    let secondaryIntent = IvePrayedAlarmIntent(alarmID: uuid.uuidString, prayer: prayer)
    // Bundle resources are azan.caf / beep.caf (AlarmKit accepts named sound with extension).
    let sound: AlertConfiguration.AlertSound = {
      switch soundName {
      case "beep":
        return .named("beep.caf")
      case "mute":
        // AlarmKit always presents an audible alert; mute setting keeps system default.
        return .default
      default:
        return .named("azan.caf")
      }
    }()

    let configuration = AlarmManager.AlarmConfiguration<PrayerAlarmMetadata>.alarm(
      schedule: .fixed(fireDate),
      attributes: attributes,
      stopIntent: nil,
      secondaryIntent: secondaryIntent,
      sound: sound
    )

    _ = try await AlarmManager.shared.schedule(id: uuid, configuration: configuration)
  }

  private static func numberValue(_ raw: Any?) -> Double? {
    switch raw {
    case let value as NSNumber:
      return value.doubleValue
    case let value as Double:
      return value
    case let value as Int:
      return Double(value)
    case let value as Int64:
      return Double(value)
    default:
      return nil
    }
  }

  private static func idMap() -> [String: String] {
    (UserDefaults.standard.dictionary(forKey: alarmIdMapKey) as? [String: String]) ?? [:]
  }

  private static func mappedUUID(for id: String) -> UUID? {
    guard let raw = idMap()[id] else { return nil }
    return UUID(uuidString: raw)
  }

  private static func map(id: String, uuid: UUID) {
    var map = idMap()
    map[id] = uuid.uuidString
    UserDefaults.standard.set(map, forKey: alarmIdMapKey)
  }

  private static func unmap(id: String) {
    var map = idMap()
    map.removeValue(forKey: id)
    UserDefaults.standard.set(map, forKey: alarmIdMapKey)
  }
#endif
}

#if canImport(AlarmKit)
@available(iOS 26.0, *)
struct PrayerAlarmMetadata: AlarmMetadata {
  let prayer: String
  let alarmId: String
}

@available(iOS 26.0, *)
struct IvePrayedAlarmIntent: LiveActivityIntent {
  static var title: LocalizedStringResource = "prayer_alarm_ive_prayed"
  static var openAppWhenRun: Bool { true }

  @Parameter(title: "Alarm ID")
  var alarmID: String

  @Parameter(title: "Prayer")
  var prayer: String

  init() {
    self.alarmID = ""
    self.prayer = ""
  }

  init(alarmID: String, prayer: String) {
    self.alarmID = alarmID
    self.prayer = prayer
  }

  func perform() async throws -> some IntentResult {
    PrayerAlarmBridge.setPendingPrayed(prayer)
    if let uuid = UUID(uuidString: alarmID) {
      try? AlarmManager.shared.cancel(id: uuid)
    }
    return .result()
  }
}
#endif
