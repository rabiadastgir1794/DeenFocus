import SwiftUI
import WidgetKit
import UIKit

private let widgetAppGroup = "group.com.rnr.deenfocus"

private enum WidgetDateParser {
  private static let localFormatters: [DateFormatter] = {
    let withFractional = DateFormatter()
    withFractional.locale = Locale(identifier: "en_US_POSIX")
    withFractional.timeZone = .current
    withFractional.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

    let withoutFractional = DateFormatter()
    withoutFractional.locale = Locale(identifier: "en_US_POSIX")
    withoutFractional.timeZone = .current
    withoutFractional.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

    return [withFractional, withoutFractional]
  }()

  private static let internetFormatters: [ISO8601DateFormatter] = {
    let withFractional = ISO8601DateFormatter()
    withFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    let withoutFractional = ISO8601DateFormatter()
    withoutFractional.formatOptions = [.withInternetDateTime]

    return [withFractional, withoutFractional]
  }()

  static func parse(_ value: String) -> Date? {
    for formatter in internetFormatters {
      if let date = formatter.date(from: value) {
        return date
      }
    }
    for formatter in localFormatters {
      if let date = formatter.date(from: value) {
        return date
      }
    }
    return nil
  }
}

private struct WidgetTimelinePayload: Decodable {
  let ui: WidgetUiStrings?
  let entries: [WidgetPayloadEntry]
}

private struct WidgetUiStrings: Decodable {
  let brandName: String?
  let dailyVerseTitle: String?
  let timelinePlaceholder: String?
  let setLocationMessage: String?
  let prayerProgressTitle: String?
  let prayersCompletedSubtitle: String?
  let defaultProgressCountLabel: String?
}

private struct WidgetPayloadEntry: Decodable {
  let timestamp: String
  let dayKey: String
  let dateLabel: String
  let timeLabel: String
  let isDarkMode: Bool
  let verse: WidgetVerse?
  let progress: WidgetProgress?
  let prayers: [WidgetPrayer]

  private enum CodingKeys: String, CodingKey {
    case timestamp, dayKey, dateLabel, timeLabel, isDarkMode, verse, progress, prayers
  }

  init(
    timestamp: String,
    dayKey: String,
    dateLabel: String,
    timeLabel: String,
    isDarkMode: Bool,
    verse: WidgetVerse?,
    progress: WidgetProgress?,
    prayers: [WidgetPrayer]
  ) {
    self.timestamp = timestamp
    self.dayKey = dayKey
    self.dateLabel = dateLabel
    self.timeLabel = timeLabel
    self.isDarkMode = isDarkMode
    self.verse = verse
    self.progress = progress
    self.prayers = prayers
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    timestamp = try container.decode(String.self, forKey: .timestamp)
    dayKey = try container.decode(String.self, forKey: .dayKey)
    dateLabel = try container.decode(String.self, forKey: .dateLabel)
    timeLabel = try container.decode(String.self, forKey: .timeLabel)
    isDarkMode = try container.decodeIfPresent(Bool.self, forKey: .isDarkMode) ?? false
    verse = try container.decodeIfPresent(WidgetVerse.self, forKey: .verse)
    // Soft-decode progress so a single bad field cannot blank all widgets.
    progress = try? container.decode(WidgetProgress.self, forKey: .progress)
    prayers = try container.decodeIfPresent([WidgetPrayer].self, forKey: .prayers) ?? []
  }
}

private struct WidgetVerse: Decodable {
  let text: String
  let source: String
}

private struct WidgetProgress: Decodable {
  let completedCount: Int
  let totalCount: Int
  let flags: [Bool]
  let countLabel: String
  let statusMessage: String
}

private struct WidgetPrayer: Decodable {
  let id: String
  let label: String
  let timeLabel: String
  let isoTime: String
}

private struct DeenlyWidgetEntry: TimelineEntry {
  let date: Date
  let payload: WidgetPayloadEntry
  let ui: WidgetUiStrings?

  static let placeholder = DeenlyWidgetEntry(
    date: Date(),
    payload: WidgetPayloadEntry(
      timestamp: "2026-03-28T08:20:00",
      dayKey: "2026-03-28",
      dateLabel: "Sat, Mar 28",
      timeLabel: "8:20 AM",
      isDarkMode: false,
      verse: WidgetVerse(
        text: "Indeed, with hardship comes ease.",
        source: "Ash-Sharh 94:6"
      ),
      progress: WidgetProgress(
        completedCount: 3,
        totalCount: 5,
        flags: [true, true, true, false, false],
        countLabel: "3 of 5",
        statusMessage: "Keep going — 2 prayers left today"
      ),
      prayers: [
        WidgetPrayer(id: "fajr", label: "Fajr", timeLabel: "5:12 AM", isoTime: "2026-03-28T05:12:00"),
        WidgetPrayer(id: "sunrise", label: "Sunrise", timeLabel: "6:28 AM", isoTime: "2026-03-28T06:28:00"),
        WidgetPrayer(id: "dhuhr", label: "Dhuhr", timeLabel: "12:19 PM", isoTime: "2026-03-28T12:19:00"),
        WidgetPrayer(id: "asr", label: "Asr", timeLabel: "4:41 PM", isoTime: "2026-03-28T16:41:00"),
        WidgetPrayer(id: "maghrib", label: "Maghrib", timeLabel: "6:31 PM", isoTime: "2026-03-28T18:31:00"),
        WidgetPrayer(id: "isha", label: "Isha", timeLabel: "7:46 PM", isoTime: "2026-03-28T19:46:00"),
      ]
    ),
    ui: nil
  )
}

private struct DeenlyProvider: TimelineProvider {
  func placeholder(in context: Context) -> DeenlyWidgetEntry {
    .placeholder
  }

  func getSnapshot(in context: Context, completion: @escaping (DeenlyWidgetEntry) -> Void) {
    completion(loadCurrentEntry(for: Date()) ?? .placeholder)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<DeenlyWidgetEntry>) -> Void) {
    let entries = loadTimelineEntries()
    guard !entries.isEmpty else {
      completion(
        Timeline(
          entries: [.placeholder],
          policy: .after(Calendar.current.startOfDay(for: Date()).addingTimeInterval(86400))
        )
      )
      return
    }

    let now = Date()
    let currentEntry = loadCurrentEntry(for: now) ?? entries.first!
    let futureEntries = entries.filter { $0.date > now }
    let timelineEntries = [currentEntry] + futureEntries
    let nextRefresh = Calendar.current.startOfDay(for: now).addingTimeInterval(86400)
    completion(Timeline(entries: timelineEntries, policy: .after(nextRefresh)))
  }

  private func loadCurrentEntry(for date: Date) -> DeenlyWidgetEntry? {
    let entries = loadTimelineEntries()
    return entries.last(where: { $0.date <= date }) ?? entries.first
  }

  private func loadTimelineEntries() -> [DeenlyWidgetEntry] {
    let defaults = UserDefaults(suiteName: widgetAppGroup)
    guard
      let raw = defaults?.string(forKey: "widget_timeline_json"),
      let data = raw.data(using: .utf8),
      let timeline = try? JSONDecoder().decode(WidgetTimelinePayload.self, from: data)
    else {
      return []
    }

    return timeline.entries.flatMap { payloadEntry -> [DeenlyWidgetEntry] in
      let date = WidgetDateParser.parse(payloadEntry.timestamp)
      guard let date else { return [] }
      var entries = [DeenlyWidgetEntry(date: date, payload: payloadEntry, ui: timeline.ui)]
      let prayerTransitions = payloadEntry.prayers.compactMap {
        WidgetDateParser.parse($0.isoTime)
      }
      entries.append(
        contentsOf: prayerTransitions.map {
          DeenlyWidgetEntry(date: $0, payload: payloadEntry, ui: timeline.ui)
        }
      )
      return entries
    }
    .sorted(by: { $0.date < $1.date })
  }
}

private struct DeenlyWidgetView: View {
  @Environment(\.widgetFamily) private var family
  let entry: DeenlyWidgetEntry
  private let fontScale: CGFloat = 1.25
  private var palette: WidgetPalette {
    // Keep the DeenFocus green surface for every size in light and dark mode.
    // The previous dark gradient rendered nearly black on the home screen.
    .light
  }

  private var prayersForHighlightNoSunrise: [WidgetPrayer] {
    entry.payload.prayers.filter { $0.id != "sunrise" }
  }

  /// iOS 17+ adds large default widget content margins; we disable those on the configuration
  /// and keep a modest horizontal inset (~7.5% of width, within the 5–10% range).
  private var horizontalContentInsetRatio: CGFloat { 0.075 }

  var body: some View {
    GeometryReader { geo in
      let horizontalInset = geo.size.width * horizontalContentInsetRatio
      TimelineView(.periodic(from: Date(), by: 60)) { timeline in
        Group {
          switch family {
          case .systemSmall:
            smallBody(now: timeline.date)
          case .systemMedium:
            mediumBody(now: timeline.date)
          default:
            largeBody(now: timeline.date)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, horizontalInset)
        .modifier(WidgetBackgroundModifier(background: palette.background))
      }
    }
  }

  private func smallBody(now: Date) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      header(fontSize: 9 * fontScale, dateSize: 8 * fontScale)
      Divider().overlay(Color.white.opacity(0.16))
      smallPrayerGrid(prayers: visiblePrayers(limit: 5), now: now)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }

  private func mediumBody(now: Date) -> some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(alignment: .top) {
        Text(entry.ui?.dailyVerseTitle ?? "Daily Verse")
          .font(.system(size: 11 * fontScale, weight: .bold, design: .rounded))
          .foregroundColor(palette.foreground)
        Spacer(minLength: 8)
        VStack(alignment: .trailing, spacing: 2) {
          Text(entry.ui?.brandName ?? "Deen Focus")
            .font(.system(size: 13 * fontScale, weight: .bold, design: .rounded))
            .foregroundColor(palette.foreground)
          Text(entry.payload.dateLabel)
            .font(.system(size: 10 * fontScale, weight: .regular, design: .rounded))
            .foregroundColor(palette.foreground.opacity(0.86))
        }
      }
      Divider().overlay(Color.white.opacity(0.2))
      Text(
        entry.payload.verse?.text
          ?? entry.ui?.timelinePlaceholder
          ?? "Open Deen Focus to prepare your daily verse and prayer widget data."
      )
        .font(.system(size: 13 * fontScale, weight: .semibold, design: .rounded))
        .foregroundColor(palette.foreground)
        .lineLimit(2)
        .minimumScaleFactor(0.85)
        .frame(maxWidth: .infinity, alignment: .topLeading)
      if let source = entry.payload.verse?.source, !source.isEmpty {
        Text(source)
          .font(.system(size: 9 * fontScale, weight: .regular, design: .rounded))
          .foregroundColor(palette.foreground.opacity(0.86))
      }
      prayerRows(
        prayers: visiblePrayers(limit: 5),
        columns: 5,
        showVerse: false,
        now: now,
        highlightSource: prayersForHighlightNoSunrise,
        cellPalette: palette
      )
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .padding(.vertical, 8)
  }

  private func largeBody(now: Date) -> some View {
    let progress = entry.payload.progress
    return VStack(alignment: .leading, spacing: 10) {
      HStack(spacing: 8) {
        ZStack {
          Circle().fill(Color.white.opacity(0.18))
          Image(systemName: "moon.stars.fill")
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.white)
        }
        .frame(width: 28, height: 28)
        Text(entry.ui?.brandName ?? "Deen Focus")
          .font(.system(size: 15 * fontScale, weight: .bold, design: .rounded))
          .foregroundColor(palette.foreground)
        Spacer()
        Text(entry.payload.dateLabel)
          .font(.system(size: 12 * fontScale, weight: .regular, design: .rounded))
          .foregroundColor(palette.foreground.opacity(0.86))
      }

      VStack(spacing: 4) {
        Text(entry.ui?.prayerProgressTitle ?? "Your Prayer Progress")
          .font(.system(size: 13 * fontScale, weight: .semibold, design: .rounded))
          .foregroundColor(palette.foreground)
        Text(progress?.countLabel ?? entry.ui?.defaultProgressCountLabel ?? "0 of 5")
          .font(.system(size: 28 * fontScale, weight: .bold, design: .rounded))
          .foregroundColor(palette.foreground)
        Text(entry.ui?.prayersCompletedSubtitle ?? "prayers completed.")
          .font(.system(size: 12 * fontScale, weight: .regular, design: .rounded))
          .foregroundColor(palette.foreground.opacity(0.86))
      }
      .frame(maxWidth: .infinity)

      HStack(spacing: 12) {
        ForEach(0..<5, id: \.self) { index in
          let done = (progress?.flags.indices.contains(index) == true)
            ? (progress?.flags[index] ?? false)
            : false
          ZStack {
            Circle()
              .fill(done ? Color.white.opacity(0.92) : Color.clear)
              .overlay(
                Circle().stroke(Color.white.opacity(0.55), lineWidth: 2)
              )
            if done {
              Image(systemName: "checkmark")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color(red: 0.24, green: 0.51, blue: 0.41))
            }
          }
          .frame(width: 22, height: 22)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.top, 2)

      Text(progress?.statusMessage ?? "Keep going")
        .font(.system(size: 11 * fontScale, weight: .semibold, design: .rounded))
        .foregroundColor(palette.foreground)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color.white.opacity(0.16)))

      prayerRows(
        prayers: visiblePrayers(limit: 5),
        columns: 5,
        showVerse: false,
        now: now,
        highlightSource: prayersForHighlightNoSunrise,
        cellPalette: palette
      )
      .padding(10)
      .background(
        RoundedRectangle(cornerRadius: 14, style: .continuous)
          .fill(Color.white.opacity(0.12))
      )
    }
    .padding(.vertical, 10)
  }

  private func header(fontSize: CGFloat, dateSize: CGFloat) -> some View {
    HStack {
      Spacer()
      VStack(alignment: .trailing, spacing: 2) {
        Text(entry.ui?.brandName ?? "Deen Focus")
          .font(.system(size: fontSize, weight: .bold, design: .rounded))
          .foregroundColor(palette.foreground)
        Text(entry.payload.dateLabel)
          .font(.system(size: dateSize, weight: .regular, design: .rounded))
          .foregroundColor(palette.foreground.opacity(0.86))
      }
    }
  }

  private func prayerRows(
    prayers: [WidgetPrayer],
    columns: Int,
    showVerse: Bool,
    now: Date,
    highlightSource: [WidgetPrayer],
    cellPalette: WidgetPalette? = nil
  ) -> some View {
    let rows = stride(from: 0, to: prayers.count, by: columns).map {
      Array(prayers[$0..<min($0 + columns, prayers.count)])
    }
    let currentPrayerId = findCurrentPrayerId(prayers: highlightSource, now: now)
    let resolvedPalette = cellPalette ?? palette

    let rowSpacing: CGFloat = {
      if showVerse { return 4 }
      if family == .systemMedium { return 4 }
      return 3
    }()
    return VStack(spacing: rowSpacing) {
      ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
        HStack(spacing: family == .systemLarge ? 4 : 2) {
          ForEach(row, id: \.id) { prayer in
            PrayerCell(
              prayer: prayer,
              isHighlighted: prayer.id == currentPrayerId,
              palette: resolvedPalette,
              family: family,
              fontScale: fontScale
            )
          }
          if row.count < columns {
            ForEach(0..<(columns - row.count), id: \.self) { _ in
              Color.clear.frame(maxWidth: .infinity)
            }
          }
        }
      }
    }
  }

  /// Small widgets are ~155pt tall; keep five prayers in two rows and let the rows
  /// share the remaining height so the widget does not look top-heavy.
  @ViewBuilder
  private func smallPrayerGrid(prayers: [WidgetPrayer], now: Date) -> some View {
    let currentPrayerId = findCurrentPrayerId(prayers: prayersForHighlightNoSunrise, now: now)
    if prayers.count >= 5 {
      VStack(spacing: 3) {
        smallPrayerRow(Array(prayers.prefix(3)), currentPrayerId: currentPrayerId)
        smallPrayerRow(Array(prayers.dropFirst(3).prefix(2)), currentPrayerId: currentPrayerId)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    } else {
      prayerRows(
        prayers: prayers,
        columns: 2,
        showVerse: false,
        now: now,
        highlightSource: prayersForHighlightNoSunrise
      )
    }
  }

  private func smallPrayerRow(_ prayers: [WidgetPrayer], currentPrayerId: String?) -> some View {
    HStack(spacing: 2) {
      ForEach(prayers, id: \.id) { prayer in
        PrayerCell(
          prayer: prayer,
          isHighlighted: prayer.id == currentPrayerId,
          palette: palette,
          family: family,
          fontScale: fontScale
        )
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func visiblePrayers(limit: Int) -> [WidgetPrayer] {
    let prayers = limit == 6
      ? entry.payload.prayers
      : entry.payload.prayers.filter { $0.id != "sunrise" }
    return Array(prayers.prefix(limit))
  }

  private func findCurrentPrayerId(prayers: [WidgetPrayer], now: Date) -> String? {
    let parsed = prayers
      .compactMap { prayer -> (WidgetPrayer, Date)? in
        guard let start = WidgetDateParser.parse(prayer.isoTime) else { return nil }
        return (prayer, start)
      }
      .sorted { $0.1 < $1.1 }
    guard !parsed.isEmpty else { return nil }
    return parsed.last(where: { $0.1 <= now })?.0.id ?? parsed.last?.0.id
  }
}

private struct PrayerCell: View {
  let prayer: WidgetPrayer
  let isHighlighted: Bool
  let palette: WidgetPalette
  let family: WidgetFamily
  let fontScale: CGFloat

  private var isSmall: Bool { family == .systemSmall }
  private var isMedium: Bool { family == .systemMedium }
  private var isLarge: Bool { family == .systemLarge }

  private var titleSize: CGFloat {
    if isSmall { return 8.5 * fontScale * 0.9 }
    if isMedium { return 10 * fontScale * 0.9 }
    return 10 * fontScale
  }

  private var timeSize: CGFloat {
    if isSmall { return 7.5 * fontScale * 0.9 }
    if isMedium { return 9 * fontScale * 0.9 }
    return 9 * fontScale
  }

  private var iconHeight: CGFloat {
    if isSmall { return 10 }
    if isMedium { return 12 }
    return 12
  }

  private var verticalPadding: CGFloat {
    if isSmall { return 2 }
    if isMedium { return 3 }
    return 6
  }

  private var cellStackSpacing: CGFloat {
    if isSmall { return 1 }
    if isMedium { return 2 }
    return 3
  }

  var body: some View {
    VStack(spacing: cellStackSpacing) {
      Text(prayer.label)
        .font(.system(size: titleSize, weight: .bold, design: .rounded))
        .lineLimit(1)
        .minimumScaleFactor(0.6)
      prayerIcon
      Text(prayer.timeLabel)
        .font(.system(size: timeSize, weight: .regular, design: .rounded))
        .lineLimit(1)
        .minimumScaleFactor(0.65)
        .multilineTextAlignment(.center)
    }
    .foregroundColor(palette.foreground)
    .frame(maxWidth: .infinity, minHeight: 0)
    .padding(.vertical, verticalPadding)
    .padding(.horizontal, isLarge ? 2 : 0.5)
    .frame(maxWidth: .infinity, maxHeight: isSmall ? CGFloat.infinity : nil)
    .background(
      RoundedRectangle(cornerRadius: 12.8, style: .continuous)
        .fill(isHighlighted ? Color.white.opacity(0.14) : Color.clear)
        .overlay(
          RoundedRectangle(cornerRadius: 12.8, style: .continuous)
            .stroke(
              isHighlighted ? Color.white.opacity(0.16) : Color.clear,
              lineWidth: 1
            )
        )
    )
  }

  @ViewBuilder
  private var prayerIcon: some View {
    if let image = bundledPrayerImage {
      Image(uiImage: image)
        .resizable()
        .renderingMode(.original)
        .scaledToFit()
        .frame(height: iconHeight)
    } else {
      Image(systemName: "sunrise.fill")
        .font(.system(size: iconHeight, weight: .semibold))
    }
  }

  private var bundledPrayerImage: UIImage? {
    guard let assetName else { return nil }
    return UIImage(named: assetName, in: Bundle.main, compatibleWith: nil)
  }

  private var assetName: String? {
    switch prayer.id {
    case "fajr":
      return "fajr"
    case "sunrise":
      return nil
    case "dhuhr":
      return "dhuhr"
    case "asr":
      return "asar"
    case "maghrib":
      return "maghrib"
    case "isha":
      return "isha"
    default:
      return nil
    }
  }
}

private struct WidgetPalette {
  let background: LinearGradient
  let foreground: Color

  static let light = WidgetPalette(
    background: LinearGradient(
      colors: [
        Color(red: 0.36, green: 0.64, blue: 0.54),
        Color(red: 0.24, green: 0.51, blue: 0.41),
      ],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    ),
    foreground: .white
  )

  static let dark = WidgetPalette(
    background: LinearGradient(
      colors: [
        Color(red: 0.18, green: 0.42, blue: 0.32),
        Color(red: 0.09, green: 0.17, blue: 0.13),
      ],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    ),
    foreground: .white
  )
}

private struct WidgetBackgroundModifier: ViewModifier {
  let background: LinearGradient

  func body(content: Content) -> some View {
    if #available(iOS 17.0, *) {
      content.containerBackground(for: .widget) {
        background
      }
    } else {
      content
        .background(background)
    }
  }
}

struct DeenlyWidgets: Widget {
  let kind = "DeenlyWidgets"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: DeenlyProvider()) { entry in
      DeenlyWidgetView(entry: entry)
    }
    .configurationDisplayName("Deen Focus — Prayer")
    .description("Prayer progress, daily verse, and prayer times. Open the app once to refresh language and content.")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    .contentMarginsDisabled()
  }
}

@main
struct DeenlyWidgetsBundle: WidgetBundle {
  var body: some Widget {
    DeenlyWidgets()
    if #available(iOS 16.2, *) {
      PrayerLiveActivityWidget()
    }
  }
}
