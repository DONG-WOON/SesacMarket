//
//  BaseFlowLayout.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import UIKit

final class BaseCompositionalLayout: UICollectionViewCompositionalLayout {
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            var columnCount = 2
            
            switch environment.container.effectiveContentSize.width {
            case ..<500: // 아이폰 세로
                columnCount = 2
            case ..<1000: // 아이폰 가로, 아이패드 세로
                columnCount = 3
            default: // 아이패드 가로
                columnCount = 4
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let spacing = 10.0
            let edgeInset = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1.4 / CGFloat(columnCount)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            let supplementaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                               heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: supplementaryItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section.boundarySupplementaryItems = [header]
            
            section.contentInsets = edgeInset
            
            return section
        }
    }
    
    private func getColumn(for environment: NSCollectionLayoutEnvironment) {
        print(environment.traitCollection.horizontalSizeClass.rawValue, environment.traitCollection.verticalSizeClass.rawValue)
        
        //            switch environment.traitCollection.userInterfaceIdiom {
        //            case .phone:
        //            case .pad:
        //            default:
        //                return 1
        //            }
        
    }
}
