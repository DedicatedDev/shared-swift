import WolfDateTime

public protocol HasOpenHours {
    var openHours: [OpenHours]? { get }
}

extension HasOpenHours {
    public func openStatus(for date: UTCDateTime, in timeZone: WolfDateTime.TimeZone) -> OpenStatus {
        // If there are no specs, then it's always open
        guard let openHours = openHours else {
            return .alwaysOpen
        }

        // Since we have specs, after this point we won't return `nil`.

        // If we have specs, but they're empty, then it's always open.
        if openHours.isEmpty {
            return .openNow
        }

        // If there no valid OpenHours for this date, then it's closed.
        let localDate = LocalDate(utcDateTime: date, in: timeZone)
        guard let validSpec = effectiveOpenHours(on: localDate) else {
            return .closed
        }

        // If there is no more specific open hours for today, then it's just "open today".
        guard let span = validSpec.openSpan(on: localDate, in: timeZone) else {
            return .openAllDay
        }

        // We now know that it is open for specific hours today.

        // If this span says we're not closed, then we're done.
        let status = span.openStatus(for: date)
        guard status == .closed else { return status }

        // It might still be open from the previous day.
        let previousDate = localDate.adding(days: -1)
        if let span = validSpec.openSpan(on: previousDate, in: timeZone) {
            return span.openStatus(for: date)
        } else {
            return .closed
        }
    }

    public func effectiveOpenHours(on date: LocalDate) -> OpenHours? {
        let specs: [OpenHours] = openHours ?? []
        let validSpecs = specs.filter { $0.isValid(on: date) }
        guard !validSpecs.isEmpty else { return nil }
        return validSpecs.last!
    }
}

extension HasOpenHours {
    public func openSpan(on localDate: LocalDate, in timeZone: WolfDateTime.TimeZone) -> TimeSpan? {
        func openAllDay() -> TimeSpan {
            let start = localDate.toUTCDateTime(at: LocalTime.midnight, in: timeZone)
            let end = localDate.adding(days: 1).toUTCDateTime(at: LocalTime.midnight, in: timeZone)
            return try! TimeSpan(start: start, end: end) // won't throw because duration is positive
        }

        // If there are no specs, then it's always open
        guard let openHours = openHours else {
            return openAllDay()
        }

        // If we have specs, but they're empty, then it's always open
        if openHours.isEmpty {
            return openAllDay()
        }

        // If there no valid OpenHours for this date, then it's closed.
        guard let validSpec = effectiveOpenHours(on: localDate) else {
            return nil
        }

        // If there is no more specific open hours for today, then it's just "open today".
        guard let span = validSpec.openSpan(on: localDate, in: timeZone) else {
            return openAllDay()
        }

        // We now know that it is open for specific hours today.
        return span
    }
}
