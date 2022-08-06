//
//  ViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 三浦　一真 on 2022/08/05.
//

import UIKit

class NestedGroupCollectionViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case main
    }

    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Nested Groups"
        configureHierarchy()
    }

    func configureHierarchy() {
        // UICollectionViewの初期化時に createLayout() を渡しているが、collectionView の invalidateLayout() が呼ばれると createLayout() も呼ばれるので、画面回転時には今まで通りinvalidateLayout()を呼んであげれば再計算してくれる
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.registerCustomCell(NestedGroupCollectionViewCell.self)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func createLayout() -> UICollectionViewLayout {
        let sideInset: CGFloat = 18
        let insideInset: CGFloat = 8
        let topInset: CGFloat = 8
        let viewWidth: CGFloat = view.bounds.width
        let smallSquareWidth: CGFloat = (viewWidth - (sideInset * 2 + insideInset * 2)) / 3
        let mediumSquareWidth: CGFloat = smallSquareWidth * 2 + insideInset
        let nestedGroupHeight: CGFloat = mediumSquareWidth + topInset
        let smallSquareGroupHeight: CGFloat = smallSquareWidth + topInset

        // ここでUICollectionViewCompositionalLayoutを作成し返却する
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            // 各レイアウトの定義
            // セクションAの定義
            let nestedGroupTypeA: NSCollectionLayoutGroup = {
                let smallSquareItem = NSCollectionLayoutItem(
                    // fractionalWidth -> 比率
                    // .absolute -> 絶対値での指定
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(smallSquareWidth + insideInset)))
                smallSquareItem.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: insideInset)
                let smallSquareGroup = NSCollectionLayoutGroup.vertical(
                    // 縦に2つのitemを並べる
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(smallSquareWidth + insideInset),
                                                      heightDimension: .fractionalHeight(1.0)),
                    subitem: smallSquareItem, count: 2)

                // itemの2倍の大きさの正方形を配置
                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(mediumSquareWidth),
                                                      heightDimension: .fractionalHeight(1.0)))
                mediumSquareItem.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: 0)

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(nestedGroupHeight)),
                    // ここで並べる順番が決まる(左から順に並べる)
                    subitems: [smallSquareGroup, mediumSquareItem])
                return nestedGroup
            }()

            let nestedGroupTypeB: NSCollectionLayoutGroup = {
                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(mediumSquareWidth + insideInset),
                                                      heightDimension: .fractionalHeight(1.0)))
                mediumSquareItem.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: insideInset)

                let smallSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(smallSquareWidth + insideInset)))
                smallSquareItem.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: 0)
                let smallSquareGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(smallSquareWidth),
                                                      heightDimension: .fractionalHeight(1.0)),
                    subitem: smallSquareItem, count: 2)

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(nestedGroupHeight)),
                    subitems: [mediumSquareItem, smallSquareGroup])
                return nestedGroup
            }()

            let nestedGroupTypeC: NSCollectionLayoutGroup = {
                let smallSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(smallSquareWidth),
                                                      heightDimension: .fractionalHeight(1.0)))

                let smallSquareGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(smallSquareGroupHeight)),
                    subitem: smallSquareItem,
                    count: 3)
                smallSquareGroup.interItemSpacing = .fixed(insideInset)
                smallSquareGroup.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: 0)

                return smallSquareGroup
            }()

            let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(nestedGroupHeight * 2 + smallSquareGroupHeight * 2)),
            subitems: [nestedGroupTypeA, nestedGroupTypeC, nestedGroupTypeB, nestedGroupTypeC])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)
            return section

        }
        return layout
    }
}

extension NestedGroupCollectionViewController: UICollectionViewDelegate {}

extension NestedGroupCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 54
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Invalid section") }
        switch section {
        case .main:
            let cell = collectionView.dequeueReusableCustomCell(with: NestedGroupCollectionViewCell.self, indexPath: indexPath)
            cell.update(text: "\(indexPath.section), \(indexPath.row)")
            return cell
        }
    }
}
