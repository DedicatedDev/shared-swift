public struct CategoriesReply: Codable {
    public var eventCategories: [CategoryReply]?
    public var venueCategories: [CategoryReply]?
    public var cuisines: [CategoryReply]?
    public var dressCodes: [CategoryReply]?
    public var restrictions: [CategoryReply]?
    public var activities: [CategoryReply]?
    public var regions: [RegionReply]?

    public init() { }
}
