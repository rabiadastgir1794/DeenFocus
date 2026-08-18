import ActivityKit
import Flutter
import Foundation
import UIKit

/// Flutter bridge for iOS ActivityKit Prayer Live Activities.
enum PrayerLiveActivityBridge {
  private static let channelName = "com.app.deenly.deenly/prayer_live_activity"
  private static let appGroup = "group.com.rnr.deenfocus"
  private static let payloadKey = "prayer_live_activity_payload"

  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "getCapabilities":
        result(capabilities())
      case "areActivitiesEnabled":
        result(areActivitiesEnabled())
      case "startOrUpdate":
        startOrUpdate(call: call, result: result)
      case "stop":
        stop(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private static func capabilities() -> [String: Any] {
    if #available(iOS 16.2, *) {
      return [
        "platform": "ios",
        "implementation": "activitykit",
        "supportsLiveActivity": true,
        "areActivitiesEnabled": ActivityAuthorizationInfo().areActivitiesEnabled,
        "iosVersion": UIDevice.current.systemVersion,
      ]
    }
    return [
      "platform": "ios",
      "implementation": "unavailable",
      "supportsLiveActivity": false,
      "areActivitiesEnabled": false,
      "iosVersion": UIDevice.current.systemVersion,
    ]
  }

  private static func areActivitiesEnabled() -> Bool {
    if #available(iOS 16.2, *) {
      return ActivityAuthorizationInfo().areActivitiesEnabled
    }
    return false
  }

  private static func startOrUpdate(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(iOS 16.2, *) else {
      result(
        FlutterError(
          code: "unavailable",
          message: "Live Activities require iOS 16.2+",
          details: nil
        )
      )
      return
    }
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "bad_args", message: "Expected map", details: nil))
      return
    }

    // Flutter nulls arrive as NSNull, which UserDefaults cannot store.
    let payload = propertyListObject(args) as? [String: Any] ?? [:]
    UserDefaults(suiteName: appGroup)?.set(payload, forKey: payloadKey)

    let brand = (args["brandName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    let attributes = PrayerLiveActivityAttributes(
      brandName: (brand?.isEmpty == false) ? brand! : "Deen Focus"
    )
    let state = contentState(from: args)
    let staleDate = parseDate(args["nextPrayerIso"] as? String) ?? Date().addingTimeInterval(60 * 30)
    let content = ActivityContent(state: state, staleDate: staleDate)

    Task {
      do {
        if let existing = Activity<PrayerLiveActivityAttributes>.activities.first {
          await existing.update(content)
        } else {
          _ = try Activity.request(
            attributes: attributes,
            content: content,
            pushType: nil
          )
        }
        await MainActor.run { result(nil) }
      } catch {
        await MainActor.run {
          result(
            FlutterError(
              code: "start_failed",
              message: error.localizedDescription,
              details: nil
            )
          )
        }
      }
    }
  }

  private static func stop(result: @escaping FlutterResult) {
    guard #available(iOS 16.2, *) else {
      result(nil)
      return
    }
    Task {
      for activity in Activity<PrayerLiveActivityAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
      UserDefaults(suiteName: appGroup)?.removeObject(forKey: payloadKey)
      await MainActor.run { result(nil) }
    }
  }

  @available(iOS 16.2, *)
  private static func contentState(from args: [String: Any]) -> PrayerLiveActivityAttributes.ContentState {
    let prayers = args["prayers"] as? [[String: Any]] ?? []
    let currentId = args["currentPrayerId"] as? String ?? ""
    let index = prayers.firstIndex(where: { ($0["id"] as? String) == currentId }) ?? 0
    let progress = prayers.isEmpty ? 0.0 : Double(index) / Double(max(prayers.count - 1, 1))
    let beforeFirst = args["beforeFirstPrayer"] as? Bool ?? false
    let nowLabel = args["nowLabel"] as? String ?? "Now"
    let upNextLabel = args["upNextLabel"] as? String ?? nowLabel
    let phaseLabel = beforeFirst
      ? (upNextLabel.isEmpty ? nowLabel : upNextLabel)
      : nowLabel

    return PrayerLiveActivityAttributes.ContentState(
      currentPrayerId: currentId,
      currentPrayerLabel: args["currentPrayerLabel"] as? String ?? "",
      currentPrayerTimeLabel: args["currentPrayerTimeLabel"] as? String ?? "",
      nextPrayerLine: args["nextPrayerLine"] as? String ?? "",
      locationName: args["locationName"] as? String ?? "",
      updatedAtLabel: args["updatedAtLabel"] as? String ?? "",
      nowLabel: phaseLabel,
      prayerProgress: min(max(progress, 0), 1)
    )
  }

  private static func parseDate(_ value: String?) -> Date? {
    guard let value, !value.isEmpty else { return nil }
    let withFractional = ISO8601DateFormatter()
    withFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let date = withFractional.date(from: value) { return date }
    let plain = ISO8601DateFormatter()
    plain.formatOptions = [.withInternetDateTime]
    if let date = plain.date(from: value) { return date }

    let local = DateFormatter()
    local.locale = Locale(identifier: "en_US_POSIX")
    local.timeZone = .current
    local.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    if let date = local.date(from: value) { return date }
    local.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return local.date(from: value)
  }

  /// Converts Flutter channel args into UserDefaults-safe property-list values.
  /// Drops `NSNull` / unsupported types (they crash `setObject:forKey:`).
  private static func propertyListObject(_ value: Any) -> Any? {
    switch value {
    case is NSNull:
      return nil
    case let string as String:
      return string
    case let number as NSNumber:
      return number
    case let date as Date:
      return date
    case let data as Data:
      return data
    case let dict as [String: Any]:
      var out: [String: Any] = [:]
      out.reserveCapacity(dict.count)
      for (key, nested) in dict {
        if let cleaned = propertyListObject(nested) {
          out[key] = cleaned
        }
      }
      return out
    case let array as [Any]:
      return array.compactMap(propertyListObject)
    default:
      return nil
    }
  }
}
