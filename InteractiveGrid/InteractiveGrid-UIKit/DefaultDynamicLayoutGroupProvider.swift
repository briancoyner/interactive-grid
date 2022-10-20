import Foundation
import UIKit

final class DefaultDynamicLayoutGroupProvider: DynamicLayoutGroupProvider {

    private lazy var compactGroupSize = lazyCompactGroupSize()
    private lazy var compactOrphanGroupSize = lazyCompactOrphanGroupSize()
    private lazy var regularGroupSize = lazyRegularGroupSize()

    private lazy var compactWidthLayoutItem = lazyCompactWidthLayoutItem()
    private lazy var fullWidthLayoutItem = lazyFullWidthLayoutItem()

    private lazy var compactGroup = lazyCompactGroup()
    private lazy var compactOrphanGroup = lazyCompactOrphanGroup()
    private lazy var regularGroup = lazyRegularGroup()
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

    private func lazyCompactGroup() -> NSCollectionLayoutGroup {
        let compactGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: compactGroupSize,
            repeatingSubitem: compactWidthLayoutItem,
            count: 2
        )
        compactGroup.interItemSpacing = .fixed(16)

        return compactGroup
    }

    private func lazyCompactOrphanGroup() -> NSCollectionLayoutGroup {
        return NSCollectionLayoutGroup.horizontal(
            layoutSize: compactOrphanGroupSize,
            repeatingSubitem: fullWidthLayoutItem,
            count: 1
        )
    }

    private func lazyRegularGroup() -> NSCollectionLayoutGroup {
        return NSCollectionLayoutGroup.horizontal(
            layoutSize: regularGroupSize,
            repeatingSubitem: fullWidthLayoutItem,
            count: 1
        )
    }
}

extension DefaultDynamicLayoutGroupProvider {

    private func lazyCompactWidthLayoutItem() -> NSCollectionLayoutItem {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )

        return NSCollectionLayoutItem(layoutSize: layoutSize)
    }

    private func lazyFullWidthLayoutItem() -> NSCollectionLayoutItem {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        return NSCollectionLayoutItem(layoutSize: layoutSize)
    }
}

extension DefaultDynamicLayoutGroupProvider {

    private func lazyCompactGroupSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
    }

    private func lazyCompactOrphanGroupSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )
    }

    private func lazyRegularGroupSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
    }
}
