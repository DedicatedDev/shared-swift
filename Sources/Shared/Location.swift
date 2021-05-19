import Foundation

public protocol HasLocation {
    var location: Location? { get }

    func distance(to point: Location?) -> Double?
    func distance(to place: HasLocation) -> Double?
}

extension HasLocation {
    public func distance(to point: Location?) -> Double? {
        guard let loc1 = location, let loc2 = point else { return nil }
        return loc1.distance(from: loc2)
    }

    public func distance(to place: HasLocation) -> Double? {
        guard let loc1 = location, let loc2 = place.location else { return nil }
        return loc1.distance(from: loc2)
    }
}

/// https://schema.org/GeoCoordinates
public struct Location: Codable {
    public var latitude: Double
    public var longitude: Double

    enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    // Encoded per MongoDB (GeoJSON) specifications.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("Point", forKey: .type)
        try container.encode([longitude, latitude], forKey: .coordinates)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        guard type == "Point" else {
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Point type expected.")
        }
        let coordinates = try container.decode([Double].self, forKey: .coordinates)
        guard coordinates.count == 2 else {
            throw DecodingError.dataCorruptedError(forKey: .coordinates, in: container, debugDescription: "Expected exactly 2 coordinates. Got \(coordinates.count).")
        }
        longitude = coordinates[0]
        latitude = coordinates[1]
    }

    public init?(_ string: String?) {
        guard let string = string else { return nil }
        let comps = string.split(separator: ",")
        guard comps.count == 2 else { return nil }
        guard let latitude = Double(comps[0]) else { return nil }
        guard let longitude = Double(comps[1]) else { return nil }
        guard (-90...90).contains(latitude) else { return nil }
        guard (-180...180).contains(longitude) else { return nil }
        self.latitude = latitude
        self.longitude = longitude
    }

    public func distance(from location: Location) -> Double {
        return haversineDistance(lat1: latitude, lon1: longitude, lat2: location.latitude, lon2: location.longitude)
    }
}

extension Location: Equatable {
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}

// Based on:
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/HaversineDistance/HaversineDistance.playground/Contents.swift
public func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
    let radius = 6367444.7

    let haversin = { (angle: Double) -> Double in
        return (1 - cos(angle))/2
    }

    let ahaversin = { (angle: Double) -> Double in
        return 2 * asin(sqrt(angle))
    }

    // Converts from degrees to radians
    func dToR(_ angle: Double) -> Double {
        return angle / 180 * .pi
    }

    let lat1r = dToR(lat1)
    let lon1r = dToR(lon1)
    let lat2r = dToR(lat2)
    let lon2r = dToR(lon2)

    return radius * ahaversin(haversin(lat2r - lat1r) + cos(lat1r) * cos(lat2r) * haversin(lon2r - lon1r))
}
