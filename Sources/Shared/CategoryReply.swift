public struct CategoryReply: Codable {
    public var id: String
    public var name: LocalizedString
    public var image: ImageReply?
    public var emoji: String?
    public var svgIcon: IRL?

    public init(id: String, name: LocalizedString, image: ImageReply?, emoji: String?, svgIcon: IRL?) {
        self.id = id
        self.name = name
        self.image = image
        self.emoji = emoji
        self.svgIcon = svgIcon
    }
}
