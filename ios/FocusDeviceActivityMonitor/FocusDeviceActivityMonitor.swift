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
  private static let activitySetsSalahLatchKey = "focus_device_activity_sets_salah_latch"
  private static let shieldActiveModeKey = "focus_shield_active_mode"
  private static let shieldLockReasonKey = "focus_shield_lock_reason"
  private static let shieldFlutterLockedKey = "focus_flutter_is_locked"
  private static let shieldNativeLockedKey = "focus_native_shield_locked"
  private static let salahShieldLatchEpochMsKey = "focus_salah_shield_latch_epoch_ms"
  private static let monitorLastWallClockMsKey = "focus_monitor_last_wall_ms"
  private static let monitorLastUptimeMsKey = "focus_monitor_last_uptime_ms"
  private static let clockJumpThresholdMs: Double = 90_000
  private static let sleepWakeGapSlackMs: Double = 5_000
  private static let repeatingNightLockActivityName = "deenly_focus_night_lock_daily"
  private static let oneShotLockPrefix = "deenly_focus_lock_"
  private static let oneShotUnlockPrefix = "deenly_focus_unlock_"
  /// Same key as [FocusDeviceActivityScheduler.tempUnlockUntilMsKey] in the main app.
  private static let tempUnlockUntilMsKey = "focus_temp_unlock_until_ms"

  override func intervalDidStart(for activity: DeviceActivityName) {
    super.intervalDidStart(for: activity)
    let defaults = UserDefaults(suiteName: Self.appGroupId)
    let storedAction = defaults?.dictionary(forKey: Self.activityActionsKey)?[activity.rawValue] as? String
    let storedMode = defaults?.dictionary(forKey: Self.activityModesKey)?[activity.rawValue] as? String
    let reason = defaults?.dictionary(forKey: Self.activityReasonsKey)?[activity.rawValue] as? String
    let inferredAction = inferredAction(for: activity.rawValue)
    var action = storedAction
    var mode = storedMode

    if let inferredAction, let storedAction, storedAction != inferredAction {
      FocusMonitorDebugLogger.append(
        "ios.monitor.guard",
        "activity=\(activity.rawValue) action mismatch stored=\(storedAction) inferred=\(inferredAction); using inferred action"
      )
      action = inferredAction
    } else if storedAction == nil, let inferredAction {
      FocusMonitorDebugLogger.append(
        "ios.monitor.guard",
        "activity=\(activity.rawValue) missing action metadata; inferred=\(inferredAction)"
      )
      action = inferredAction
    }

    if activity.rawValue == Self.repeatingNightLockActivityName, mode != "nightDiscipline" {
      FocusMonitorDebugLogger.append(
        "ios.monitor.guard",
        "activity=\(activity.rawValue) expected mode=nightDiscipline but got mode=\(mode ?? "nil"); applying nightDiscipline fallback"
      )
      mode = "nightDiscipline"
    } else if activity.rawValue.hasPrefix("deenly_focus_"), mode == nil {
      FocusMonitorDebugLogger.append(
        "ios.monitor.guard",
        "activity=\(activity.rawValue) missing mode metadata"
      )
    }

    let effectiveAction = action ?? "lock"
    let clockJumped = didClockJump(defaults: defaults)
    FocusMonitorDebugLogger.append(
      "ios.monitor.start",
      "activity=\(activity.rawValue) action=\(effectiveAction) mode=\(mode ?? "nil") clockJumped=\(clockJumped)"
    )

    if effectiveAction == "unlock" {
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
      defaults?.set(false, forKey: Self.shieldNativeLockedKey)
      defaults?.removeObject(forKey: Self.shieldActiveModeKey)
      defaults?.removeObject(forKey: Self.shieldLockReasonKey)
      defaults?.removeObject(forKey: Self.salahShieldLatchEpochMsKey)
      FocusMonitorDebugLogger.append(
        "ios.monitor.unlock",
        "clearing managed settings and salah latch for activity=\(activity.rawValue)"
      )
      store.clearAllSettings()
      return
    }

    if effectiveAction == "lock" {
      let tempUntilMs = defaults?.double(forKey: Self.tempUnlockUntilMsKey) ?? 0
      let isNightLock =
        mode == "nightDiscipline"
        || activity.rawValue == Self.repeatingNightLockActivityName
      if tempUntilMs > 0 {
        let nowMs = Date().timeIntervalSince1970 * 1000
        if nowMs < tempUntilMs - 1 {
          if isNightLock {
            FocusMonitorDebugLogger.append(
              "ios.monitor.lock",
              "night lock overrides home temp unlock untilMs=\(Int(tempUntilMs)) activity=\(activity.rawValue)"
            )
            defaults?.removeObject(forKey: Self.tempUnlockUntilMsKey)
          } else {
            FocusMonitorDebugLogger.append(
              "ios.monitor.lock",
              "skip scheduled lock during home temp unlock untilMs=\(Int(tempUntilMs)) nowMs=\(Int(nowMs)) activity=\(activity.rawValue)"
            )
            return
          }
        }
      }
    }

    if let mode, !mode.isEmpty {
      defaults?.set(mode, forKey: Self.shieldActiveModeKey)
    }
    if let reason, !reason.isEmpty {
      defaults?.set(reason, forKey: Self.shieldLockReasonKey)
    }
    defaults?.set(true, forKey: Self.shieldNativeLockedKey)
    let setsSalahLatch =
      defaults?.dictionary(forKey: Self.activitySetsSalahLatchKey)?[activity.rawValue] as? Bool
      ?? false
    if mode == "nightDiscipline" {
      defaults?.set("nightDiscipline", forKey: Self.shieldActiveModeKey)
    }
    if mode == "salah", setsSalahLatch {
      let latchMs = lockActivityEpochMs(for: activity.rawValue)
      if latchMs > 0 {
        defaults?.set(latchMs, forKey: Self.salahShieldLatchEpochMsKey)
        FocusMonitorDebugLogger.append(
          "ios.monitor.latch",
          "set salah latch epochMs=\(Int(latchMs)) activity=\(activity.rawValue)"
        )
      }
    } else if mode == "salah" {
      FocusMonitorDebugLogger.append(
        "ios.monitor.latch",
        "skipped salah latch for activity=\(activity.rawValue) (not a prayer-window start)"
      )
    }
    applyShield()
  }

  private func lockActivityEpochMs(for activityName: String) -> Double {
    guard activityName.hasPrefix(Self.oneShotLockPrefix) else { return 0 }
    let suffix = String(activityName.dropFirst(Self.oneShotLockPrefix.count))
    return Double(suffix) ?? 0
  }

  private func inferredAction(for activityName: String) -> String? {
    if activityName == Self.repeatingNightLockActivityName {
      return "lock"
    }
    if activityName.hasPrefix(Self.oneShotLockPrefix) {
      return "lock"
    }
    if activityName.hasPrefix(Self.oneShotUnlockPrefix) {
      return "unlock"
    }
    return nil
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

    // `systemUptime` does not advance while the device sleeps, while wall clock
    // does. Treat that as normal sleep/wake drift rather than a manual clock jump.
    let wallDelta = nowWallMs - previousWallMs
    if wallDelta - uptimeDelta > Self.sleepWakeGapSlackMs {
      FocusMonitorDebugLogger.append(
        "ios.monitor.clock",
        "sleep/wake drift wallDeltaMs=\(Int(wallDelta)) uptimeDeltaMs=\(Int(uptimeDelta))"
      )
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
