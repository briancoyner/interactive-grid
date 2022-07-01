import Foundation

struct Model: Hashable {
    enum Style {
        case compact
        case regular
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
