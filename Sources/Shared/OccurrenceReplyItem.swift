import WolfDateTime
import WolfCore

public protocol OccurrenceReplyItem: HasOpenHours {
    var title: LocalizedString? { get }
    var subtitle: LocalizedString? { get }
    var image: ImageReply? { get }
    var description: LocalizedString? { get }
    var url: IRL? { get }

    var openHours: [OpenHours]? { get }

    var address: String? { get }
    var location: Location? { get }
    var timeZone: WolfDateTime.TimeZone? { get }

    var dressCode: String? { get }
    var restrictions: [String]? { get }

    var fullName: String { get }
}

extension OccurrenceReplyItem {
    public var fullName: String {
        guard let title = self.title?.value else { return "Untitled" }
        let comps = [title, subtitle?.value].compactMap {  $0 }
        return comps.joined(separator: " ")
    }
}
