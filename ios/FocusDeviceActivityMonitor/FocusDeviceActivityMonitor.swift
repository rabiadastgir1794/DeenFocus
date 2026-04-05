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
  private static let activityModesKey = "focus_device_activity_modes"
  private static let activityReasonsKey = "focus_device_activity_reasons"
  private static let shieldActiveModeKey = "focus_shield_active_mode"
  private static let shieldLockReasonKey = "focus_shield_lock_reason"
  private static let shieldFlutterLockedKey = "focus_flutter_is_locked"
  private static let monitorLastWallClockMsKey = "focus_monitor_last_wall_ms"
  private static let monitorLastUptimeMsKey = "focus_monitor_last_uptime_ms"
  private static let clockJumpThresholdMs: Double = 90_000

  override func intervalDidStart(for activity: DeviceActivityName) {
    super.intervalDidStart(for: activity)
    let defaults = UserDefaults(suiteName: Self.appGroupId)
    let action = defaults?.dictionary(forKey: Self.activityActionsKey)?[activity.rawValue] as? String
    let mode = defaults?.dictionary(forKey: Self.activityModesKey)?[activity.rawValue] as? String
    let reason = defaults?.dictionary(forKey: Self.activityReasonsKey)?[activity.rawValue] as? String
    let clockJumped = didClockJump(defaults: defaults)
    FocusMonitorDebugLogger.append(
      "ios.monitor.start",
      "activity=\(activity.rawValue) action=\(action ?? "lock") mode=\(mode ?? "nil") clockJumped=\(clockJumped)"
    )

    if action == "unlock" {
      // Do not gate unlock on `focus_flutter_is_locked`: that flag reflects the last
      // Flutter process sync and stays stale while the app is suspended, so scheduled
      // unlocks (prayer end, wake time) were ignored and shields flickered/reapplied.
      //
      // Never skip clearing on clock jump: after sleep/wake, wall clock vs monotonic time
      // often exceeds the threshold, but the unlock interval is still the correct end of
      // night/prayer. Previously we mistakenly called `applyShield()` here, leaving apps
      // blocked after "Sleep time over" fired.
      if clockJumped {
        FocusMonitorDebugLogger.append(
          "ios.monitor.unlock",
          "clockJumped=true activity=\(activity.rawValue); still clearing shield"
        )
      }
      defaults?.removeObject(forKey: Self.shieldActiveModeKey)
      defaults?.removeObject(forKey: Self.shieldLockReasonKey)
      FocusMonitorDebugLogger.append(
        "ios.monitor.unlock",
        "clearing managed settings for activity=\(activity.rawValue)"
      )
      store.clearAllSettings()
      return
    }

    if let mode, !mode.isEmpty {
      defaults?.set(mode, forKey: Self.shieldActiveModeKey)
    }
    if let reason, !reason.isEmpty {
      defaults?.set(reason, forKey: Self.shieldLockReasonKey)
    }
    applyShield()
  }

  private func didClockJump(defaults: UserDefaults?) -> Bool {
    guard let defaults else { return false }

    let nowWallMs = Date().timeIntervalSince1970 * 1000
    let nowUptimeMs = ProcessInfo.processInfo.systemUptime * 1000

    let previousWallMs = defaults.double(forKey: Self.monitorLastWallClockMsKey)
    let previousUptimeMs = defaults.double(forKey: Self.monitorLastUptimeMsKey)

    defaults.set(nowWallMs, forKey: Self.monitorLastWallClockMsKey)
    defaults.set(nowUptimeMs, forKey: Self.monitorLastUptimeMsKey)

    if previousWallMs <= 0 || previousUptimeMs <= 0 {
      return false
    }

    let uptimeDelta = nowUptimeMs - previousUptimeMs
    if uptimeDelta < 0 {
      return false
    }

    let expectedWallMs = previousWallMs + uptimeDelta
    let skewMs = abs(nowWallMs - expectedWallMs)
    let jumped = skewMs > Self.clockJumpThresholdMs
    if jumped {
      FocusMonitorDebugLogger.append(
        "ios.monitor.clock",
        "jump detected wall=\(Int(nowWallMs)) expected=\(Int(expectedWallMs)) skewMs=\(Int(skewMs)) uptimeDeltaMs=\(Int(uptimeDelta))"
      )
    }
    return jumped
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
