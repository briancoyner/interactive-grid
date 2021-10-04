import Foundation
import UIKit

final class DefaultDynamicLayoutGroupProvider: DynamicLayoutGroupProvider {

    private lazy var compactGroup = lazyCompactGroup()
    private lazy var compactOrphanGroup = lazyCompactOrphanGroup()
    private lazy var regularGroup = lazyRegularGroup()
    private lazy var fullWidthItem = lazyFullWidthItem()
}

extension DefaultDynamicLayoutGroupProvider {

    func deriveLayoutGroup(
        basedOnPreviousStyle previousStyle: Model.Style?,
        currentStyle: Model.Style,
        nextStyle: Model.Style?
    ) -> NSCollectionLayoutGroup? {

        // Determining how to layout a cell requires knowing the
        // - previous cell's style (may be `nil`; first cell)
        // - current cell's style (non-`nil`)
        // - next cell's style (may be `nil`; last cell)

        // Special case if we are at the end.
        guard let nextStyle = nextStyle else {
            switch currentStyle {
            case .compact:
                return compactOrphanGroup
            case .regular:
                return regularGroup
            }
        }

        // This is the logic that drives how the compact and regular cells
        // are arranged in a 2-column layout.
        //
        // Here are the general row configurations:
        //  |  Compact  |  Compact  |
        //  |  Compact  |  <empty>  |
        //  |  R  e  g  u  l  a  r  |
        //
        // A simple switch statement makes it super simple to
        // derive one of the three row configurations.
        //
        switch (previousStyle, currentStyle, nextStyle) {
        case (.none, .compact, .compact):
            return compactGroup
        case (.none, .compact, .regular):
            return compactOrphanGroup
        case (.compact, .compact, .compact):
            return nil
        case (.compact, .compact, .regular):
            return nil
        case (.regular, .compact, .compact):
            return compactGroup
        case (.regular, .compact, .regular):
            return compactOrphanGroup
        case (_, .regular, _):
            return regularGroup
        }
    }
}

extension DefaultDynamicLayoutGroupProvider {

    private func lazyFullWidthItem() -> NSCollectionLayoutItem {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        return NSCollectionLayoutItem(layoutSize: layoutSize)
    }

    private func lazyCompactGroup() -> NSCollectionLayoutGroup {
        let compactGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        
        let compactGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: compactGroupSize,
            subitem: fullWidthItem,
            count: 2
        )
        compactGroup.interItemSpacing = .fixed(16)

        return compactGroup
    }

    private func lazyCompactOrphanGroup() -> NSCollectionLayoutGroup {
        let compactOrphanGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )

        return NSCollectionLayoutGroup.horizontal(
            layoutSize: compactOrphanGroupSize,
            subitem: fullWidthItem,
            count: 1
        )
    }

    private func lazyRegularGroup() -> NSCollectionLayoutGroup {
        let regularGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )

        return NSCollectionLayoutGroup.horizontal(
            layoutSize: regularGroupSize,
            subitem: fullWidthItem,
            count: 1
        )
    }
}
