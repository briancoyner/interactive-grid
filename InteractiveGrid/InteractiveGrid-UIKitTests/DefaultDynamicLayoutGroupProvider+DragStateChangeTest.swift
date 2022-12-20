import XCTest

@testable import InteractiveGrid_UIKit

final class DefaultDynamicLayoutGroupProvider_DragStateChangeTest: XCTestCase {
}

// MARK - Drag "Regular" Item Tests

extension DefaultDynamicLayoutGroupProvider_DragStateChangeTest {

    func testDragRegularItemAtIndexZero_ToNextRowAtIndexOneContainingACompactItem_ItemsEffectivelySwap() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 0, style: .regular, allowsContextMenu: true)
            ])
        )
    }

    func testDragRegularItemAtIndexZero_ToNextRowAtIndexTwoContainingACompactItem_TheRegularItemSwapsWithBothCompactItems() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 0, style: .regular, allowsContextMenu: true)
            ])
        )
    }
}

// MARK: Tests that need to be renamed and organized.

extension DefaultDynamicLayoutGroupProvider_DragStateChangeTest {

    func testTODO_ProvideDescriptiveName_3() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 2,
            atCurrentIndex: 2,
            toProposedDropIndex: 0,
            associatedWith: [
                Model(value: 0, style: .compact, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .regular, allowsContextMenu: true),
                Model(value: 3, style: .compact, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                Model(value: 2, style: .regular, allowsContextMenu: true),
                Model(value: 0, style: .compact, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 3, style: .compact, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_4() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 2,
            atCurrentIndex: 2,
            toProposedDropIndex: 1,
            associatedWith: [
                Model(value: 0, style: .compact, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .regular, allowsContextMenu: true),
                Model(value: 3, style: .compact, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                Model(value: 2, style: .regular, allowsContextMenu: true),
                Model(value: 0, style: .compact, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 3, style: .compact, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_5() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 3,
            atCurrentIndex: 3,
            toProposedDropIndex: 1,
            associatedWith: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 3, style: .regular, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 3, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_6() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                Model(value: 1, style: .regular, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 3, style: .compact, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true),
                Model(value: 5, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 3, style: .compact, allowsContextMenu: true),
                Model(value: 1, style: .regular, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true),
                Model(value: 5, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_7() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                Model(value: 1, style: .regular, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 3, style: .regular, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true),
                Model(value: 5, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 1, style: .regular, allowsContextMenu: true),
                Model(value: 3, style: .regular, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true),
                Model(value: 5, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_8() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                Model(value: 1, style: .regular, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 3, style: .regular, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true),
                Model(value: 5, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 1, style: .regular, allowsContextMenu: true),
                Model(value: 3, style: .regular, allowsContextMenu: true),
                Model(value: 4, style: .compact, allowsContextMenu: true),
                Model(value: 5, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_9() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 3,
            atCurrentIndex: 3,
            toProposedDropIndex: 2,
            associatedWith: [
                Model(value: 0, style: .compact, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true),
                Model(value: 3, style: .regular, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                Model(value: 0, style: .compact, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 3, style: .regular, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_10() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 1,
            atCurrentIndex: 1,
            toProposedDropIndex: 0,
            associatedWith: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_11() throws {
        try XCTSkipIf(true, "Scenario is currently broken.")
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 2,
            toProposedDropIndex: 1,
            associatedWith: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_12() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 2,
            toProposedDropIndex: 0,
            associatedWith: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 2, style: .compact, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_13() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 0, style: .regular, allowsContextMenu: true)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_14() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 1,
            atCurrentIndex: 1,
            toProposedDropIndex: 0,
            associatedWith: [
                Model(value: 0, style: .regular, allowsContextMenu: true),
                Model(value: 1, style: .compact, allowsContextMenu: true)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                Model(value: 1, style: .compact, allowsContextMenu: true),
                Model(value: 0, style: .regular, allowsContextMenu: true)
            ])
        )
    }
}

extension DefaultDynamicLayoutGroupProvider_DragStateChangeTest {

    private func doTestDeriveProposedDragStateChange(
        forDraggingIndex draggingIndex: Int,
        atCurrentIndex currentIndex: Int,
        toProposedDropIndex proposedDropIndex: Int,
        associatedWith models: [Model],
        expectedDragStateChange: (dropIndex: Int, proposedLayoutModels: [Model])
    ) {

        let (actualProposedLayoutModels, actualDropIndex) = DefaultDynamicLayoutGroupProvider.deriveProposedDragStateChange(
            forDraggingIndex: draggingIndex,
            atCurrentIndex: currentIndex,
            toProposedDropIndex: proposedDropIndex,
            models: models
        )
        XCTAssertEqual(expectedDragStateChange.dropIndex, actualDropIndex)
        XCTAssertEqual(expectedDragStateChange.proposedLayoutModels, actualProposedLayoutModels)
    }
}
