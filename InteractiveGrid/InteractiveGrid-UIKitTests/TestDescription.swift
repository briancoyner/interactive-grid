import Foundation

@testable import InteractiveGrid_UIKit

struct TestDescription: CustomDebugStringConvertible {
    let name: String
    let inputFileLines: ClosedRange<Int>
    let models: [Model]
    let liftIndex: Int
    let dropIndex: Int

    let proposedDropIndex: Int
    let proposedLayoutModels: [Model]

    var debugDescription: String {
        return name + "; \(inputFileLines)"
    }
}
