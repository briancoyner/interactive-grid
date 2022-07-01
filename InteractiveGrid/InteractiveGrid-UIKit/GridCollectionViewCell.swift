import Foundation
import UIKit

/// A simple cell used to display `Model`s in the `InteractiveGridViewController`.
///
/// The `dragStateDidChange(_:)` method is overridden to alter the opacity of the
/// cell during drag state changes.
final class GridCollectionViewCell: UICollectionViewCell {

    private(set) lazy var label = lazyLabel()
    private(set) lazy var subtitle = lazySubtitle()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 16
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func dragStateDidChange(_ dragState: UICollectionViewCell.DragState) {

        // The docs say to call super to apply default behavior, but the
        // default behavior is not documented. Therefore, let's call super anyway
        // just to be sure we are not missing out on something.
        //
        // Note: Omitting this call appears to have zero negative impact.
        super.dragStateDidChange(dragState)

        // You'll notice that the cell's layer, not the `contentView`'s layer's opacity,
        // is changed. We need to affect the cell's opacity in order to improve the
        // drag/drop visual behavior we are looking to achieve. Specifically, when the drag
        // begins, we want this cell to disappear to make it look like we actually picked
        // up the view. If this is not done, then you'll see the lifted preview and this cell.
        //
        // Seems like this is something that `UICollectionView` should take care of automatically.
        // Perhaps it does, but I have yet to find the hook.
        switch dragState {
        case .lifting, .dragging:
            layer.opacity = 0
        case .none:
            layer.opacity = 1
        @unknown default:
            layer.opacity = 1
        }
    }
}

extension GridCollectionViewCell {

    private func lazyLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = .preferredFont(forTextStyle: .largeTitle)

        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        return label
    }

    private func lazySubtitle() -> UILabel {
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        subtitle.font = .preferredFont(forTextStyle: .footnote)

        contentView.addSubview(subtitle)
        NSLayoutConstraint.activate([
            subtitle.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: label.bottomAnchor)
        ])

        return subtitle
    }
}
