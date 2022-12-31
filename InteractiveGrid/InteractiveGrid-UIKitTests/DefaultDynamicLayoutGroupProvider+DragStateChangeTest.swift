import XCTest

@testable import InteractiveGrid_UIKit

/// This test case uses two special model types named `R` (regular style) and `C` (compact style) to help visually describe grid layout.
///
/// "Regular" models span two columns (one per row)
/// "Compact" models always take up one column (one or two per row). 
final class DefaultDynamicLayoutGroupProvider_DragStateChangeTest: XCTestCase {

}

extension DefaultDynamicLayoutGroupProvider_DragStateChangeTest {

    func testDragRegularItemAtIndexZero_ToNextRowAtIndexOneContainingARegularItem_ItemsEffectivelySwap() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                R(0),
                R(1)
            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                R(1),
                R(0)
            ])
        )
    }

    func testDragRegularItemAtIndexZero_ToNextRowAtIndexOneContainingACompactOrphanItem_ItemsEffectivelySwap() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                R(0),
                C(1)
            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                C(1),
                R(0)
            ])
        )
    }

    func testDragRegularItemAtIndexZero_ToNextRowAtIndexContainingACompactLeadingItem_TheRegularItemSwapsWithBothCompactLeadingAndCompactTrailing() {

        // Important: The proposed drag index dynamically adjusts to mimic the user dropping on the "compact trailing"
        // item. This effectively moves the "compact" row above the "regular" row.

        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                R(0),
                C(1), C(2)
            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                C(1), C(2),
                R(0)
            ])
        )
    }

    func testDragRegularItemAtIndexZero_ToNextRowAtIndexContainingACompactTrailingItem_TheRegularItemSwapsWithBothCompactLeadingAndCompactTrailing() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 2,
            associatedWith: [
                R(0),
                C(1), C(2)
            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                C(1), C(2),
                R(0)
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
                C(0), C(1),
                R(2),
                C(3), C(4)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                R(2),
                C(0), C(1),
                C(3), C(4)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_4() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 2,
            atCurrentIndex: 2,
            toProposedDropIndex: 1,
            associatedWith: [
                C(0), C(1),
                R(2),
                C(3), C(4)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                R(2),
                C(0), C(1),
                C(3), C(4)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_5() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 3,
            atCurrentIndex: 3,
            toProposedDropIndex: 1,
            associatedWith: [
                R(0),
                C(1), C(2),
                R(3),
                C(4)

            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                R(0),
                R(3),
                C(1), C(2),
                C(4)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_6() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                R(0),
                C(1), C(2),
                C(3), C(4)
            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                C(1), C(2),
                R(0),
                C(3), C(4)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_7() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                R(0),
                C(1),
                R(2),
                C(3), C(4)
            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                C(1),
                R(0),
                R(2),
                C(3), C(4)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_9() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 3,
            atCurrentIndex: 3,
            toProposedDropIndex: 2,
            associatedWith: [
                C(0), C(1),
                C(2),
                R(3)
            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                C(0), C(1),
                R(3),
                C(2)
            ])
        )
    }


    func testTODO_ProvideDescriptiveName_10() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 1,
            atCurrentIndex: 1,
            toProposedDropIndex: 0,
            associatedWith: [
                R(0),
                C(1), C(2)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                C(1),
                R(0),
                C(2)
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
                R(0),
                C(1), C(2)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                R(0),
                C(1), C(2)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_12() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 2,
            toProposedDropIndex: 0,
            associatedWith: [
                R(0),
                C(1), C(2)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                R(0),
                C(1), C(2)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_13() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                R(0),
                C(1)
            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                C(1),
                R(0)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_14() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 1,
            atCurrentIndex: 1,
            toProposedDropIndex: 0,
            associatedWith: [
                R(0),
                C(1)
            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                C(1),
                R(0)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_15() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 2,
            atCurrentIndex: 2,
            toProposedDropIndex: 3,
            associatedWith: [
                C(0),
                R(1),
                C(2),
                R(3)
            ],
            expectedDragStateChange: (dropIndex: 3, proposedLayoutModels: [
                C(0),
                R(1),
                R(3),
                C(2)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_16() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 3,
            atCurrentIndex: 3,
            toProposedDropIndex: 2,
            associatedWith: [
                C(0),
                R(1),
                C(2),
                R(3)
            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                C(0),
                R(1),
                R(3),
                C(2)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_17() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                C(0), C(1)

            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                C(1), C(0)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_17_1() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 1,
            atCurrentIndex: 1,
            toProposedDropIndex: 0,
            associatedWith: [
                C(0), C(1)

            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                C(1), C(0)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_17_3() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 2,
            atCurrentIndex: 2,
            toProposedDropIndex: 3,
            associatedWith: [
                C(0), C(1),
                C(2), C(3)

            ],
            expectedDragStateChange: (dropIndex: 3, proposedLayoutModels: [
                C(0), C(1),
                C(3), C(2)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_17_4() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 3,
            atCurrentIndex: 3,
            toProposedDropIndex: 2,
            associatedWith: [
                C(0), C(1),
                C(2), C(3)

            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                C(0), C(1),
                C(3), C(2)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_17_5() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 3,
            associatedWith: [
                C(0), C(1),
                C(2), C(3)

            ],
            expectedDragStateChange: (dropIndex: 3, proposedLayoutModels: [
                C(1), C(2),
                C(3), C(0)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_17_6() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 1,
            atCurrentIndex: 1,
            toProposedDropIndex: 2,
            associatedWith: [
                C(0), C(1),
                C(2), C(3)

            ],
            expectedDragStateChange: (dropIndex: 2, proposedLayoutModels: [
                C(0), C(2),
                C(1), C(3)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_17_7() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 2,
            atCurrentIndex: 0,
            toProposedDropIndex: 1,
            associatedWith: [
                C(0), C(1),
                C(2), C(3)

            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                C(0), C(2),
                C(1), C(3)
            ])
        )

        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 2,
            atCurrentIndex: 3,
            toProposedDropIndex: 1,
            associatedWith: [
                C(0), C(1),
                C(2), C(3)

            ],
            expectedDragStateChange: (dropIndex: 1, proposedLayoutModels: [
                C(0), C(2),
                C(1), C(3)
            ])
        )
    }

    func testTODO_ProvideDescriptiveName_17_8() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 0,
            atCurrentIndex: 0,
            toProposedDropIndex: 5,
            associatedWith: [
                C(0), C(1),
                C(2), C(3),
                C(4), C(5)

            ],
            expectedDragStateChange: (dropIndex: 5, proposedLayoutModels: [
                C(1), C(2),
                C(3), C(4),
                C(5), C(0)
            ])
        )

        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 5,
            atCurrentIndex: 5,
            toProposedDropIndex: 0,
            associatedWith: [
                C(0), C(1),
                C(2), C(3),
                C(4), C(5)

            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                C(5), C(0),
                C(1), C(2),
                C(3), C(4)
            ])
        )

        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 5,
            atCurrentIndex: 1,
            toProposedDropIndex: 0,
            associatedWith: [
                C(0), C(1),
                C(2), C(3),
                C(4), C(5)

            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                C(5), C(0),
                C(1), C(2),
                C(3), C(4)
            ])
        )

        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 5,
            atCurrentIndex: 2,
            toProposedDropIndex: 0,
            associatedWith: [
                C(0), C(1),
                C(2), C(3),
                C(4), C(5)

            ],
            expectedDragStateChange: (dropIndex: 0, proposedLayoutModels: [
                C(5), C(0),
                C(1), C(2),
                C(3), C(4)
            ])
        )
    }


    func testTODO_ProvideDescriptiveName_18() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 3,
            atCurrentIndex: 0,
            toProposedDropIndex: 4,
            associatedWith: [
                C(0), C(1),
                C(2), C(3),
                R(4),
                R(5)
            ],
            expectedDragStateChange: (dropIndex: 4, proposedLayoutModels: [
                C(0), C(1),
                C(2),
                R(4),
                C(3),
                R(5)
            ])
        )
    }

    func testDragCompactLeadingItem_ToLastRowAtIndexContainingARegularItem_DraggedCompactItemMovesAfterTheRegularItem() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 1,
            atCurrentIndex: 1,
            toProposedDropIndex: 3,
            associatedWith: [
                R(0),
                C(1), C(2),
                R(3)
            ],
            expectedDragStateChange: (dropIndex: 3, proposedLayoutModels: [
                R(0),
                C(2),
                R(3),
                C(1)
            ])
        )
    }

    func testDragCompactLeadingItem_ToRowAtIndexContainingARegularItem_DraggedCompactItemMovesAfterTheRegularItem() {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: 1,
            atCurrentIndex: 1,
            toProposedDropIndex: 3,
            associatedWith: [
                R(0),
                C(1), C(2),
                R(3),
                C(4), C(5)
            ],
            expectedDragStateChange: (dropIndex: 3, proposedLayoutModels: [
                R(0),
                C(2),
                R(3),
                C(1), C(4),
                C(5)
            ])
        )
    }
}

extension DefaultDynamicLayoutGroupProvider_DragStateChangeTest {

    private func doTestDeriveProposedDragStateChange(
        forDraggingIndex draggingIndex: Int,
        atCurrentIndex currentIndex: Int,
        toProposedDropIndex proposedDropIndex: Int,
        associatedWith models: [TestModel],
        expectedDragStateChange: (dropIndex: Int, proposedLayoutModels: [TestModel]),
        line: UInt = #line
    ) {

        let (actualProposedLayoutModels, actualDropIndex) = DefaultDynamicLayoutGroupProvider.deriveProposedDragStateChange(
            forDraggingIndex: draggingIndex,
            atCurrentIndex: currentIndex,
            toProposedDropIndex: proposedDropIndex,
            models: models.map { $0.makeModel() }
        )
        XCTAssertEqual(expectedDragStateChange.dropIndex, actualDropIndex, line: line)
        XCTAssertEqual(expectedDragStateChange.proposedLayoutModels.map { $0.makeModel() }, actualProposedLayoutModels, line: line)
    }
}
