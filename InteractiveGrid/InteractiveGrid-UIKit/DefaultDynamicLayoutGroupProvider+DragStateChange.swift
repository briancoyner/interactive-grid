import Foundation
import UIKit

extension DefaultDynamicLayoutGroupProvider {

    // TODO: This is a bunch of hacks... refactor/ simplify.
    // TODO: Needs lots more tests (some scenarios are still not quite where I want them to be).
    // TODO: Document (with pictures)
    static func deriveProposedDragStateChange(
        forDraggingIndex draggingIndex: Int,
        atCurrentIndex currentIndex: Int,
        toProposedDropIndex proposedDropIndex: Int,
        models: [Model]
    ) -> ([Model], Int) {
        let source = models[draggingIndex]
        let target = models[proposedDropIndex]

        var copy = models
        var newDropIndex = proposedDropIndex

        switch (source.style, target.style) {
        case (.compact, _):
            move(modelAtIndex: draggingIndex, toOffset: newDropIndex, models: &copy)
        case (.regular, .regular):
            move(modelAtIndex: draggingIndex, toOffset: newDropIndex, models: &copy)
        case (.regular, .compact):
            let dragDirection = DragDirection(currentIndex: currentIndex, proposedDropIndex: newDropIndex)

            switch dragDirection {
            case .up:
                if proposedDropIndex - 1 >= 0 {
                    if models[proposedDropIndex - 1].style == .compact, !isRowPrecedingItemAtIndexCompactCompact(index: proposedDropIndex, models: models) {
                        newDropIndex = proposedDropIndex - 1
                    }

                    pivot(modelBeingDraggedAtIndex: draggingIndex, toIndex: newDropIndex, models: &copy)
                } else {
                    move(modelAtIndex: draggingIndex, toOffset: proposedDropIndex, models: &copy)
                }
            case .down:
                let toRightIndex = proposedDropIndex + dragDirection.rawValue
                let clamp = min(copy.count - 1, toRightIndex)
                let check = models[clamp]
                if check.style == .compact {
                    newDropIndex = clamp
                    pivot(modelBeingDraggedAtIndex: draggingIndex, toIndex: newDropIndex, models: &copy)
                } else {
                    move(modelAtIndex: draggingIndex, toOffset: proposedDropIndex + 1, models: &copy)
                }
            }
        }

        return (copy, newDropIndex)
    }
}

extension DefaultDynamicLayoutGroupProvider {

    private enum DragDirection: Int {
        case up = -1
        case down = 1

        init(currentIndex: Int, proposedDropIndex: Int) {
            self = currentIndex < proposedDropIndex ? .down : .up
        }
    }
}

extension DefaultDynamicLayoutGroupProvider {

    private static func move(modelAtIndex fromIndex: Int, toOffset: Int, models: inout [Model]) {
        models.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toOffset)
    }

    private static func pivot(modelBeingDraggedAtIndex draggingIndex: Int, toIndex: Int,  models: inout [Model]) {
        let removed = models.remove(at: draggingIndex)
        models.insert(removed, at: toIndex)
    }

    private static func isRowPrecedingItemAtIndexCompactCompact(index: Int, models: [Model]) -> Bool {
        guard index - 2 >= 0, index - 1 >= 0 else {
            return false
        }

        let columnOne = models[index - 2]
        let columnTwo = models[index - 1]
        return columnOne.style == .compact && columnTwo.style == .compact
    }
}
