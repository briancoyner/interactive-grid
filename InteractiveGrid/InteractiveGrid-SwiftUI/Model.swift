import Foundation

struct Model: Hashable, Identifiable {
    enum Style {
        case compact
        case regular
    }

    var id: Int {
        return value
    }

    let value: Int
    let style: Style
    let allowsContextMenu: Bool
}

extension Model.Style: CustomStringConvertible {

    var description: String {
        switch self {
        case .compact:
            return "Compact"
        case .regular:
            return "Regular"
        }
    }

    var symbolName: String {
        switch self {
        case .compact:
            return "plus.square"
        case .regular:
            return "plus.rectangle"
        }
    }
}
