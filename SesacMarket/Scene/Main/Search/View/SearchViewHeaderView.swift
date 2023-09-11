//
//  ButtonView.swift
//  SesacMarket
//
//  Created by 서동운 on 9/10/23.
//

import UIKit

protocol SortButtonDelegate: AnyObject {
    func sortButtonDidTapped(_ sort: Sort)
}

class SearchViewHeaderView: UICollectionReusableView, UIConfigurable {

    weak var delegate: SortButtonDelegate?
    var currentSort: Sort?
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
        setAttributes()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchViewHeaderViewCell.self, forCellWithReuseIdentifier: SearchViewHeaderViewCell.identifier)
        
        addSubview(collectionView)
    }
    
    func setAttributes() {
        collectionView.allowsMultipleSelection = false
    }

    func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SearchViewHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Sort.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewHeaderViewCell.identifier, for: indexPath) as? SearchViewHeaderViewCell else { return UICollectionViewCell() }
    
        cell.update(sort: Sort.allCases[indexPath.row])
        
        if indexPath.item == currentSort?.rawValue {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
}

extension SearchViewHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sort = Sort(rawValue: indexPath.item) else { return }
        
        if currentSort != sort {
            currentSort = sort
            delegate?.sortButtonDidTapped(sort)
        }
    }
}

extension SearchViewHeaderView {
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
