import DeviceActivity
import Foundation

/// Registers one-shot Device Activity intervals so ManagedSettings shields can turn on/off
/// while the Flutter app is suspended (Salah / Night Discipline).
@available(iOS 16.0, *)
enum FocusDeviceActivityScheduler {
  static let appGroupId = "group.com.rnr.deenfocus.widgets"
  private static let selectionKey = "focus_device_activity_selection_b64"
  private static let activityNamesKey = "focus_device_activity_names"

  private static let isoFormatter: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return f
  }()

  private static let isoFormatterNoFrac: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime]
    return f
  }()

  static func cancelAllSchedules() {
    let defaults = UserDefaults(suiteName: appGroupId)
    let rawNames = defaults?.stringArray(forKey: activityNamesKey) ?? []
    guard !rawNames.isEmpty else { return }
    let center = DeviceActivityCenter()
    let names = rawNames.map { DeviceActivityName($0) }
    center.stopMonitoring(names)
    defaults?.removeObject(forKey: activityNamesKey)
  }

  static func sync(activeMode: String?, encodedSelection: String?, transitions: [[String: Any]]) {
    cancelAllSchedules()

    let defaults = UserDefaults(suiteName: appGroupId)
    let trackModes =
      activeMode == "salah" || activeMode == "nightDiscipline" || !transitions.isEmpty
    guard trackModes, let enc = encodedSelection, !enc.isEmpty else {
      defaults?.removeObject(forKey: selectionKey)
      return
    }

    defaults?.set(enc, forKey: selectionKey)

    let center = DeviceActivityCenter()
    let cal = Calendar.current
    let minDuration: TimeInterval = 15 * 60
    let now = Date()
    var names: [String] = []

    for t in transitions {
      guard let locked = t["isLocked"] as? Bool, locked else { continue }

      let startMs: Int64 = {
        if let n = t["atMillis"] as? NSNumber { return n.int64Value }
        if let i = t["atMillis"] as? Int64 { return i }
        if let i = t["atMillis"] as? Int { return Int64(i) }
        return 0
      }()
      guard startMs > 0 else { continue }

      var endDate: Date?
      if let nextMs = t["nextChangeAtMillis"] as? NSNumber {
        endDate = Date(timeIntervalSince1970: nextMs.doubleValue / 1000.0)
      }
      if endDate == nil, let s = t["nextChangeAt"] as? String {
        endDate = isoFormatter.date(from: s) ?? isoFormatterNoFrac.date(from: s)
      }
      guard var intervalEnd = endDate else { continue }

      var start = Date(timeIntervalSince1970: Double(startMs) / 1000.0)
      if intervalEnd.timeIntervalSince(start) < minDuration {
        intervalEnd = start.addingTimeInterval(minDuration)
      }
      guard intervalEnd > now else { continue }

      if start < now {
        start = now.addingTimeInterval(10)
      }
      if start >= intervalEnd { continue }

      let comps: Set<Calendar.Component> = [
        .year, .month, .day, .hour, .minute, .second,
      ]
      let startC = cal.dateComponents(comps, from: start)
      let endC = cal.dateComponents(comps, from: intervalEnd)

      let nameStr = "deenly_focus_\(startMs)"
      let activityName = DeviceActivityName(nameStr)
      let schedule = DeviceActivitySchedule(
        intervalStart: startC,
        intervalEnd: endC,
        repeats: false
      )
      do {
        try center.startMonitoring(activityName, during: schedule)
        names.append(nameStr)
      } catch {
        // Non-fatal: system limits or invalid schedule.
      }
    }

    defaults?.set(names, forKey: activityNamesKey)
  }
}
