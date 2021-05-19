import WolfDateTime

public struct VenueReply: Codable, OccurrenceReplyItem {
    // Thing
    public var id: String
    public var title: LocalizedString?
    public var subtitle: LocalizedString?
    public var image: ImageReply?
    public var description: LocalizedString?
    public var url: IRL?

    // Organization
    public var telephone: String?

    // Place
    public var address: String?
    public var location: Location?
    public var placeID: String?
    public var timeZone: WolfDateTime.TimeZone?

    // Venue
    public var supervenue: String?
    public var subvenues: [String]?
    public var events: [String]?
    public var categories: [String]?
    public var openHours: [OpenHours]?
    public var dressCode: String?
    public var restrictions: [String]?

    // FoodEstablishment
    public var priceRange: String?
    public var menuURL: IRL?
    public var cuisine: String?

    public init(id: String) {
        self.id = id
    }
}
