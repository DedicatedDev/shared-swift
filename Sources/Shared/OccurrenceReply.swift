import WolfCore
import WolfDateTime

public final class OccurrenceReply: Codable {
    private typealias `Self` = OccurrenceReply

    public enum Value {
        case venue(VenueReply)
        case event(EventReply)

        public var id: String {
            switch self {
            case .venue(let value):
                return "venue-\(value.id)"
            case .event(let value):
                return "event-\(value.id)"
            }
        }

        public var item: OccurrenceReplyItem {
            switch self {
            case .venue(let value):
                return value
            case .event(let value):
                return value
            }
        }
    }

    public let id: String
    public var value: Value?
    public var score: Double?
    public var scoringInfo: RelevanceInfo?

    public var item: OccurrenceReplyItem {
        switch value! {
        case .venue(let reply):
            return reply
        case .event(let reply):
            return reply
        }
    }

    public init(id: String) {
        self.id = id
    }

    public init(value: Value) {
        self.id = value.id
        self.value = value
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case venue
        case event
        case score
        case scoringInfo
        case missing
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        score = try container.decodeIfPresent(Frac.self, forKey: .score)
        scoringInfo = try container.decodeIfPresent(RelevanceInfo.self, forKey: .scoringInfo)

        if let venue = try container.decodeIfPresent(VenueReply.self, forKey: .venue) {
            value = .venue(venue)
        } else if let event = try container.decodeIfPresent(EventReply.self, forKey: .event) {
            value = .event(event)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(scoringInfo, forKey: .scoringInfo)

        if let value = value {
            switch value {
            case .venue(let value):
                try container.encode(value, forKey: .venue)
            case .event(let value):
                try container.encode(value, forKey: .event)
            }
        }
    }

    public struct RelevanceInfo: Codable {
        var openStatusWeight: Frac
        var distance: Double
        var distanceWeight: Frac

        public init(openStatusWeight: Frac, distance: Double, distanceWeight: Frac) {
            self.openStatusWeight = openStatusWeight
            self.distance = distance
            self.distanceWeight = distanceWeight
        }
    }
}

extension OccurrenceReply: OccurrenceReplyItem {
    public var title: LocalizedString? {
        return item.title
    }

    public var subtitle: LocalizedString? {
        return item.subtitle
    }

    public var image: ImageReply? {
        return item.image
    }

    public var description: LocalizedString? {
        return item.description
    }

    public var url: IRL? {
        return item.url
    }

    public var openHours: [OpenHours]? {
        return item.openHours
    }

    public var address: String? {
        return item.address
    }

    public var location: Location? {
        return item.location
    }

    public var timeZone: WolfDateTime.TimeZone? {
        return item.timeZone
    }

    public var dressCode: String? {
        return item.dressCode
    }

    public var restrictions: [String]? {
        return item.restrictions
    }
}
