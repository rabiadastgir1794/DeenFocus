import FamilyControls
import Foundation
import ManagedSettings
import ManagedSettingsUI
import UIKit

/// Writes to the same app-group log as the main app (throttled — shield config is queried often).
private enum FocusShieldDebugLogger {
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

private enum FocusShieldSharedState {
  static let appGroupId = "group.com.rnr.deenfocus"
  static let activeModeKey = "focus_shield_active_mode"
}

private enum FocusShieldMode: String {
  case child
  case nightDiscipline
  case salah

  init(rawMode: String?) {
    switch rawMode {
    case "child", "childMode":
      self = .child
    case "nightDiscipline", "night", "sleep", "sleepLock":
      self = .nightDiscipline
    case "salah", "prayer", "prayerLock":
      self = .salah
    default:
      self = .salah
    }
  }

  var title: String {
    switch self {
    case .salah:
      return "Salah Time - Stay Focused"
    case .child:
      return "Child Focus Mode"
    case .nightDiscipline:
      return "Night Focus Mode"
    }
  }

  var subtitle: String {
    switch self {
    case .salah:
      return """
      Step away from distractions and answer the call to prayer.
      Take this moment to connect with Allah.

      Return after completing your Salah in DeenFocus.

      "Establish prayer for My remembrance."
      (Quran 20:14)
      """
    case .child:
      return """
      This device is currently in child focus mode to help maintain a safe and balanced digital experience.

      Some apps are temporarily unavailable.

      "Teach your children prayer when they are seven."
      (Hadith - Abu Dawood)
      """
    case .nightDiscipline:
      return """
      It's time to rest and disconnect from digital distractions.

      Put your device aside and enjoy a peaceful night.

      "And We made your sleep a means for rest."
      (Quran 78:9)
      """
    }
  }

  var primaryButton: String {
    let nb = "\u{00a0}"
    switch self {
    case .salah:
      return "Start\(nb)Salah"
    case .child:
      return "Continue\(nb)in\(nb)Safe\(nb)Mode"
    case .nightDiscipline:
      return "Good\(nb)Night"
    }
  }
}

@available(iOSApplicationExtension 16.0, *)
final class FocusShieldConfigurationExtension: ShieldConfigurationDataSource {
  private static var lastShieldLogMono: TimeInterval = 0
  private static let shieldLogMinInterval: TimeInterval = 2.0

  private struct ThemePalette {
    let backgroundColor: UIColor
    let titleColor: UIColor
    let subtitleColor: UIColor
    let buttonBackgroundColor: UIColor
    let buttonTextColor: UIColor
  }

  private var sharedDefaults: UserDefaults? {
    UserDefaults(suiteName: FocusShieldSharedState.appGroupId)
  }

  override func configuration(shielding application: Application) -> ShieldConfiguration {
    logShieldDisplayIfNeeded(kind: "application", detail: String(describing: application))
    return makeConfiguration()
  }

  override func configuration(
    shielding application: Application,
    in category: ActivityCategory
  ) -> ShieldConfiguration {
    logShieldDisplayIfNeeded(
      kind: "application.category",
      detail: "\(String(describing: application)) category=\(String(describing: category))"
    )
    return makeConfiguration()
  }

  override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
    logShieldDisplayIfNeeded(kind: "webDomain", detail: String(describing: webDomain))
    return makeConfiguration()
  }

  override func configuration(
    shielding webDomain: WebDomain,
    in category: ActivityCategory
  ) -> ShieldConfiguration {
    logShieldDisplayIfNeeded(
      kind: "webDomain.category",
      detail: "\(String(describing: webDomain)) category=\(String(describing: category))"
    )
    return makeConfiguration()
  }

  private func logShieldDisplayIfNeeded(kind: String, detail: String) {
    let now = ProcessInfo.processInfo.systemUptime
    if now - Self.lastShieldLogMono < Self.shieldLogMinInterval { return }
    Self.lastShieldLogMono = now
    let mode = sharedDefaults?.string(forKey: FocusShieldSharedState.activeModeKey) ?? "?"
    FocusShieldDebugLogger.append(
      "ios.shield.display",
      "\(kind) mode=\(mode) detail=\(detail)"
    )
  }

  private func makeConfiguration() -> ShieldConfiguration {
    let modeRawValue = sharedDefaults?.string(forKey: FocusShieldSharedState.activeModeKey)
    let mode = FocusShieldMode(rawMode: modeRawValue)
    sharedDefaults?.synchronize()
    let palette = themePalette()

    return ShieldConfiguration(
      backgroundBlurStyle: nil,
      backgroundColor: palette.backgroundColor,
      icon: nil,
      title: ShieldConfiguration.Label(
        text: mode.title,
        color: palette.titleColor
      ),
      subtitle: ShieldConfiguration.Label(
        text: mode.subtitle,
        color: palette.subtitleColor
      ),
      primaryButtonLabel: ShieldConfiguration.Label(
        text: mode.primaryButton,
        color: palette.buttonTextColor
      ),
      primaryButtonBackgroundColor: palette.buttonBackgroundColor,
      secondaryButtonLabel: nil
    )
  }

  private func themePalette() -> ThemePalette {
    let background = UIColor { traits in
      traits.userInterfaceStyle == .dark ? .black : .white
    }
    let foreground = UIColor { traits in
      traits.userInterfaceStyle == .dark ? .white : .black
    }
    let buttonBackground = UIColor(red: 0.306, green: 0.604, blue: 0.486, alpha: 1.0)  // #4E9A7C
    let buttonText = UIColor.white

    return ThemePalette(
      backgroundColor: background,
      titleColor: foreground,
      subtitleColor: foreground,
      buttonBackgroundColor: buttonBackground,
      buttonTextColor: buttonText
    )
  }
}
