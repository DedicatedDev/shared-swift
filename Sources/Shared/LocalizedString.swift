import Foundation
import WolfCore

/// https://www.science.co.il/language/Locale-codes.php
/// https://www.babbel.com/en/magazine/the-10-most-spoken-languages-in-the-world/
/// https://www.babbel.com/en/magazine/most-spoken-languages-europe/
public enum LocaleIdentifier: String, Codable, CaseIterable {
    case en // English

    case ar // Arabic
    case bn // Bengali
    case da // Danish
    case de // German
    case es // Spanish
    case fr // French
    case hi // Hindi
    case id // Indonesian
    case it // Italian
    case ja // Japanese
    case nl // Dutch
    case pa // Punjabi
    case pl // Polish
    case pt // Portugese
    case ru // Russian
    case sv // Swedish
    case tr // Turkish
    case uk // Ukranian
    case zh // Chinese
}

public let defaultLocaleIdentifier: LocaleIdentifier = .en

public struct LocalizedString: Codable {
    public typealias DictType = [LocaleIdentifier: String]
    var dict: DictType

    public init(_ dict: DictType) {
        self.dict = dict
    }

    public init?(_ s: String?) {
        guard let s = s else { return nil }
        self.init([defaultLocaleIdentifier: s])
    }

    public init(_ inputDict: [LocaleIdentifier: String?]) {
        self.dict = inputDict.reduce(into: DictType(), { (d, e: (LocaleIdentifier, String?)) in
            let (key, value) = e
            if let value = value {
                d[key] = value
            }
        })
    }

    public init(_ stringDict: [String: String]) {
        self.dict = stringDict.reduce(into: DictType(), { (d, e: (String, String)) in
            let (key, value) = e
            if let localeIdentifier = LocaleIdentifier(rawValue: key) {
                d[localeIdentifier] = value
            }
        })
    }

    public init(identifier: LocaleIdentifier = defaultLocaleIdentifier, _ string: String) {
        dict = [identifier: string]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringDict = try container.decode([String: String].self)
        self.init(stringDict)
    }

    public func encode(to encoder: Encoder) throws {
        let d = dict.reduce(into: [String: String]()) { (result, pair) in
            let (k, v) = pair
            result[k.rawValue] = v
        }
        var container = encoder.singleValueContainer()
        try container.encode(d)
    }

    public func value(for localeIdentifier: LocaleIdentifier) -> String? {
        if let value = dict[localeIdentifier] {
            return value
        } else if let value = dict[defaultLocaleIdentifier] {
            return value
        } else if let value = dict.first?.value {
            return value
        } else {
            return ""
        }
    }

    public var value: String? {
        return value(for: defaultLocaleIdentifier)
    }
}

extension LocalizedString: CustomStringConvertible {
    public var description: String {
        return value†
    }
}

extension LocalizedString: ExpressibleByStringLiteral {
    public init(stringLiteral string: String) {
        self.init(identifier: defaultLocaleIdentifier, string)
    }
}
