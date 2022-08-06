//
//  NestedCell.swift
//  CompositionalLayoutPractice
//
//  Created by 三浦　一真 on 2022/08/05.
//

import UIKit

class NestedGroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!

    func update(text: String) {
        label.text = text
    }
}
