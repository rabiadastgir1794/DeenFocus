import DeviceActivity
import Foundation

/// Registers one-shot Device Activity intervals so ManagedSettings shields can turn on/off
/// while the Flutter app is suspended (Salah / Night Discipline).
enum FocusIOSDebugLogger {
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

  private static func documentsLogURL() -> URL? {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      .first?
      .appendingPathComponent(fileName)
  }

  @discardableResult
  static func exportToDocuments() -> String? {
    guard
      let sharedURL = sharedLogURL(),
      let documentsURL = documentsLogURL()
    else {
      return nil
    }

    if !FileManager.default.fileExists(atPath: sharedURL.path) {
      return documentsURL.path
    }

    do {
      let data = try Data(contentsOf: sharedURL)
      try data.write(to: documentsURL, options: .atomic)
    } catch {
      return documentsURL.path
    }

    return documentsURL.path
  }

  static func path() -> String? {
    exportToDocuments() ?? sharedLogURL()?.path
  }

  static func clear() {
    let fileManager = FileManager.default
    if let sharedURL = sharedLogURL() {
      try? fileManager.removeItem(at: sharedURL)
    }
    if let documentsURL = documentsLogURL() {
      try? fileManager.removeItem(at: documentsURL)
    }
  }

  static func append(_ tag: String, _ message: String) {
    guard let url = sharedLogURL() else { return }
    let timestamp = formatter.string(from: Date())
    let line = "[\(timestamp)] [\(tag)] \(message)\n"
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

    _ = exportToDocuments()
  }
}

@available(iOS 16.0, *)
enum FocusDeviceActivityScheduler {
  static let appGroupId = "group.com.rnr.deenfocus"
  static let shieldActiveModeKey = "focus_shield_active_mode"
  static let shieldLockReasonKey = "focus_shield_lock_reason"
  static let shieldFlutterLockedKey = "focus_flutter_is_locked"
  static let shieldNativeLockedKey = "focus_native_shield_locked"
  /// Mirrors the Flutter dark-mode toggle for shield UI (the app extension cannot read the main app theme).
  static let shieldAppThemeIsDarkKey = "focus_shield_app_theme_is_dark"
  static let monitorLastWallClockMsKey = "focus_monitor_last_wall_ms"
  static let monitorLastUptimeMsKey = "focus_monitor_last_uptime_ms"
  private static let selectionKey = "focus_device_activity_selection_b64"
  private static let activityNamesKey = "focus_device_activity_names"
  private static let activityActionsKey = "focus_device_activity_actions"
  private static let activityModesKey = "focus_device_activity_modes"
  private static let activityReasonsKey = "focus_device_activity_reasons"
  private static let activityScheduleSignatureKey = "focus_device_activity_schedule_signature"
  private static let repeatingNightLockActivityName = "deenly_focus_night_lock_daily"

  /// iOS can occasionally drop DeviceActivity monitors while our persisted
  /// signature/names remain unchanged. Validate runtime registrations before
  /// deciding to skip re-registration.
  private static func hasRegistrationDrift(expectedNames: [String]) -> Bool {
    guard !expectedNames.isEmpty else { return false }
    let center = DeviceActivityCenter()
    let runtimeNames = Set(center.activities.map(\.rawValue))
    let expected = Set(expectedNames)
    return runtimeNames != expected
  }

  static func cancelAllSchedules() {
    let defaults = UserDefaults(suiteName: appGroupId)
    let rawNames = defaults?.stringArray(forKey: activityNamesKey) ?? []
    guard !rawNames.isEmpty else { return }
    FocusIOSDebugLogger.append(
      "ios.scheduler.cancel",
      "stopping \(rawNames.count) schedule(s): \(rawNames.joined(separator: ","))"
    )
    let center = DeviceActivityCenter()
    let names = rawNames.map { DeviceActivityName($0) }
    center.stopMonitoring(names)
    defaults?.removeObject(forKey: activityNamesKey)
    defaults?.removeObject(forKey: activityActionsKey)
    defaults?.removeObject(forKey: activityModesKey)
    defaults?.removeObject(forKey: activityReasonsKey)
    defaults?.removeObject(forKey: activityScheduleSignatureKey)
  }

  /// Stops one-shot DeviceActivity monitors but leaves the repeating overnight night lock
  /// running when [preserveRepeatingNight] is true. Restarting that repeating schedule
  /// mid-window can prevent `intervalDidStart` from firing again until the next cycle,
  /// which left apps unlocked after a Salah temporary unlock resynced native scheduling.
  private static func cancelOneShotsPreservingRepeatingNightLock(
    preserveRepeatingNight: Bool,
    defaults: UserDefaults?
  ) {
    let rawNames = defaults?.stringArray(forKey: activityNamesKey) ?? []
    guard !rawNames.isEmpty else { return }

    let center = DeviceActivityCenter()
    let actionsAll = defaults?.dictionary(forKey: activityActionsKey) as? [String: String] ?? [:]
    let modesAll = defaults?.dictionary(forKey: activityModesKey) as? [String: String] ?? [:]
    let reasonsAll = defaults?.dictionary(forKey: activityReasonsKey) as? [String: String] ?? [:]

    if preserveRepeatingNight {
      FocusIOSDebugLogger.append(
        "ios.scheduler.cancel",
        "preserving repeating night lock; stopping other schedules only"
      )
    } else {
      FocusIOSDebugLogger.append(
        "ios.scheduler.cancel",
        "stopping \(rawNames.count) schedule(s): \(rawNames.joined(separator: ","))"
      )
    }

    for name in rawNames {
      if preserveRepeatingNight && name == repeatingNightLockActivityName {
        continue
      }
      center.stopMonitoring([DeviceActivityName(name)])
    }

    if preserveRepeatingNight,
      rawNames.contains(repeatingNightLockActivityName)
    {
      var names = [repeatingNightLockActivityName]
      var actions: [String: String] = [:]
      var modes: [String: String] = [:]
      var reasons: [String: String] = [:]
      if let a = actionsAll[repeatingNightLockActivityName] {
        actions[repeatingNightLockActivityName] = a
      }
      if let m = modesAll[repeatingNightLockActivityName] {
        modes[repeatingNightLockActivityName] = m
      }
      if let r = reasonsAll[repeatingNightLockActivityName] {
        reasons[repeatingNightLockActivityName] = r
      }
      defaults?.set(names, forKey: activityNamesKey)
      defaults?.set(actions, forKey: activityActionsKey)
      defaults?.set(modes, forKey: activityModesKey)
      defaults?.set(reasons, forKey: activityReasonsKey)
    } else {
      defaults?.removeObject(forKey: activityNamesKey)
      defaults?.removeObject(forKey: activityActionsKey)
      defaults?.removeObject(forKey: activityModesKey)
      defaults?.removeObject(forKey: activityReasonsKey)
      defaults?.removeObject(forKey: activityScheduleSignatureKey)
    }
  }

  private static func extractSleepWakeSegment(from signature: String?) -> String? {
    guard let signature else { return nil }
    var sleep: String?
    var wake: String?
    for part in signature.split(separator: "|") {
      let p = String(part)
      if p.hasPrefix("sleep=") { sleep = p }
      if p.hasPrefix("wake=") { wake = p }
    }
    guard let sleep, let wake else { return nil }
    return "\(sleep)|\(wake)"
  }

  /// True when local time is inside an overnight sleep window (sleep start ≥ wake end on the clock).
  private static func isNowInsideOvernightNightSchedule(
    now: Date,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int
  ) -> Bool {
    let startM = startHour * 60 + startMinute
    let endM = endHour * 60 + endMinute
    guard startM >= endM else { return false }
    let cal = Calendar.current
    let h = cal.component(.hour, from: now)
    let mi = cal.component(.minute, from: now)
    let cur = h * 60 + mi
    return cur >= startM || cur < endM
  }

  static func sync(
    activeMode: String?,
    encodedSelection: String?,
    transitions: [[String: Any]],
    nightDisciplineEnabled: Bool,
    nightStartHour: Int,
    nightStartMinute: Int,
    nightEndHour: Int,
    nightEndMinute: Int
  ) {
    let defaults = UserDefaults(suiteName: appGroupId)
    let trackModes =
      activeMode == "salah" || activeMode == "nightDiscipline" || !transitions.isEmpty ||
      nightDisciplineEnabled
    let hasSchedulingInputs = trackModes && (encodedSelection?.isEmpty == false)
    let scheduleSignature = makeScheduleSignature(
      activeMode: activeMode,
      encodedSelection: encodedSelection,
      transitions: transitions,
      nightDisciplineEnabled: nightDisciplineEnabled,
      nightStartHour: nightStartHour,
      nightStartMinute: nightStartMinute,
      nightEndHour: nightEndHour,
      nightEndMinute: nightEndMinute
    )
    let previousSignature = defaults?.string(forKey: activityScheduleSignatureKey)
    let existingNames = defaults?.stringArray(forKey: activityNamesKey) ?? []

    let registrationDrift = hasRegistrationDrift(expectedNames: existingNames)
    if previousSignature == scheduleSignature && (!hasSchedulingInputs || !existingNames.isEmpty)
      && !registrationDrift
    {
      FocusIOSDebugLogger.append(
        "ios.scheduler.sync",
        "skipped re-registration because schedule signature is unchanged"
      )
      return
    }
    if registrationDrift {
      FocusIOSDebugLogger.append(
        "ios.scheduler.sync",
        "forcing re-registration because runtime monitor set drifted from persisted names"
      )
    }

    let syncNow = Date()
    let startMinutes = nightStartHour * 60 + nightStartMinute
    let endMinutes = nightEndHour * 60 + nightEndMinute
    let isOvernightNightRange = startMinutes >= endMinutes
    let runtimeActivityNames = Set(DeviceActivityCenter().activities.map(\.rawValue))
    let sleepWakeUnchanged =
      extractSleepWakeSegment(from: previousSignature)
      == extractSleepWakeSegment(from: scheduleSignature)
    let preserveRepeatingNight =
      !registrationDrift
      && nightDisciplineEnabled
      && isOvernightNightRange
      && sleepWakeUnchanged
      && existingNames.contains(repeatingNightLockActivityName)
      && runtimeActivityNames.contains(repeatingNightLockActivityName)
      && isNowInsideOvernightNightSchedule(
        now: syncNow,
        startHour: nightStartHour,
        startMinute: nightStartMinute,
        endHour: nightEndHour,
        endMinute: nightEndMinute
      )

    if preserveRepeatingNight {
      cancelOneShotsPreservingRepeatingNightLock(true, defaults: defaults)
    } else {
      cancelAllSchedules()
    }

    FocusIOSDebugLogger.append(
      "ios.scheduler.sync",
      "activeMode=\(activeMode ?? "nil") nightEnabled=\(nightDisciplineEnabled) transitions=\(transitions.count) sleep=\(String(format: "%02d:%02d", nightStartHour, nightStartMinute)) wake=\(String(format: "%02d:%02d", nightEndHour, nightEndMinute)) preserveRepeatingNight=\(preserveRepeatingNight)"
    )
    guard trackModes, let enc = encodedSelection, !enc.isEmpty else {
      defaults?.removeObject(forKey: selectionKey)
      defaults?.set(scheduleSignature, forKey: activityScheduleSignatureKey)
      FocusIOSDebugLogger.append(
        "ios.scheduler.sync",
        "skipped scheduling because tracking is disabled or selection data is empty"
      )
      return
    }

    defaults?.set(enc, forKey: selectionKey)

    let center = DeviceActivityCenter()
    let cal = Calendar.current
    let triggerDuration: TimeInterval = 15 * 60
    let now = syncNow
    var names: [String] = []
    var actionsByName: [String: String] = [:]
    var modesByName: [String: String] = [:]
    var reasonsByName: [String: String] = [:]
    var didRegisterRepeatingNightLock = false

    if preserveRepeatingNight {
      names.append(repeatingNightLockActivityName)
      actionsByName[repeatingNightLockActivityName] = "lock"
      modesByName[repeatingNightLockActivityName] = "nightDiscipline"
      reasonsByName[repeatingNightLockActivityName] =
        "Sleep Lock is active during your protected schedule."
      didRegisterRepeatingNightLock = true
      FocusIOSDebugLogger.append(
        "ios.scheduler.register",
        "preserved repeating night lock name=\(repeatingNightLockActivityName) sleep=\(String(format: "%02d:%02d", nightStartHour, nightStartMinute)) wake=\(String(format: "%02d:%02d", nightEndHour, nightEndMinute))"
      )
    } else if nightDisciplineEnabled && isOvernightNightRange {
      let lockStart = DateComponents(
        hour: nightStartHour,
        minute: nightStartMinute,
        second: 0
      )
      let lockEnd = DateComponents(
        hour: nightEndHour,
        minute: nightEndMinute,
        second: 0
      )

      let lockActivityName = DeviceActivityName(repeatingNightLockActivityName)
      let lockSchedule = DeviceActivitySchedule(
        intervalStart: lockStart,
        intervalEnd: lockEnd,
        repeats: true
      )

      do {
        try center.startMonitoring(lockActivityName, during: lockSchedule)
        names.append(repeatingNightLockActivityName)
        actionsByName[repeatingNightLockActivityName] = "lock"
        modesByName[repeatingNightLockActivityName] = "nightDiscipline"
        reasonsByName[repeatingNightLockActivityName] =
          "Sleep Lock is active during your protected schedule."
        didRegisterRepeatingNightLock = true
        FocusIOSDebugLogger.append(
          "ios.scheduler.register",
          "registered repeating night lock name=\(repeatingNightLockActivityName) sleep=\(String(format: "%02d:%02d", nightStartHour, nightStartMinute)) wake=\(String(format: "%02d:%02d", nightEndHour, nightEndMinute))"
        )
      } catch {
        // Non-fatal: rely on one-shot schedules below when available.
        FocusIOSDebugLogger.append(
          "ios.scheduler.register",
          "failed repeating night lock name=\(repeatingNightLockActivityName) error=\(error.localizedDescription)"
        )
      }
    }

    for t in transitions {
      guard let locked = t["isLocked"] as? Bool else { continue }
      let transitionMode = t["activeMode"] as? String
      let transitionReason = t["lockReason"] as? String
      if transitionMode == "nightDiscipline" && locked && didRegisterRepeatingNightLock {
        continue
      }

      let startMs: Int64 = {
        if let n = t["atMillis"] as? NSNumber { return n.int64Value }
        if let i = t["atMillis"] as? Int64 { return i }
        if let i = t["atMillis"] as? Int { return Int64(i) }
        return 0
      }()
      guard startMs > 0 else { continue }

      let action = locked ? "lock" : "unlock"
      // iOS Salah: do not register scheduled unlock at prayer-window end — the user
      // uses home temporary unlock; shields clear on next Flutter foreground sync.
      // Night (and combined wake) unlock one-shots stay registered.
      if !locked, transitionMode == "salah" {
        FocusIOSDebugLogger.append(
          "ios.scheduler.register",
          "skipped salah scheduled auto-unlock name=deenly_focus_unlock_\(startMs) at=\(Date(timeIntervalSince1970: Double(startMs) / 1000.0))"
        )
        continue
      }

      let nameStr = "deenly_focus_\(action)_\(startMs)"
      let start = Date(timeIntervalSince1970: Double(startMs) / 1000.0)
      if !start.timeIntervalSince(now).isFinite || start <= now {
        FocusIOSDebugLogger.append(
          "ios.scheduler.register",
          "skipped past action=\(action) name=\(nameStr) at=\(start)"
        )
        continue
      }
      let intervalEnd = start.addingTimeInterval(triggerDuration)

      let comps: Set<Calendar.Component> = [
        .year, .month, .day, .hour, .minute, .second,
      ]
      let startC = cal.dateComponents(comps, from: start)
      let endC = cal.dateComponents(comps, from: intervalEnd)

      let activityName = DeviceActivityName(nameStr)
      let schedule = DeviceActivitySchedule(
        intervalStart: startC,
        intervalEnd: endC,
        repeats: false
      )
      do {
        try center.startMonitoring(activityName, during: schedule)
        names.append(nameStr)
        actionsByName[nameStr] = action
        if let transitionMode, !transitionMode.isEmpty {
          modesByName[nameStr] = transitionMode
        }
        if let transitionReason, !transitionReason.isEmpty {
          reasonsByName[nameStr] = transitionReason
        }
        FocusIOSDebugLogger.append(
          "ios.scheduler.register",
          "registered one-shot action=\(action) name=\(nameStr) at=\(start) end=\(intervalEnd)"
        )
      } catch {
        // Non-fatal: system limits or invalid schedule.
        FocusIOSDebugLogger.append(
          "ios.scheduler.register",
          "failed one-shot action=\(action) name=\(nameStr) at=\(start) error=\(error.localizedDescription)"
        )
      }
    }

    defaults?.set(names, forKey: activityNamesKey)
    defaults?.set(actionsByName, forKey: activityActionsKey)
    defaults?.set(modesByName, forKey: activityModesKey)
    defaults?.set(reasonsByName, forKey: activityReasonsKey)
    defaults?.set(scheduleSignature, forKey: activityScheduleSignatureKey)
    FocusIOSDebugLogger.append(
      "ios.scheduler.sync",
      "stored \(names.count) active schedule name(s); exportedLogPath=\(FocusIOSDebugLogger.path() ?? "nil")"
    )
  }

  private static func makeScheduleSignature(
    activeMode: String?,
    encodedSelection: String?,
    transitions: [[String: Any]],
    nightDisciplineEnabled: Bool,
    nightStartHour: Int,
    nightStartMinute: Int,
    nightEndHour: Int,
    nightEndMinute: Int
  ) -> String {
    let selection = encodedSelection ?? ""
    let selectionSignature: String
    if selection.isEmpty {
      selectionSignature = "empty"
    } else {
      let prefixPart = String(selection.prefix(64))
      let suffixPart = String(selection.suffix(64))
      selectionSignature = "len=\(selection.count)|\(prefixPart)|\(suffixPart)"
    }

    let normalizedTransitions = transitions.map { transition -> (Int64, Bool, String, String) in
      let atMillis: Int64 = {
        if let n = transition["atMillis"] as? NSNumber { return n.int64Value }
        if let i = transition["atMillis"] as? Int64 { return i }
        if let i = transition["atMillis"] as? Int { return Int64(i) }
        return 0
      }()
      let isLocked = transition["isLocked"] as? Bool ?? false
      let mode = transition["activeMode"] as? String ?? ""
      let reason = transition["lockReason"] as? String ?? ""
      return (atMillis, isLocked, mode, reason)
    }
    .sorted {
      if $0.0 != $1.0 { return $0.0 < $1.0 }
      if $0.1 != $1.1 { return !$0.1 && $1.1 }
      if $0.2 != $1.2 { return $0.2 < $1.2 }
      return $0.3 < $1.3
    }
    .map { atMillis, isLocked, mode, reason in
      "\(atMillis):\(isLocked ? 1 : 0):\(mode):\(reason)"
    }
    .joined(separator: ",")

    return [
      "mode=\(activeMode ?? "nil")",
      "night=\(nightDisciplineEnabled ? 1 : 0)",
      "sleep=\(nightStartHour):\(nightStartMinute)",
      "wake=\(nightEndHour):\(nightEndMinute)",
      "selection=\(selectionSignature)",
      "transitions=\(normalizedTransitions)",
    ].joined(separator: "|")
  }
}
