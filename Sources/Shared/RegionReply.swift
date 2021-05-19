public struct RegionReply: Codable {
    public var id: String
    public var name: LocalizedString
    public var welcome: LocalizedString
    public var image: ImageReply
    public var location: Location

    public init(id: String, name: LocalizedString, welcome: LocalizedString, image: ImageReply, location: Location) {
        self.id = id
        self.name = name
        self.welcome = welcome
        self.image = image
        self.location = location
    }
}
