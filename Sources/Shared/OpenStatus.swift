import Foundation

public enum OpenStatus: String, Codable {
    case alwaysOpen         // Never closes
    case openLaterToday     // Opening within six hours
    case openingSoon        // Opening within an hour
    case openNow            // Currently open
    case openAllDay         // Open all day today
    case closingSoon        // Closing within an hour
    case closed             // Currently closed
}
