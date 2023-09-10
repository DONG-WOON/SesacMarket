//
//  ButtonView.swift
//  SesacMarket
//
//  Created by 서동운 on 9/10/23.
//

import UIKit

class BaseButtonsView: UICollectionReusableView, UIConfigurable {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureViews() {
        collectionView.dataSource = self
        collectionView.register(BaseButtonsViewCell.self, forCellWithReuseIdentifier: BaseButtonsViewCell.identifier)
        
        addSubview(collectionView)
    }

    func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension BaseButtonsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Sort.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseButtonsViewCell.identifier, for: indexPath) as? BaseButtonsViewCell else { return UICollectionViewCell() }
        cell.update(title: Sort.allCases[indexPath.row].title)
        return cell
    }
}

extension BaseButtonsView {
    func layout() -> UICollectionViewCompositionalLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(20),
                                               heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(20),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.interItemSpacing = .fixed(5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
}
