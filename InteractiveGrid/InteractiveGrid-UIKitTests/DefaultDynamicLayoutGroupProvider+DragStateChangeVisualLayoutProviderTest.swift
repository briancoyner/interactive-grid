import XCTest
import RegexBuilder

@testable import InteractiveGrid_UIKit

/// This test case is written as a [parameterized test case](https://briancoyner.github.io/articles/2015-11-28-swift-parameterized-xctestcase/).
/// This is an old-technique that still works well in Swift and Xcode 14.
final class DefaultDynamicLayoutGroupProvider_DragStateChangeVisualLayoutProviderTest: XCTestCase {

    private var testDescription: TestDescription!

    override class var defaultTestSuite: XCTestSuite {
        let testSuite = XCTestSuite(name: NSStringFromClass(self))
        let testProvider = DragStateChangeTestRunVisualLayoutProvider()

        do {
            for testRun in try testProvider.makeTestRuns() {
                for invocation in testInvocations {
                    let testCase = DefaultDynamicLayoutGroupProvider_DragStateChangeVisualLayoutProviderTest(invocation: invocation)
                    testCase.testDescription = testRun

                    testSuite.addTest(testCase)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }

        return testSuite
    }
}


extension DefaultDynamicLayoutGroupProvider_DragStateChangeVisualLayoutProviderTest {

    func testDeriveProposedDragStateChange() throws {
        doTestDeriveProposedDragStateChange(
            forDraggingIndex: testDescription.liftIndex,
            atCurrentIndex: 0,
            toProposedDropIndex: testDescription.dropIndex,
            associatedWith: testDescription.models,
            expectedDragStateChange: (dropIndex: testDescription.proposedDropIndex, proposedLayoutModels: testDescription.proposedLayoutModels)
        )
    }

    private func doTestDeriveProposedDragStateChange(
        forDraggingIndex draggingIndex: Int,
        atCurrentIndex currentIndex: Int,
        toProposedDropIndex proposedDropIndex: Int,
        associatedWith models: [Model],
        expectedDragStateChange: (dropIndex: Int, proposedLayoutModels: [Model]),
        line: UInt = #line
    ) {

        let (actualProposedLayoutModels, actualDropIndex) = DefaultDynamicLayoutGroupProvider.deriveProposedDragStateChange(
            forDraggingIndex: draggingIndex,
            atCurrentIndex: currentIndex,
            toProposedDropIndex: proposedDropIndex,
            models: models
        )
        XCTAssertEqual(expectedDragStateChange.dropIndex, actualDropIndex, line: line)
        XCTAssertEqual(expectedDragStateChange.proposedLayoutModels, actualProposedLayoutModels, line: line)
    }
}
