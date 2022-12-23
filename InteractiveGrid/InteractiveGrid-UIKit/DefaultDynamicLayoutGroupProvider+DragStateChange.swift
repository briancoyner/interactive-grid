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
        models: [Model]) -> ([Model], Int)
    {
        var copy = models
        var newDropIndex = proposedDropIndex

        let source = models[draggingIndex]
        let target = models[proposedDropIndex]
        switch (source.style, target.style) {
        case (.compact, _):
            move(modelAtIndex: draggingIndex, toOffset: newDropIndex, models: &copy)
        case (.regular, .regular):
            move(modelAtIndex: draggingIndex, toOffset: newDropIndex, models: &copy)
        case (.regular, .compact):
            let dragDirection = DragDirection(currentIndex: currentIndex, proposedDropIndex: newDropIndex)
            switch dragDirection {
            case .up:
                let indexedRowStyles = derivedIndexRowStyles(for: models)
                let proposedRowStyle = indexedRowStyles[proposedDropIndex]
                switch proposedRowStyle {
                case .regular:
                    newDropIndex = proposedDropIndex
                    move(modelAtIndex: draggingIndex, toOffset: newDropIndex, models: &copy)
                case .compactLeading:
                    newDropIndex = proposedDropIndex
                    move(modelAtIndex: draggingIndex, toOffset: newDropIndex, models: &copy)
                case .compactTrailing:
                    newDropIndex = proposedDropIndex - 1
                    move(modelAtIndex: draggingIndex, toOffset: newDropIndex, models: &copy)
                case .compactOrphan:
                    newDropIndex = proposedDropIndex
                    pivot(modelBeingDraggedAtIndex: draggingIndex, toIndex: newDropIndex, models: &copy)
                }
            case .down:
                let successorToProposedDropIndex = proposedDropIndex + 1
                let clamp = min(copy.count - 1, successorToProposedDropIndex)
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

    private static func derivedIndexRowStyles(for models: [Model]) -> [RowStyle] {
        let styles = models.map { $0.style }

        var indexedRowStyles: [RowStyle] = []
        var previousStyle: Model.Style? = nil
        var previousDerivedStyle: RowStyle? = nil
        for index in 0..<styles.count {
            let currentStyle = styles[index]
            let nextStyle = (index == styles.count - 1) ? nil: styles[index + 1]

            // The real magic for dynamically adjusting the layout happens in the
            // `DynamicLayoutGroupProvider`, which is a custom type specific to this
            // demo.
            //
            // The provider extracts the logic needed to dynamically generate the layout group
            // into a unit testable data structure, which is nice.
            let rowLayout = deriveRowStyle(
                basedOnPreviousStyle: previousStyle,
                currentStyle: currentStyle,
                nextStyle: nextStyle,
                previousRowStyle: previousDerivedStyle
            )

            indexedRowStyles.append(rowLayout)
            previousStyle = currentStyle
            previousDerivedStyle = rowLayout
        }

        return indexedRowStyles
    }

    private static func deriveRowStyle(
        basedOnPreviousStyle previousStyle: Model.Style?,
        currentStyle: Model.Style,
        nextStyle: Model.Style?,
        previousRowStyle: RowStyle?
    ) -> RowStyle {

        // Special case if we are at the end.
        guard let nextStyle = nextStyle else {
            switch currentStyle {
            case .compact:
                return .compactOrphan
            case .regular:
                return .regular
            }
        }

        switch (previousStyle, currentStyle, nextStyle) {
        case (.none, .compact, .compact):
            return .compactLeading
        case (.none, .compact, .regular):
            return .compactOrphan
        case (.compact, .compact, .compact):
            if previousRowStyle == .compactTrailing {
                return .compactLeading
            } else {
                return .compactTrailing
            }
        case (.compact, .compact, .regular):
            if previousRowStyle == .compactTrailing {
                return .compactOrphan
            } else {
                return .compactTrailing
            }
        case (.regular, .compact, .compact):
            return .compactLeading
        case (.regular, .compact, .regular):
            return .compactOrphan
        case (_, .regular, _):
            return .regular
        }
    }
}

extension DefaultDynamicLayoutGroupProvider {

    private enum RowStyle {
        case compactLeading
        case compactTrailing
        case compactOrphan
        case regular
    }

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
}
