import ActivityKit
import Foundation

/// One salah row stored in Live Activity state so the UI can pick current/next
/// from `Date()` when iOS snapshots the lock screen.
@available(iOS 16.2, *)
public struct PrayerLiveActivitySlot: Codable, Hashable {
  public var id: String
  public var label: String
  public var timeLabel: String
  public var time: Date

  public init(id: String, label: String, timeLabel: String, time: Date) {
    self.id = id
    self.label = label
    self.timeLabel = timeLabel
    self.time = time
  }
}

/// Resolved lock-screen copy for a point in time.
@available(iOS 16.2, *)
public struct PrayerLiveActivityPresentation: Equatable {
  public var phaseLabel: String
  public var currentPrayerLabel: String
  public var currentPrayerTimeLabel: String
  public var nextPrayerLine: String
  public var prayerProgress: Double
  public var nextPrayerDate: Date?

  public static func resolve(
    state: PrayerLiveActivityAttributes.ContentState,
    at now: Date
  ) -> PrayerLiveActivityPresentation {
    let timeline = timelineSlots(from: state)
    if timeline.isEmpty {
      return PrayerLiveActivityPresentation(
        phaseLabel: state.nowLabel,
        currentPrayerLabel: state.currentPrayerLabel,
        currentPrayerTimeLabel: state.currentPrayerTimeLabel,
        nextPrayerLine: state.nextPrayerLine,
        prayerProgress: state.prayerProgress,
        nextPrayerDate: nil
      )
    }

    let current = timeline.last { !$0.time.isAfter(now) }
    let next = timeline.first { $0.time.isAfter(now) }
    let beforeFirst = current == nil
    let featured = current ?? next ?? timeline[0]
    let phaseLabel: String
    if beforeFirst {
      phaseLabel = state.upNextLabel.isEmpty ? state.nowLabel : state.upNextLabel
    } else {
      phaseLabel = state.nowLabel
    }

    let nextLine: String
    if beforeFirst {
      nextLine = ""
    } else if let next {
      nextLine = formattedNextLine(
        template: state.nextPrayerLineTemplate,
        prayer: next.label,
        time: next.timeLabel
      )
    } else {
      nextLine = ""
    }

    return PrayerLiveActivityPresentation(
      phaseLabel: phaseLabel,
      currentPrayerLabel: featured.label,
      currentPrayerTimeLabel: featured.timeLabel,
      nextPrayerLine: nextLine,
      prayerProgress: progress(for: featured, state: state),
      nextPrayerDate: beforeFirst ? featured.time : next?.time
    )
  }

  public static func transitionDates(
    from state: PrayerLiveActivityAttributes.ContentState
  ) -> [Date] {
    timelineSlots(from: state).map(\.time).sorted()
  }

  private static func timelineSlots(
    from state: PrayerLiveActivityAttributes.ContentState
  ) -> [PrayerLiveActivitySlot] {
    var slots = state.prayers
    if let fajr = state.tomorrowFajr,
       !slots.contains(where: { abs($0.time.timeIntervalSince(fajr.time)) < 60 }) {
      slots.append(fajr)
    }
    return slots.sorted { $0.time < $1.time }
  }

  private static func progress(
    for featured: PrayerLiveActivitySlot,
    state: PrayerLiveActivityAttributes.ContentState
  ) -> Double {
    if let tomorrow = state.tomorrowFajr,
       abs(featured.time.timeIntervalSince(tomorrow.time)) < 60 {
      return 0
    }
    let prayers = state.prayers
    guard !prayers.isEmpty else { return state.prayerProgress }
    let index = prayers.firstIndex {
      abs($0.time.timeIntervalSince(featured.time)) < 60
    } ?? 0
    return Double(index) / Double(max(prayers.count - 1, 1))
  }

  private static func formattedNextLine(
    template: String,
    prayer: String,
    time: String
  ) -> String {
    if template.contains("{prayer}") || template.contains("{time}") {
      return template
        .replacingOccurrences(of: "{prayer}", with: prayer)
        .replacingOccurrences(of: "{time}", with: time)
    }
    if template.isEmpty {
      return "\(prayer) \(time)"
    }
    return template
  }
}

/// Shared ActivityKit attributes for Prayer Live Activity (Runner + Widget extension).
@available(iOS 16.2, *)
public struct PrayerLiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
      case currentPrayerId
      case currentPrayerLabel
      case currentPrayerTimeLabel
      case nextPrayerLine
      case locationName
      case updatedAtLabel
      case nowLabel
      case upNextLabel
      case nextPrayerLineTemplate
      case prayerProgress
      case prayers
      case tomorrowFajr
    }

    public var currentPrayerId: String
    public var currentPrayerLabel: String
    public var currentPrayerTimeLabel: String
    public var nextPrayerLine: String
    public var locationName: String
    public var updatedAtLabel: String
    public var nowLabel: String
    public var upNextLabel: String
    public var nextPrayerLineTemplate: String
    public var prayerProgress: Double
    public var prayers: [PrayerLiveActivitySlot]
    public var tomorrowFajr: PrayerLiveActivitySlot?

    public init(
      currentPrayerId: String,
      currentPrayerLabel: String,
      currentPrayerTimeLabel: String,
      nextPrayerLine: String,
      locationName: String,
      updatedAtLabel: String,
      nowLabel: String,
      upNextLabel: String = "",
      nextPrayerLineTemplate: String = "",
      prayerProgress: Double,
      prayers: [PrayerLiveActivitySlot] = [],
      tomorrowFajr: PrayerLiveActivitySlot? = nil
    ) {
      self.currentPrayerId = currentPrayerId
      self.currentPrayerLabel = currentPrayerLabel
      self.currentPrayerTimeLabel = currentPrayerTimeLabel
      self.nextPrayerLine = nextPrayerLine
      self.locationName = locationName
      self.updatedAtLabel = updatedAtLabel
      self.nowLabel = nowLabel
      self.upNextLabel = upNextLabel
      self.nextPrayerLineTemplate = nextPrayerLineTemplate
      self.prayerProgress = prayerProgress
      self.prayers = prayers
      self.tomorrowFajr = tomorrowFajr
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      currentPrayerId = try container.decodeIfPresent(String.self, forKey: .currentPrayerId) ?? ""
      currentPrayerLabel = try container.decodeIfPresent(String.self, forKey: .currentPrayerLabel) ?? ""
      currentPrayerTimeLabel = try container.decodeIfPresent(String.self, forKey: .currentPrayerTimeLabel) ?? ""
      nextPrayerLine = try container.decodeIfPresent(String.self, forKey: .nextPrayerLine) ?? ""
      locationName = try container.decodeIfPresent(String.self, forKey: .locationName) ?? ""
      updatedAtLabel = try container.decodeIfPresent(String.self, forKey: .updatedAtLabel) ?? ""
      nowLabel = try container.decodeIfPresent(String.self, forKey: .nowLabel) ?? "Now"
      upNextLabel = try container.decodeIfPresent(String.self, forKey: .upNextLabel) ?? ""
      nextPrayerLineTemplate = try container.decodeIfPresent(String.self, forKey: .nextPrayerLineTemplate) ?? ""
      prayerProgress = try container.decodeIfPresent(Double.self, forKey: .prayerProgress) ?? 0
      prayers = try container.decodeIfPresent([PrayerLiveActivitySlot].self, forKey: .prayers) ?? []
      tomorrowFajr = try container.decodeIfPresent(PrayerLiveActivitySlot.self, forKey: .tomorrowFajr)
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(currentPrayerId, forKey: .currentPrayerId)
      try container.encode(currentPrayerLabel, forKey: .currentPrayerLabel)
      try container.encode(currentPrayerTimeLabel, forKey: .currentPrayerTimeLabel)
      try container.encode(nextPrayerLine, forKey: .nextPrayerLine)
      try container.encode(locationName, forKey: .locationName)
      try container.encode(updatedAtLabel, forKey: .updatedAtLabel)
      try container.encode(nowLabel, forKey: .nowLabel)
      try container.encode(upNextLabel, forKey: .upNextLabel)
      try container.encode(nextPrayerLineTemplate, forKey: .nextPrayerLineTemplate)
      try container.encode(prayerProgress, forKey: .prayerProgress)
      try container.encode(prayers, forKey: .prayers)
      try container.encodeIfPresent(tomorrowFajr, forKey: .tomorrowFajr)
    }
  }

  public var brandName: String

  public init(brandName: String) {
    self.brandName = brandName
  }
}
