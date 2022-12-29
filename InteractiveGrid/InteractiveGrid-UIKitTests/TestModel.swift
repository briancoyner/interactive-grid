import XCTest

@testable import InteractiveGrid_UIKit

/// Used by the ``DefaultDynamicLayoutGroupProvider+DragStateChangeTest`` to help visually describe a grid layout.
protocol TestModel {
    var value: Int { get }
    var style: Model.Style { get }

    func makeModel() -> Model
}

extension TestModel {

    func makeModel() -> Model {
        return Model(value: value, style: style)
    }
}

/// Represents a ``Model.Style.Compact``.
struct C: TestModel {
    let value: Int
    let style: Model.Style = .compact

    init(_ value: Int) {
        self.value = value
    }
}

/// Represents a ``Model.Style.Regular``.
struct R: TestModel {
    let value: Int
    let style: Model.Style = .regular

    init(_ value: Int) {
        self.value = value
    }
}
