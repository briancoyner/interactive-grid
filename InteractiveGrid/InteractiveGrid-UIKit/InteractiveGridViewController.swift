import Foundation
import UIKit
import SwiftUI
import Algorithms

/// This view controller presents a `UICollectionView` driven by an array of `Model`s, where each
/// `Model` provides an `Int` value and a `Model.Style` (compact or regular).
///
/// The goal is to use stock `UICollectionView` API to build a re-orderable grid view of cells backed by
/// a "model" that supports displaying "compact" and "regular" content.
///
/// Stock API that you'll see here:
/// - `UICollectionViewDiffableDataSource`
/// - Compositional layout APIs (e.g. `NSCollectionLayoutGroup`)
/// - `UIContextMenuConfiguration` for presenting a context menu on a cell
///
/// Honestly, putting this together was a like a crazy game of whack-a-mole. There are so many ways to do
/// the same thing that it feels like nothing quite works as expected. For example, `UICollectionView`
/// has the ability to re-order elements, but that doesn't work directly with a diffable data source. Instead
/// the diffable data source takes control of reordering. But... then the cells don't seem to know that a reorder
/// is in flight.
///
/// There are various notes sprinkled throughout this implementation about things that confused me or that I think are just
/// downright broken.
///
/// The end result is a collection view that works about 95% percent of the time as expected by just using the combination
/// of stock UIKit API.
final class InteractiveGridViewController: UIViewController {

    /// Mutable collection of `Model`s.
    var models: [Model] {
        get {
            return dataSource.snapshot().itemIdentifiers
        }

        set {
            var snapshot = dataSource.snapshot()
            snapshot.deleteAllItems()

            if newValue.count > 0 {
                snapshot.appendSections([.main])
                snapshot.appendItems(newValue, toSection: .main)
            }

            dataSource.apply(snapshot)
        }
    }

    private lazy var dataSource = lazyDataSource()
    private lazy var collectionView = lazyCollectionView()

    private lazy var layoutGroupProvider = lazyDynamicLayoutGroupProvider()

    // Represents a snapshot of how the items/ cells will be placed when
    // the reorder drag operation completes. This snapshot is used to dynamically
    // layout the items/ cells based on their style (compact or regular).
    private var proposedDragItems: [Model]? = nil
}

// MARK: View Life Cycle

extension InteractiveGridViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        enableReorderSupport(on: dataSource)

        add(collectionView, to: view)
        configure(collectionView)
    }
}

// MARK: UICollectionViewDragDelegate

extension InteractiveGridViewController: UICollectionViewDragDelegate {

    func collectionView(
        _: UICollectionView,
        itemsForBeginning _: UIDragSession,
        at _: IndexPath
    ) -> [UIDragItem] {

        // There really is not any reason to clear this here because the method below will constantly
        // update this property. It's here just to document that no `proposedDragItems` should exist
        // when a drag begins.
        proposedDragItems = nil

        // Point of confusion:
        //
        // The data source handles setting up the drag item via its reordering
        // support via the diffable data source.
        //
        // This method is a required method on `UICollectionViewDragDelegate`. It simply returns an empty
        // array of `UIDragItem`s, and lets the diffable data source drive the drag items.
        return []
    }

    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {

        if destinationIndexPath == nil {
            print("%%%% Cancelling")
            return UICollectionViewDropProposal(operation: .cancel)
        } else {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
    }

    func collectionView(
        _: UICollectionView,
        targetIndexPathForMoveOfItemFromOriginalIndexPath originalIndexPath: IndexPath,
        atCurrentIndexPath currentIndexPath: IndexPath,
        toProposedIndexPath proposedIndexPath: IndexPath
    ) -> IndexPath {

        let draggedItem = dataSource.itemIdentifier(for: originalIndexPath)
        let currentItem = dataSource.itemIdentifier(for: currentIndexPath)
        let proposedItem = dataSource.itemIdentifier(for: proposedIndexPath)

        print("\n##### \(draggedItem!); \(currentItem!); \(proposedItem!)")
        print("##### \(originalIndexPath.item); \(currentIndexPath.item); \(proposedIndexPath.item)")
        print("##### \(dataSource.snapshot().itemIdentifiers)")

        // Point of confusion:
        //
        // I guess it's fine that `UICollectionView` constantly calls this method even if the target index
        // path hasn't actually changed. This guard here ensures that we are not doing more work than needed
        // when the user is just dragging over the same index path.
        guard currentItem != proposedItem else {
            return proposedIndexPath
        }

        let (proposedDragItems, dropIndex) = type(of: layoutGroupProvider).deriveProposedDragStateChange(
            forDraggingIndex: originalIndexPath.item,
            atCurrentIndex: currentIndexPath.item,
            toProposedDropIndex: proposedIndexPath.item,
            models: dataSource.snapshot().itemIdentifiers
        )

        self.proposedDragItems = proposedDragItems
        print("%%%% \(dropIndex), \(proposedDragItems)")
        return IndexPath(item: dropIndex, section: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        dragPreviewParametersForItemAt indexPath: IndexPath
    ) -> UIDragPreviewParameters? {

        // See the comments in the private `makePreviewParameters(forCell:)` method for
        // more details.
        return previewParameters(forItemAt: indexPath, collectionView: collectionView)
    }
}

// MARK: UICollectionViewDropDelegate

extension InteractiveGridViewController: UICollectionViewDropDelegate {

    func collectionView(_: UICollectionView, performDropWith _: UICollectionViewDropCoordinator) {
        // Note: This is a required `UICollectionViewDropDelegate` method.
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        // Note: This callback executes even if the drop is cancelled.
        proposedDragItems = nil
    }

    func collectionView(
        _ collectionView: UICollectionView,
        dropPreviewParametersForItemAt indexPath: IndexPath
    ) -> UIDragPreviewParameters? {

        // See the comments in the private `makePreviewParameters(forCell:)` method for more details.
        return previewParameters(forItemAt: indexPath, collectionView: collectionView)
    }
}

// MARK: UICollectionViewDelegate - Menu Support

extension InteractiveGridViewController: UICollectionViewDelegate {

    func collectionView(
        _: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point _: CGPoint
    ) -> UIContextMenuConfiguration? {

        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }

        // Point of confusion:
        //
        // The good thing is that I really want a context menu to appear when the user long
        // presses on a cell.
        //
        // Here's where things get confusing. For some reason the `UICollectionView` really
        // needs this delegate method to be implemented and to return a non-`nil`
        // `UIContextMenuConfiguration` (even if the there are not any menus). If this is not
        // implemented then, when lifting the cell to start a drag operation, the cell becomes
        // transparent (not what I want).
        //
        // So why does the cell become transparent? It's because the `GridCell` tracks the
        // "lift" and "dragging" state. This is where the game of whack-a-mole continues.
        // The `UICollectionView`'s reordering support does "lift" the selected view, which looks
        // nice, but there's a remnant of the view that stays around until the user drags
        // far enough to warrant the collection view to hide/ remove this remnant view.
        // To compensate for this, the `GridCell` sets the cell's content view's opacity to
        // zero during a "lift" and "drag".
        //
        // For some reason, if a non-`nil` `UIContextMenuConfiguration` is returned, then the
        // "lifted" cell remains visible (i.e. the lifted view's opacity is carried forward to
        // "lifted" cell.
        //
        // In summary... to get things to work with the lift and drag, a non-`nil` `UIContextMenuConfiguration`
        // is always returned but it may not actually have a `UIMenu` to display.
        //
        // See `makeContextMenu(item:)`.

        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil,
            actionProvider: { [weak self] _ in
                return self?.makeContextMenu(item: item)
            }
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {

        return makeTargetedPreview(withConfiguration: configuration, collectionView: collectionView)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {

        return makeTargetedPreview(withConfiguration: configuration, collectionView: collectionView)
    }

    private func makeTargetedPreview(
        withConfiguration configuration: UIContextMenuConfiguration,
        collectionView: UICollectionView
    ) -> UITargetedPreview? {

        guard let indexPath = configuration.identifier as? IndexPath else {
            return nil
        }

        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return nil
        }

        return UITargetedPreview(view: cell, parameters: makePreviewParameters(forCell: cell))
    }

    private func makeContextMenu(item: Model) -> UIMenu? {

        // Point of confusion: The collection view appears to render the lifted view correctly
        // only if there is a menu configuration (even if that menu doesn't have any actions).
        //
        // The `UIContextMenuConfiguration` appears to be fine with a `nil` `UIMenu`, which
        // is good because this seems to fix a `UICollectionView` "lift preview" bug.
        guard item.allowsContextMenu else {
            return nil
        }

        return UIMenu(children: [
            makeActionToAddCompactItem(afterItem: item, in: dataSource),
            makeActionToAddRegularItem(afterItem: item, in: dataSource),
            makeAction(toRemove: item, from: dataSource)
        ])
    }

    private func makeActionToAddModel(
        withStyle style: Model.Style,
        afterItem: Model,
        in dataSource: UICollectionViewDiffableDataSource<InteractiveGridViewController.Section, Model>
    ) -> UIAction {

        return UIAction(
            title: "Add \(style.description) After",
            image: UIImage(systemName: style.symbolName),
            attributes: []
        ) { [dataSource] _ in

            var snapshot = dataSource.snapshot()

            let model = Model(value: snapshot.numberOfItems + 1, style: style, allowsContextMenu: true)
            snapshot.insertItems([model], afterItem: afterItem)
            dataSource.apply(snapshot)
        }
    }

    private func makeActionToAddCompactItem(
        afterItem: Model,
        in dataSource: UICollectionViewDiffableDataSource<InteractiveGridViewController.Section, Model>
    ) -> UIAction {

        return makeActionToAddModel(withStyle: .compact, afterItem: afterItem, in: dataSource)
    }

    private func makeActionToAddRegularItem(
        afterItem: Model,
        in dataSource: UICollectionViewDiffableDataSource<InteractiveGridViewController.Section, Model>
    ) -> UIAction {

        return makeActionToAddModel(withStyle: .regular, afterItem: afterItem, in: dataSource)
    }

    private func makeAction(
        toRemove item: Model,
        from dataSource: UICollectionViewDiffableDataSource<InteractiveGridViewController.Section, Model>
    ) -> UIAction {

        return UIAction(
            title: "Remove",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { [dataSource] _ in

            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([item])
            dataSource.applySnapshotUsingReloadData(snapshot)
        }
    }
}

// MARK: Private Helpers To Create `UIPreviewParameters` (lift, drag, and drop)

extension InteractiveGridViewController {

    private func previewParameters(
        forItemAt indexPath: IndexPath,
        collectionView: UICollectionView
    ) -> UIDragPreviewParameters? {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return nil
        }

        return makePreviewParameters(forCell: cell)
    }

    private func makePreviewParameters<P: UIPreviewParameters>(forCell cell: UICollectionViewCell) -> P {

        // The `GridCell` uses a rounded rectangle. As of iOS 15, we must tell the collection view
        // how to render the preview by the setting the `shadowPath` and `visiblePath`.
        //
        // If this is not done then the preview view will not show rounded corners when the view
        // is lifted, dragged, and eventually dropped.

        let previewParameters = P()
        previewParameters.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius)
        previewParameters.visiblePath = previewParameters.shadowPath
        previewParameters.backgroundColor = .clear

        return previewParameters
    }
}

// MARK: Compositional Layout Set Up

extension InteractiveGridViewController {

    private func makeDynamicCollectionViewLayout() -> UICollectionViewLayout {

        // Our design requires dynamically adjusting the layout based on the current
        // array of `Model`s. Therefore, we use the `UICollectionViewCompositionalLayout/sectionProvider`
        // API to dynamically generate the layout based on the `proposedDragItems`
        // (if dragging) or the diffable data source (if not dragging).
        //
        // This method is called a lot during dragging. The collection view seems to
        // quickly handle changes without hitches.

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.contentInsetsReference = .readableContent

        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] _, _ in
            guard let self = self else {
                return nil
            }

            // This is the where the magic happens to get the collection view cells to move
            // around as the user drags a lifted cell.
            let items = self.proposedDragItems ?? self.dataSource.snapshot().itemIdentifiers
            let styles = items.map { $0.style }
            print("%%%% LAYOUT: \(items)")
            if styles.isEmpty {
                return nil
            }
            return self.makeSection(for: styles)
        }, configuration: configuration)
    }

    private func makeSection(for styles: [Model.Style]) -> NSCollectionLayoutSection {

        var groups: [NSCollectionLayoutItem] = []

        var previousStyle: Model.Style? = nil
        for index in 0..<styles.count {
            let currentStyle = styles[index]
            let nextStyle = (index == styles.count - 1) ? nil: styles[index + 1]

            // The real magic for dynamically adjusting the layout happens in the
            // `DynamicLayoutGroupProvider`, which is a custom type specific to this
            // demo.
            //
            // The provider extracts the logic needed to dynamically generate the layout group
            // into a unit testable data structure, which is nice.
            let proposedLayoutGroup = layoutGroupProvider.deriveLayoutGroup(
                basedOnPreviousStyle: previousStyle,
                currentStyle: currentStyle,
                nextStyle: nextStyle
            )

            if let layoutGroup = proposedLayoutGroup {
                groups.append(layoutGroup)
                previousStyle = currentStyle
            } else {
                previousStyle = nil
            }
        }

        return makeSection(forGroup: makeOuterGroup(forSubitems: groups))
    }

    private func makeSection(forGroup group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16)

        return section
    }

    private func makeOuterGroup(forSubitems subitems: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let outerGroup = NSCollectionLayoutGroup.vertical(layoutSize: outerGroupSize, subitems: subitems)
        outerGroup.interItemSpacing = .fixed(16)

        return outerGroup
    }

    private func lazyDynamicLayoutGroupProvider() -> DynamicLayoutGroupProvider {
        return DefaultDynamicLayoutGroupProvider()
    }
}

// MARK: Diffable Data Source Set Up

extension InteractiveGridViewController {

    private func lazyDataSource() -> UICollectionViewDiffableDataSource<Section, Model> {

        let cellRegistration = makeCellRegistration()
        return UICollectionViewDiffableDataSource<Section, Model>(collectionView: collectionView) { (collectionView, indexPath, identifier) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }

    private func makeCellRegistration() -> UICollectionView.CellRegistration<GridCollectionViewCell, Model> {
        return UICollectionView.CellRegistration<GridCollectionViewCell, Model> { (cell, indexPath, model) in
            cell.contentConfiguration = UIHostingConfiguration {
                GridCell(model: model)
            }
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(uiColor: .systemBackground))
            }

            // The cell's contentView `CALayer` corner radius is set to the same radius as the background to ensure
            // that the "drag preview" background does not show through.
            cell.contentView.layer.cornerRadius = 16
        }
    }
}

// MARK: UICollectionView Set Up

extension InteractiveGridViewController {

    private func lazyCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: makeDynamicCollectionViewLayout())
    }

    private func add(_ collectionView: UICollectionView, to view: UIView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func configure(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = .clear

        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }
}

// MARK: Diffable Data Source Reorder Support

extension InteractiveGridViewController {

    private func enableReorderSupport(on dataSource: UICollectionViewDiffableDataSource<Section, Model>) {
        dataSource.reorderingHandlers.canReorderItem = { _ in
            // All items are eligible for reordering.
            return true
        }

        dataSource.reorderingHandlers.didReorder = { [weak self] value in

            // Point of confusion:
            //
            // If this callback is not set, then the data source appears to
            // ignore the drop and puts the items back in the pre-drag state.
            // Bug? I don't know. There's no documentation.

            // Now that the drag is finished, the `proposedDragItems` are cleared.
            // New items are set when the user starts dragging again.
            self?.proposedDragItems = nil

            print("%%%% (drop complete) \(value.finalSnapshot.itemIdentifiers)")

//            self?.collectionView.collectionViewLayout.invalidateLayout()
            // TODO: "coding by coincidence": This was hacked in to see if it would help the collection view
            // correctly handle the situation where a "compact leading" is dragged down to a "regular". The
            // unit test should what should happen. This seems to force the view to behave correctly, but it's
            // very hacky (more investigation needed). 
//            self?.collectionView.reloadData()
        }
    }
}

extension InteractiveGridViewController {

    private enum Section {
        case main
    }
}
