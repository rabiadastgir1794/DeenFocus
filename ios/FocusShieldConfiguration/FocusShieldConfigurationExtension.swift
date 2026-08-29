import Foundation
import ManagedSettings
import ManagedSettingsUI
import os
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
      return "Salah Time"
    case .child:
      return "Child Focus Mode"
    case .nightDiscipline:
      return "Night Focus Mode"
    }
  }

  var message: String {
    switch self {
    case .salah:
      return "It's time to step away from distractions and answer the call to prayer."
    case .child:
      return "A safer, more balanced space for focused screen time."
    case .nightDiscipline:
      return "It's time to rest and disconnect from digital distractions."
    }
  }

  var info: String {
    "Some apps are temporarily unavailable."
  }

  var quote: String {
    switch self {
    case .salah:
      return "Establish prayer for My remembrance."
    case .child:
      return "Teach your children prayer when they are seven."
    case .nightDiscipline:
      return "And We made your sleep a means for rest."
    }
  }

  var quoteSource: String {
    switch self {
    case .salah:
      return "Quran 20:14"
    case .child:
      return "Hadith - Abu Dawood"
    case .nightDiscipline:
      return "Quran 78:9"
    }
  }

  var subtitle: String {
    """
    \(message)

    \(info)

    “\(quote)”
    (\(quoteSource))
    """
  }

  var symbolName: String {
    switch self {
    case .salah:
      return "building.columns.fill"
    case .child:
      return "hourglass"
    case .nightDiscipline:
      return "moon.stars.fill"
    }
  }

  var primaryButton: String {
    let nb = "\u{00a0}"
    switch self {
    case .salah:
      return "Start\(nb)Salah"
    case .child:
      return "Stay\(nb)Protected"
    case .nightDiscipline:
      return "Good\(nb)Night"
    }
  }

  func heroIcon(bundle: Bundle, tint: UIColor) -> UIImage? {
    UIImage(named: assetName, in: bundle, compatibleWith: nil)
      ?? UIImage(named: assetName)
      ?? UIImage(systemName: symbolName)?.withTintColor(tint, renderingMode: .alwaysOriginal)
  }

  var assetName: String {
    switch self {
    case .child: return "child"
    case .salah: return "salah"
    case .nightDiscipline: return "night"
    }
  }
}

class FocusShieldConfigurationExtension: ShieldConfigurationDataSource {
  private static let log = Logger(
    subsystem: "com.rnr.deenfocus.FocusShieldConfiguration",
    category: "shield"
  )
  private static var lastShieldLogMono: TimeInterval = 0
  private static let shieldLogMinInterval: TimeInterval = 2.0

  private struct ThemePalette {
    let backgroundColor: UIColor
    let titleColor: UIColor
    let subtitleColor: UIColor
    let buttonBackgroundColor: UIColor
    let buttonTextColor: UIColor
    let iconColor: UIColor
  }

  private var sharedDefaults: UserDefaults? {
    UserDefaults(suiteName: FocusShieldSharedState.appGroupId)
  }

  override init() {
    super.init()
    Self.log.notice("FocusShieldConfigurationExtension.init")
    NSLog("[DeenFocus] FocusShieldConfigurationExtension.init")
    FocusShieldDebugLogger.append(
      "ios.shield.init",
      "FocusShieldConfigurationExtension instantiated"
    )
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
    Self.log.notice("configuration kind=\(kind, privacy: .public) mode=\(mode, privacy: .public)")
  }

  private func makeConfiguration() -> ShieldConfiguration {
    let modeRawValue = sharedDefaults?.string(forKey: FocusShieldSharedState.activeModeKey)
    let mode = FocusShieldMode(rawMode: modeRawValue)
    let appDark =
      mode == .nightDiscipline
      || (sharedDefaults?.bool(forKey: FocusShieldSharedState.appThemeIsDarkKey) ?? false)
    let palette = themePalette(mode: mode, appDark: appDark)
    let blur: UIBlurEffect.Style = appDark ? .systemMaterialDark : .systemMaterialLight

    return ShieldConfiguration(
      backgroundBlurStyle: blur,
      backgroundColor: palette.backgroundColor,
      icon: mode.heroIcon(
        bundle: Bundle(for: FocusShieldConfigurationExtension.self),
        tint: palette.iconColor
      ),
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

  private func themePalette(mode: FocusShieldMode, appDark: Bool) -> ThemePalette {
    let green: UIColor
    let titleGreen: UIColor
    let mint: UIColor
    let body: UIColor
    switch mode {
    case .nightDiscipline:
      green = UIColor(red: 0.29, green: 0.48, blue: 0.65, alpha: 1.0)
      titleGreen = UIColor.white
      mint = UIColor(red: 0.03, green: 0.06, blue: 0.10, alpha: 1.0)
      body = UIColor(red: 0.92, green: 0.95, blue: 0.98, alpha: 1.0)
    case .salah:
      green = UIColor(red: 0.24, green: 0.54, blue: 0.29, alpha: 1.0)
      if appDark {
        titleGreen = UIColor(red: 0.91, green: 0.95, blue: 0.85, alpha: 1.0)
        mint = UIColor(red: 0.06, green: 0.09, blue: 0.05, alpha: 1.0)
        body = UIColor(red: 0.83, green: 0.87, blue: 0.78, alpha: 1.0)
      } else {
        titleGreen = UIColor(red: 0.10, green: 0.36, blue: 0.20, alpha: 1.0)
        mint = UIColor(red: 0.92, green: 0.96, blue: 0.86, alpha: 1.0)
        body = UIColor(red: 0.24, green: 0.31, blue: 0.22, alpha: 1.0)
      }
    case .child:
      green = UIColor(red: 0.16, green: 0.54, blue: 0.37, alpha: 1.0)
      if appDark {
        titleGreen = UIColor(red: 0.91, green: 0.96, blue: 0.93, alpha: 1.0)
        mint = UIColor(red: 0.04, green: 0.09, blue: 0.07, alpha: 1.0)
        body = UIColor(red: 0.84, green: 0.91, blue: 0.86, alpha: 1.0)
      } else {
        titleGreen = UIColor(red: 0.10, green: 0.42, blue: 0.29, alpha: 1.0)
        mint = UIColor(red: 0.90, green: 0.96, blue: 0.93, alpha: 1.0)
        body = UIColor(red: 0.24, green: 0.33, blue: 0.28, alpha: 1.0)
      }
    }

    return ThemePalette(
      backgroundColor: mint,
      titleColor: titleGreen,
      subtitleColor: body,
      buttonBackgroundColor: green,
      buttonTextColor: .white,
      iconColor: green
    )
  }
}
