import ActivityKit
import BackgroundTasks
import Flutter
import Foundation
import UIKit

/// Flutter bridge for iOS ActivityKit Prayer Live Activities.
enum PrayerLiveActivityBridge {
  private static let channelName = "com.app.deenly.deenly/prayer_live_activity"
  private static let appGroup = "group.com.rnr.deenfocus"
  private static let payloadKey = "prayer_live_activity_payload"
  static let refreshTaskId = "com.rnr.deenfocus.prayer-live-activity-refresh"

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

  /// Must run in `didFinishLaunching` before the app finishes launching.
  static func registerBackgroundTasks() {
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: refreshTaskId,
      using: nil
    ) { task in
      handleBackgroundRefresh(task: task)
    }
  }

  static func scheduleBackgroundRefresh() {
    guard #available(iOS 16.2, *) else { return }
    guard let payload = storedPayload() else { return }
    guard let next = nextTransitionDate(from: payload), next > Date() else { return }
    let request = BGAppRefreshTaskRequest(identifier: refreshTaskId)
    request.earliestBeginDate = next
    do {
      try BGTaskScheduler.shared.submit(request)
    } catch {
      NSLog("[DeenFocus][LIVE_ACTIVITY] BG refresh schedule failed: \(error)")
    }
  }

  static func refreshFromStorage(completion: (() -> Void)? = nil) {
    guard #available(iOS 16.2, *) else {
      completion?()
      return
    }
    guard var payload = storedPayload() else {
      completion?()
      return
    }
    payload = advancePayload(payload)
    storePayload(payload)
    apply(payload: payload) { _ in completion?() }
    scheduleBackgroundRefresh()
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
    storePayload(payload)
    apply(payload: payload) { error in
      if let error {
        result(
          FlutterError(
            code: "start_failed",
            message: error.localizedDescription,
            details: nil
          )
        )
      } else {
        result(nil)
      }
    }
    scheduleBackgroundRefresh()
  }

  private static func stop(result: @escaping FlutterResult) {
    guard #available(iOS 16.2, *) else {
      result(nil)
      return
    }
    BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: refreshTaskId)
    Task {
      for activity in Activity<PrayerLiveActivityAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
      UserDefaults(suiteName: appGroup)?.removeObject(forKey: payloadKey)
      await MainActor.run { result(nil) }
    }
  }

  @available(iOS 16.2, *)
  private static func apply(payload: [String: Any], completion: ((Error?) -> Void)? = nil) {
    let brand = (payload["brandName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    let attributes = PrayerLiveActivityAttributes(
      brandName: (brand?.isEmpty == false) ? brand! : "Deen Focus"
    )
    let state = contentState(from: payload)
    let presentation = PrayerLiveActivityPresentation.resolve(state: state, at: Date())
    let staleDate = presentation.nextPrayerDate ?? Date().addingTimeInterval(60 * 30)
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
        await MainActor.run { completion?(nil) }
      } catch {
        NSLog("[DeenFocus][LIVE_ACTIVITY] apply failed: \(error.localizedDescription)")
        await MainActor.run { completion?(error) }
      }
    }
  }

  @available(iOS 16.2, *)
  private static func contentState(from args: [String: Any]) -> PrayerLiveActivityAttributes.ContentState {
    let prayers = parseSlots(args["prayers"] as? [[String: Any]] ?? [])
    let currentId = args["currentPrayerId"] as? String ?? ""
    let index = prayers.firstIndex(where: { $0.id == currentId }) ?? 0
    let progress = prayers.isEmpty ? 0.0 : Double(index) / Double(max(prayers.count - 1, 1))
    let nowLabel = args["nowLabel"] as? String ?? "Now"
    let upNextLabel = args["upNextLabel"] as? String ?? nowLabel

    return PrayerLiveActivityAttributes.ContentState(
      currentPrayerId: currentId,
      currentPrayerLabel: args["currentPrayerLabel"] as? String ?? "",
      currentPrayerTimeLabel: args["currentPrayerTimeLabel"] as? String ?? "",
      nextPrayerLine: args["nextPrayerLine"] as? String ?? "",
      locationName: args["locationName"] as? String ?? "",
      updatedAtLabel: args["updatedAtLabel"] as? String ?? "",
      nowLabel: nowLabel,
      upNextLabel: upNextLabel,
      nextPrayerLineTemplate: args["nextPrayerLineTemplate"] as? String ?? "",
      prayerProgress: min(max(progress, 0), 1),
      prayers: prayers,
      tomorrowFajr: parseTomorrowFajr(from: args)
    )
  }

  @available(iOS 16.2, *)
  private static func parseSlots(_ raw: [[String: Any]]) -> [PrayerLiveActivitySlot] {
    raw.compactMap { row in
      guard let time = parseDate(row["isoTime"] as? String) else { return nil }
      return PrayerLiveActivitySlot(
        id: row["id"] as? String ?? "",
        label: row["label"] as? String ?? "",
        timeLabel: row["timeLabel"] as? String ?? "",
        time: time
      )
    }
  }

  @available(iOS 16.2, *)
  private static func parseTomorrowFajr(from args: [String: Any]) -> PrayerLiveActivitySlot? {
    guard let time = parseDate(args["tomorrowFajrIso"] as? String) else { return nil }
    let label = (args["tomorrowFajrLabel"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    let timeLabel = (args["tomorrowFajrTimeLabel"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    return PrayerLiveActivitySlot(
      id: "fajr",
      label: (label?.isEmpty == false) ? label! : "Fajr",
      timeLabel: timeLabel ?? "",
      time: time
    )
  }

  private static func storedPayload() -> [String: Any]? {
    UserDefaults(suiteName: appGroup)?.dictionary(forKey: payloadKey)
  }

  private static func storePayload(_ payload: [String: Any]) {
    UserDefaults(suiteName: appGroup)?.set(payload, forKey: payloadKey)
  }

  private static func nextTransitionDate(from payload: [String: Any]) -> Date? {
    let now = Date()
    var dates: [Date] = []
    if let prayers = payload["prayers"] as? [[String: Any]] {
      dates.append(contentsOf: prayers.compactMap { parseDate($0["isoTime"] as? String) })
    }
    if let tomorrow = parseDate(payload["tomorrowFajrIso"] as? String) {
      dates.append(tomorrow)
    }
    return dates.filter { $0 > now }.sorted().first
  }

  private static func advancePayload(_ payload: [String: Any]) -> [String: Any] {
    var updated = payload
    let prayers = payload["prayers"] as? [[String: Any]] ?? []
    guard !prayers.isEmpty else { return payload }
    let now = Date()
    let firstTime = parseDate(prayers[0]["isoTime"] as? String)
    if let firstTime, now < firstTime {
      updated["beforeFirstPrayer"] = true
      updated["nextPrayerIso"] = prayers[0]["isoTime"] as? String ?? ""
      return updated
    }

    updated["beforeFirstPrayer"] = false
    var currentIndex = 0
    for (index, row) in prayers.enumerated() {
      guard let time = parseDate(row["isoTime"] as? String) else { continue }
      if time <= now { currentIndex = index }
    }
    let current = prayers[currentIndex]
    updated["currentPrayerId"] = current["id"] as? String ?? ""
    updated["currentPrayerLabel"] = current["label"] as? String ?? ""
    updated["currentPrayerTimeLabel"] = current["timeLabel"] as? String ?? ""
    updated["currentPrayerIso"] = current["isoTime"] as? String ?? ""

    if currentIndex + 1 < prayers.count {
      let next = prayers[currentIndex + 1]
      applyNextPrayer(to: &updated, from: next)
    } else if let tomorrowIso = payload["tomorrowFajrIso"] as? String,
              let tomorrow = parseDate(tomorrowIso),
              tomorrow > now {
      updated["nextPrayerId"] = "fajr"
      updated["nextPrayerLabel"] = payload["tomorrowFajrLabel"] as? String ?? "Fajr"
      updated["nextPrayerTimeLabel"] = payload["tomorrowFajrTimeLabel"] as? String ?? ""
      updated["nextPrayerIso"] = tomorrowIso
      let template = payload["nextPrayerLineTemplate"] as? String ?? "{prayer} at {time}"
      let label = updated["nextPrayerLabel"] as? String ?? "Fajr"
      let timeLabel = updated["nextPrayerTimeLabel"] as? String ?? ""
      updated["nextPrayerLine"] = template
        .replacingOccurrences(of: "{prayer}", with: label)
        .replacingOccurrences(of: "{time}", with: timeLabel)
    } else {
      updated["nextPrayerId"] = ""
      updated["nextPrayerLabel"] = ""
      updated["nextPrayerTimeLabel"] = ""
      updated["nextPrayerIso"] = ""
      updated["nextPrayerLine"] = ""
    }
    return updated
  }

  private static func applyNextPrayer(to payload: inout [String: Any], from next: [String: Any]) {
    let id = next["id"] as? String ?? ""
    let label = next["label"] as? String ?? ""
    let timeLabel = next["timeLabel"] as? String ?? ""
    let isoTime = next["isoTime"] as? String ?? ""
    payload["nextPrayerId"] = id
    payload["nextPrayerLabel"] = label
    payload["nextPrayerTimeLabel"] = timeLabel
    payload["nextPrayerIso"] = isoTime
    let template = payload["nextPrayerLineTemplate"] as? String ?? "{prayer} at {time}"
    payload["nextPrayerLine"] = template
      .replacingOccurrences(of: "{prayer}", with: label)
      .replacingOccurrences(of: "{time}", with: timeLabel)
  }

  private static func handleBackgroundRefresh(task: BGTask) {
    scheduleBackgroundRefresh()
    task.expirationHandler = {
      task.setTaskCompleted(success: false)
    }
    refreshFromStorage {
      task.setTaskCompleted(success: true)
    }
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
    local.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    if let date = local.date(from: value) { return date }
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
