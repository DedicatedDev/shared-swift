import Foundation

public struct IRL: Codable {
    public let foundationURL: URL

    public struct Error: Swift.Error {
        public let message: String

        public init(_ message: String) {
            self.message = message
        }
    }

    public var absoluteString: String {
        return foundationURL.absoluteString
    }

    public init(foundationURL: URL) {
        self.foundationURL = foundationURL
    }

    public init?(string: String) {
        guard let f = URL(string: string) else { return nil }
        foundationURL = f
    }

    public init(fileURLWithPath path: String) {
        foundationURL = URL(fileURLWithPath: path)
    }

    public func appendingPathComponent(_ pathComponent: String) -> IRL {
        return IRL(foundationURL: foundationURL.appendingPathComponent(pathComponent))
    }

    public var path: String {
        return foundationURL.path
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let urlString = try container.decode(String.self)
        guard let u = URL(string: urlString) else {
            throw Error("Could not decode URL from “\(urlString)”.")
        }
        foundationURL = u
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(foundationURL.absoluteString)
    }
}

extension IRL: CustomStringConvertible {
    public var description: String {
        return foundationURL.description
    }
}

extension Data {
    public init(contentsOf url: IRL) throws {
        try self.init(contentsOf: url.foundationURL)
    }
}

extension InputStream {
    public convenience init?(url: IRL) {
        self.init(url: url.foundationURL)
    }
}

extension URLComponents {
    public var appURL: IRL? {
        guard let url = self.url else { return nil }
        return IRL(foundationURL: url)
    }
}
