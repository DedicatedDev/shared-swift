public struct ImageReply: Codable {
    public var id: String
    public var type: String
    public var banner: IRL
    public var poster: IRL
    public var stamp: IRL
    public var postcard: IRL
    public var widescreen: IRL

    public init(id: String, type: String, banner: IRL, poster: IRL, stamp: IRL, postcard: IRL, widescreen: IRL) {
        self.id = id
        self.type = type
        self.banner = banner
        self.poster = poster
        self.stamp = stamp
        self.postcard = postcard
        self.widescreen = widescreen
    }
}
