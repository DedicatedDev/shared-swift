import WolfDateTime
import WolfCore

public let openLeadTime = 18 * oneHour

extension TimeSpan {
    public func openStatus(for date: UTCDateTime) -> OpenStatus {
        if contains(date: date) {
            // The date is inside the span
            let durationLeft = end.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
            return durationLeft >= oneHour ? .openNow : .closingSoon
        } else if date < start {
            // The date is before the span
            let durationUntil = start.timeIntervalSinceNow - date.timeIntervalSinceNow
            if durationUntil < oneHour {
                return .openingSoon
            } else if durationUntil < openLeadTime {
                return .openLaterToday
            } else {
                return .closed
            }
        } else {
            // The date is after the span
            return .closed
        }
    }
}
