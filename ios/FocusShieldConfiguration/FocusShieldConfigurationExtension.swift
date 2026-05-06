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
  /// Written by the main app via app-group UserDefaults (same key as the Runner target).
  static let appThemeIsDarkKey = "focus_shield_app_theme_is_dark"
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
    switch self {
    case .salah:
      return "Start My Salah"
    case .child:
      // Narrow no-break spaces help the system shield button stay on one line on smaller widths.
      return "Continue\u{00a0}in\u{00a0}Safe\u{00a0}Mode"
    case .nightDiscipline:
      return "Good Night"
    }
  }
}

@available(iOSApplicationExtension 16.0, *)
final class FocusShieldConfigurationExtension: ShieldConfigurationDataSource {
  private static var lastShieldLogMono: TimeInterval = 0
  private static let shieldLogMinInterval: TimeInterval = 2.0

  private struct ThemePalette {
    let blurStyle: UIBlurEffect.Style?
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
    let palette = themePalette()

    return ShieldConfiguration(
      backgroundBlurStyle: palette.blurStyle,
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
    // Prefer the in-app theme (Settings) over system appearance. `backgroundBlurStyle` blurs the
    // blocked app and reads as grey; use a solid scaffold color matching Flutter AppColors.background*.
    let storedIsDark = sharedDefaults?.object(forKey: FocusShieldSharedState.appThemeIsDarkKey) as? Bool
    let screenStyle = UIScreen.main.traitCollection.userInterfaceStyle
    let currentStyle = screenStyle == .unspecified
      ? UITraitCollection.current.userInterfaceStyle
      : screenStyle
    let systemIsDark = currentStyle != .light
    let isDarkMode = storedIsDark ?? systemIsDark

    if isDarkMode {
      // Stronger contrast on the dark scaffold — Shield labels can render slightly washed out otherwise.
      return ThemePalette(
        blurStyle: nil,
        backgroundColor: UIColor(red: 0.067, green: 0.106, blue: 0.078, alpha: 1.0),  // #111B14
        titleColor: UIColor(red: 0.96, green: 0.97, blue: 0.95, alpha: 1.0),
        subtitleColor: UIColor(red: 0.90, green: 0.91, blue: 0.88, alpha: 1.0),
        buttonBackgroundColor: UIColor(red: 0.557, green: 0.831, blue: 0.706, alpha: 1.0),  // #8ED4B4
        buttonTextColor: UIColor(red: 0.06, green: 0.14, blue: 0.11, alpha: 1.0)
      )
    }

    return ThemePalette(
      blurStyle: nil,
      backgroundColor: UIColor(red: 0.969, green: 0.961, blue: 0.941, alpha: 1.0),  // #F7F5F0
      titleColor: UIColor(red: 0.110, green: 0.239, blue: 0.180, alpha: 1.0),  // #1C2E24
      subtitleColor: UIColor(red: 0.290, green: 0.271, blue: 0.224, alpha: 1.0),  // #4A4539
      buttonBackgroundColor: UIColor(red: 0.306, green: 0.604, blue: 0.486, alpha: 1.0),  // #4E9A7C
      buttonTextColor: .white
    )
  }
}
