import WolfDateTime

/// https://schema.org/OpeningHoursSpecification
public struct OpenHours: Codable {
    public var hours: LocalTimeSpan?
    public var daysOfWeek: Set<DayOfWeek>? // https://schema.org/dayOfWeek
    public var dates: LocalDateSpan?

    public init(hours: LocalTimeSpan? = nil, daysOfWeek: Set<DayOfWeek>? = nil, dates: LocalDateSpan? = nil) {
        self.hours = hours
        if daysOfWeek == DayOfWeek.everyDay {
            self.daysOfWeek = nil
        } else {
            self.daysOfWeek = daysOfWeek
        }
        self.dates = dates
    }
}

extension OpenHours: Equatable {
    public static func == (lhs: OpenHours, rhs: OpenHours) -> Bool {
        return lhs.hours == rhs.hours && lhs.daysOfWeek == rhs.daysOfWeek && lhs.dates == rhs.dates
    }
}

extension OpenHours {
    public func isValid(on date: LocalDate) -> Bool {
        if let validFrom = dates?.start {
            guard date >= validFrom else { return false }
        }
        if let validThrough = dates?.end {
            guard date <= validThrough else { return false }
        }
        if let daysOfWeek = daysOfWeek {
            guard daysOfWeek.contains(date.dayOfWeek) else { return false }
        }
        return true
    }

    public func opensUTCDateTime(on date: LocalDate, in timeZone: WolfDateTime.TimeZone) -> UTCDateTime? {
        return hours?.start.toUTCDateTime(on: date, in: timeZone)
    }

    public func closesUTCDateTime(on date: LocalDate, in timeZone: WolfDateTime.TimeZone) -> UTCDateTime? {
        guard let opens = hours?.start, let closes = hours?.end else { return nil }
        let closingDate: LocalDate
        if closes <= opens {
            // closes the next day
            closingDate = date.adding(days: 1)
        } else {
            // closes the same day
            closingDate = date
        }
        return closes.toUTCDateTime(on: closingDate, in: timeZone)
    }

    public func openSpan(on date: LocalDate, in timeZone: WolfDateTime.TimeZone) -> TimeSpan? {
        guard let start = opensUTCDateTime(on: date, in: timeZone),
            let end = closesUTCDateTime(on: date, in: timeZone) else { return nil }
        return try! TimeSpan(start: start, end: end)
    }
}
