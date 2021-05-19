import WolfDateTime

public struct EventReply: Codable, OccurrenceReplyItem {
    // Thing
    public var id: String
    public var title: LocalizedString?
    public var subtitle: LocalizedString?
    public var image: ImageReply?
    public var description: LocalizedString?
    public var url: IRL?

    // Event
    public var venue: String?
    public var categories: [String]?
    public var openHours: [OpenHours]?

    // Place
    public var address: String?
    public var location: Location?
    public var placeID: String?
    public var timeZone: WolfDateTime.TimeZone?

    public var ticketsURL: IRL?
    public var dressCode: String?
    public var restrictions: [String]?

    public init(id: String) {
        self.id = id
    }
}
