# Building An Interactive Grid View

![Goals](goals.gif)

This demo shows a few techniques on how to build a re-ordable grid view based on stock `UICollectionView` API.

Here are the main UIKit APIs used by this demo:

- `UICollectionView`s compositional layout API.
- `UICollectionViewDiffableDataSource` and its built in reordering support.
- `UIContextMenuConfiguration` for presenting optional menus from each displayed cell.
  
The view is driven by a two-column layout that supports two cell sizes:
  
- Compact (half width)
- Regular (full width)
  
Other goals
- The layout must dynamically adjust while the user drags cells arounds.
- The user must be able to long-press on cell to present a standard iOS context menu.

Additional details can be found in this [blog post](https://briancoyner.github.io/articles/2021-10-12-reorderable-collection-view).
