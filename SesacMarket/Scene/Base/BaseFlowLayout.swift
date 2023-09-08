//
//  BaseFlowLayout.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import UIKit

final class BaseCompositionalLayout: UICollectionViewCompositionalLayout {
    
    init() {
        let inset = 5.0
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        // ⭐️ TO DO: 다이나믹 사이즈 이슈 ⭐️
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        super.init(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

