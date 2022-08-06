//
//  CollctionView+.swift
//  CompositionalLayoutPractice
//
//  Created by 三浦　一真 on 2022/08/05.
//

import Foundation
import UIKit

extension NSObjectProtocol {

    static var className: String {
        return String(describing: self)
    }

}

extension UICollectionViewCell {

    static var identifier: String {
        return className
    }

}

extension UICollectionView {

    func registerCustomCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(
            UINib(nibName: T.identifier, bundle: nil),
            forCellWithReuseIdentifier: T.identifier
        )
    }

    func dequeueReusableCustomCell<T: UICollectionViewCell>(with cellType: T.Type,
                                                            indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier,
                                   for: indexPath) as! T
    }

}
