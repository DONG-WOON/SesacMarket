//
//  WishViewController.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit

final class WishViewController: BaseViewController {
    
    let viewModel: WishViewModel
    let mainView = BaseView(scene: .wish)
    
    init(viewModel: WishViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        mainView.collectionView.register(WishItemCell.self, forCellWithReuseIdentifier: WishItemCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ⭐️ TO DO: 매번 요청하는 것 바꾸는것 고려. ⭐️
        viewModel.fetchWish() {
            mainView.collectionView.reloadData()
        }
    }
}

// MARK: SearchBar Delegate

extension WishViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        
        return true
    }
}

// MARK: CollectionView

extension WishViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.wishItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishItemCell.identifier, for: indexPath) as? WishItemCell else { return UICollectionViewCell() }
        
        cell.update(item: viewModel.wishItems[indexPath.item])
        
        cell.wishButtonAction = { [weak self] in
            guard let item = self?.viewModel.wishItems[indexPath.item] else { return }
            let itemIsWished = item.isWished
            // 다르게 구현
            if itemIsWished {
                self?.viewModel.removeWish(item)
            }
            collectionView.reloadData()
        }
        
        return cell
    }
}

extension WishViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ⭐️ TO DO: 웹뷰 ⭐️
        
        print("🔥 ")
    }
}

// MARK: Prefetch

extension WishViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        if indexPaths.contains(where: { $0.item == viewModel.items.count - 1 }) {
//            viewModel.page += 1
//            viewModel.getItem(search: "캠핑카") {
//                collectionView.reloadData()
//            }
//        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        return
    }
}
