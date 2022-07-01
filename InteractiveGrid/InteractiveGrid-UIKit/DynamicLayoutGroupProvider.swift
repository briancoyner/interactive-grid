import UIKit

/// This protocol declares an API for deriving a `NSCollectionLayoutGroup` based on
/// the previous model style (may be `nil`), the current style (non-`nil`) and the next style (may be `nil`).
protocol DynamicLayoutGroupProvider {

    func deriveLayoutGroup(
        basedOnPreviousStyle previousStyle: Model.Style?,
        currentStyle: Model.Style,
        nextStyle: Model.Style?
    ) -> NSCollectionLayoutGroup?
}
