
import UIKit

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    // https://forums.swift.org/t/relying-on-string-describing-to-get-the-name-of-a-type/16391
    static var reuseIdentifier: String { NSStringFromClass(self) }
}

// MARK: - Table View convenience methods

public extension UITableView {
    func register<Cell>(_ cellType: Cell.Type) where Cell: UITableViewCell, Cell: Reusable {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeue<Cell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: UITableViewCell, Cell: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Cell class \(cellType.reuseIdentifier) is not registered in \(description)")
        }
        return cell
    }

    func dequeue<HeaderFooter>(_ type: HeaderFooter.Type) -> HeaderFooter where HeaderFooter: UITableViewHeaderFooterView,
                                                                                HeaderFooter: Reusable {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as? HeaderFooter else {
            fatalError("HeaderFooter class \(type.reuseIdentifier) is not registered in \(description)")
        }
        return cell
    }
}

// MARK: Collection View convenience methods

public extension UICollectionView {
    func register<Cell>(_ cellType: Cell.Type) where Cell: UICollectionViewCell, Cell: Reusable {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    func registerSupplementaryView<View>(_ viewType: View.Type, kind: String) where View: UICollectionReusableView, View: Reusable {
        register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.reuseIdentifier)
    }

    func dequeue<Cell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: UICollectionViewCell, Cell: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Cell class \(cellType.reuseIdentifier) is not registered in \(description)")
        }
        return cell
    }

    func dequeueSupplementaryView<View>(
        _ viewType: View.Type,
        kind: String,
        for indexPath: IndexPath
    ) -> View where View: UICollectionReusableView, View: Reusable {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath
        ) as? View else {
            fatalError("Supplementary View class \(viewType.reuseIdentifier) is not registered in \(description)")
        }
        return view
    }
}
