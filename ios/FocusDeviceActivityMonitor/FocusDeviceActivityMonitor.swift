import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings

enum FocusMonitorDebugLogger {
  private static let appGroupId = "group.com.rnr.deenfocus"
  private static let fileName = "focus_debug.log"

  private static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
    return formatter
  }()

  private static func sharedLogURL() -> URL? {
    FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: appGroupId)?
      .appendingPathComponent(fileName)
  }

  static func append(_ tag: String, _ message: String) {
    guard let url = sharedLogURL() else { return }
    let line = "[\(formatter.string(from: Date()))] [\(tag)] \(message)\n"
    let data = Data(line.utf8)

    if FileManager.default.fileExists(atPath: url.path) {
      do {
        let handle = try FileHandle(forWritingTo: url)
        handle.seekToEndOfFile()
        handle.write(data)
        handle.closeFile()
      } catch {
        try? data.write(to: url, options: .atomic)
      }
    } else {
      try? data.write(to: url, options: .atomic)
    }
  }
}

@available(iOS 16.0, *)
final class FocusDeviceActivityMonitor: DeviceActivityMonitor {
  private let store = ManagedSettingsStore(
    named: ManagedSettingsStore.Name("FocusShield")
  )
  private static let appGroupId = "group.com.rnr.deenfocus"
  private static let selectionKey = "focus_device_activity_selection_b64"
  private static let activityActionsKey = "focus_device_activity_actions"

  override func intervalDidStart(for activity: DeviceActivityName) {
    super.intervalDidStart(for: activity)
    let action = UserDefaults(suiteName: Self.appGroupId)?
      .dictionary(forKey: Self.activityActionsKey)?[activity.rawValue] as? String
    FocusMonitorDebugLogger.append(
      "ios.monitor.start",
      "activity=\(activity.rawValue) action=\(action ?? "lock")"
    )

    if action == "unlock" {
      FocusMonitorDebugLogger.append(
        "ios.monitor.unlock",
        "clearing managed settings for activity=\(activity.rawValue)"
      )
      store.clearAllSettings()
      return
    }

    applyShield()
  }

  override func intervalDidEnd(for activity: DeviceActivityName) {
    super.intervalDidEnd(for: activity)
    FocusMonitorDebugLogger.append(
      "ios.monitor.end",
      "activity=\(activity.rawValue)"
    )
    // One-shot schedules apply their action at interval start. We do not clear
    // here because that would immediately undo short lock triggers.
  }

  private func applyShield() {
    guard
      let b64 = UserDefaults(suiteName: Self.appGroupId)?.string(forKey: Self.selectionKey),
      let data = Data(base64Encoded: b64),
      let sel = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    else {
      FocusMonitorDebugLogger.append(
        "ios.monitor.lock",
        "failed to decode selection data while applying shield"
      )
      return
    }
    store.shield.applications = sel.applicationTokens
    store.shield.applicationCategories = sel.categoryTokens.isEmpty
      ? nil
      : ShieldSettings.ActivityCategoryPolicy.specific(sel.categoryTokens)
    store.shield.webDomains = sel.webDomainTokens
    store.shield.webDomainCategories = nil
    FocusMonitorDebugLogger.append(
      "ios.monitor.lock",
      "applied shield apps=\(sel.applicationTokens.count) categories=\(sel.categoryTokens.count) domains=\(sel.webDomainTokens.count)"
    )
  }
}
