import SwiftUI
import WidgetKit

private let widgetAppGroup = "group.com.rnr.deenfocus.widgets"

private struct WidgetTimelinePayload: Decodable {
  let entries: [WidgetPayloadEntry]
}

private struct WidgetPayloadEntry: Decodable {
  let dayKey: String
  let dateLabel: String
  let isDarkMode: Bool
  let verse: WidgetVerse?
  let prayers: [WidgetPrayer]
}

private struct WidgetVerse: Decodable {
  let text: String
  let source: String
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

  static let placeholder = DeenlyWidgetEntry(
    date: Date(),
    payload: WidgetPayloadEntry(
      dayKey: "2026-03-28",
      dateLabel: "Sat, Mar 28",
      isDarkMode: false,
      verse: WidgetVerse(
        text: "Indeed, with hardship comes ease.",
        source: "Ash-Sharh 94:6"
      ),
      prayers: [
        WidgetPrayer(id: "fajr", label: "Fajr", timeLabel: "5:12 AM", isoTime: "2026-03-28T05:12:00"),
        WidgetPrayer(id: "sunrise", label: "Sunrise", timeLabel: "6:28 AM", isoTime: "2026-03-28T06:28:00"),
        WidgetPrayer(id: "dhuhr", label: "Dhuhr", timeLabel: "12:19 PM", isoTime: "2026-03-28T12:19:00"),
        WidgetPrayer(id: "asr", label: "Asr", timeLabel: "4:41 PM", isoTime: "2026-03-28T16:41:00"),
        WidgetPrayer(id: "maghrib", label: "Maghrib", timeLabel: "6:31 PM", isoTime: "2026-03-28T18:31:00"),
        WidgetPrayer(id: "isha", label: "Isha", timeLabel: "7:46 PM", isoTime: "2026-03-28T19:46:00"),
      ]
    )
  )
}

private struct DeenlyProvider: TimelineProvider {
  func placeholder(in context: Context) -> DeenlyWidgetEntry {
    .placeholder
  }

  func getSnapshot(in context: Context, completion: @escaping (DeenlyWidgetEntry) -> Void) {
    completion(loadEntry(for: Date()) ?? .placeholder)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<DeenlyWidgetEntry>) -> Void) {
    let calendar = Calendar.current
    let startOfToday = calendar.startOfDay(for: Date())
    let entries = (0..<7).map { dayOffset -> DeenlyWidgetEntry in
      let day = calendar.date(byAdding: .day, value: dayOffset, to: startOfToday) ?? startOfToday
      return loadEntry(for: day) ?? .placeholder
    }
    let nextRefresh = calendar.date(byAdding: .day, value: 1, to: startOfToday) ?? Date().addingTimeInterval(86400)
    completion(Timeline(entries: entries, policy: .after(nextRefresh)))
  }

  private func loadEntry(for date: Date) -> DeenlyWidgetEntry? {
    let defaults = UserDefaults(suiteName: widgetAppGroup)
    guard
      let raw = defaults?.string(forKey: "widget_timeline_json"),
      let data = raw.data(using: .utf8),
      let payload = try? JSONDecoder().decode(WidgetTimelinePayload.self, from: data)
    else {
      return nil
    }

    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    let dayKey = formatter.string(from: date)
    let selected = payload.entries.first(where: { $0.dayKey == dayKey }) ?? payload.entries.first
    guard let selected else { return nil }
    return DeenlyWidgetEntry(date: date, payload: selected)
  }
}

private struct DeenlyWidgetView: View {
  @Environment(\.widgetFamily) private var family
  let entry: DeenlyWidgetEntry

  private var palette: WidgetPalette {
    entry.payload.isDarkMode ? .dark : .light
  }

  var body: some View {
    Group {
      switch family {
      case .systemSmall:
        smallBody
      case .systemMedium:
        mediumBody
      default:
        largeBody
      }
    }
    .modifier(WidgetBackgroundModifier(background: palette.background))
  }

  private var smallBody: some View {
    VStack(alignment: .leading, spacing: 8) {
      header(fontSize: 10, dateSize: 9)
      Divider().overlay(Color.white.opacity(0.16))
      prayerRows(prayers: visiblePrayers(limit: 5), columns: 2, showVerse: false)
    }
    .padding(12)
  }

  private var mediumBody: some View {
    VStack(alignment: .leading, spacing: 8) {
      header(fontSize: 16, dateSize: 12)
      Divider().overlay(Color.white.opacity(0.16))
      prayerRows(prayers: visiblePrayers(limit: 6), columns: 3, showVerse: false)
    }
    .padding(14)
  }

  private var largeBody: some View {
    VStack(alignment: .leading, spacing: 10) {
      header(fontSize: 16, dateSize: 12)
      Divider().overlay(Color.white.opacity(0.16))
      Text("Daily Verse")
        .font(.system(size: 12, weight: .medium, design: .rounded))
        .foregroundColor(palette.foreground.opacity(0.9))
      Text(entry.payload.verse?.text ?? "Open Deenly to prepare your daily verse and prayer widget data.")
        .font(.system(size: 15, weight: .bold, design: .rounded))
        .foregroundColor(palette.foreground)
        .lineLimit(5)
      if let source = entry.payload.verse?.source, !source.isEmpty {
        Text(source)
          .font(.system(size: 12, weight: .regular, design: .rounded))
          .foregroundColor(palette.foreground.opacity(0.86))
      }
      Spacer(minLength: 8)
      prayerRows(prayers: visiblePrayers(limit: 5), columns: 5, showVerse: true)
    }
    .padding(16)
  }

  private func header(fontSize: CGFloat, dateSize: CGFloat) -> some View {
    HStack {
      Spacer()
      VStack(alignment: .trailing, spacing: 2) {
        Text("Deenly")
          .font(.system(size: fontSize, weight: .bold, design: .rounded))
          .foregroundColor(palette.foreground)
        Text(entry.payload.dateLabel)
          .font(.system(size: dateSize, weight: .regular, design: .rounded))
          .foregroundColor(palette.foreground.opacity(0.86))
      }
    }
  }

  private func prayerRows(prayers: [WidgetPrayer], columns: Int, showVerse: Bool) -> some View {
    let rows = stride(from: 0, to: prayers.count, by: columns).map {
      Array(prayers[$0..<min($0 + columns, prayers.count)])
    }
    let nextPrayerId = findNextPrayerId(prayers: entry.payload.prayers)

    return VStack(spacing: showVerse ? 0 : 8) {
      ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
        HStack(spacing: 8) {
          ForEach(row, id: \.id) { prayer in
            PrayerCell(
              prayer: prayer,
              isHighlighted: prayer.id == nextPrayerId,
              palette: palette,
              compact: family == .systemSmall
            )
          }
        }
      }
    }
  }

  private func visiblePrayers(limit: Int) -> [WidgetPrayer] {
    let prayers = limit == 6
      ? entry.payload.prayers
      : entry.payload.prayers.filter { $0.id != "sunrise" }
    return Array(prayers.prefix(limit))
  }

  private func findNextPrayerId(prayers: [WidgetPrayer]) -> String? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    let fallbackFormatter = ISO8601DateFormatter()
    fallbackFormatter.formatOptions = [.withInternetDateTime]
    let now = Date()

    return prayers.first(where: { prayer in
      if let date = formatter.date(from: prayer.isoTime) ?? fallbackFormatter.date(from: prayer.isoTime) {
        return date > now
      }
      let dateString = prayer.isoTime.replacingOccurrences(of: "T", with: " ")
      let parser = DateFormatter()
      parser.locale = Locale(identifier: "en_US_POSIX")
      parser.dateFormat = "yyyy-MM-dd HH:mm:ss"
      return (parser.date(from: dateString) ?? .distantPast) > now
    })?.id
  }
}

private struct PrayerCell: View {
  let prayer: WidgetPrayer
  let isHighlighted: Bool
  let palette: WidgetPalette
  let compact: Bool

  var body: some View {
    VStack(spacing: compact ? 3 : 4) {
      Text(prayer.label)
        .font(.system(size: compact ? 11 : 13, weight: .bold, design: .rounded))
      Image(systemName: iconName)
        .font(.system(size: compact ? 12 : 14, weight: .semibold))
      Text(prayer.timeLabel)
        .font(.system(size: compact ? 10 : 11, weight: .regular, design: .rounded))
        .multilineTextAlignment(.center)
    }
    .foregroundColor(palette.foreground)
    .frame(maxWidth: .infinity)
    .padding(.vertical, compact ? 6 : 8)
    .padding(.horizontal, 4)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(isHighlighted ? Color.white.opacity(0.14) : Color.clear)
        .overlay(
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(Color.white.opacity(isHighlighted ? 0.16 : 0), lineWidth: 1)
        )
    )
  }

  private var iconName: String {
    switch prayer.id {
    case "sunrise":
      return "sunrise.fill"
    case "maghrib":
      return "sunset.fill"
    case "isha":
      return "moon.stars.fill"
    default:
      return "clock.fill"
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
    .configurationDisplayName("Deenly Prayer Widget")
    .description("Prayer times and the daily verse in small, medium, and large sizes.")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}

@main
struct DeenlyWidgetsBundle: WidgetBundle {
  var body: some Widget {
    DeenlyWidgets()
  }
}
