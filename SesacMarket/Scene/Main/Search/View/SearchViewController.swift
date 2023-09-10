//
//  SearchViewController.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    let viewModel: SearchViewModel
    let mainView = BaseView(scene: .search)
    
    var prefetchingIndexPaths: [IndexPath: Cancelable] = [:]
    
    init(viewModel: SearchViewModel) {
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
        
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !viewModel.items.isEmpty {
            mainView.collectionView.indexPathsForVisibleItems.forEach { indexPath in
                viewModel.checkWishItem(indexPath: indexPath)
                mainView.collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    override func configureViews() {
        mainView.searchBar.delegate = self
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        mainView.collectionView.register(SearchItemCell.self, forCellWithReuseIdentifier: SearchItemCell.identifier)
        mainView.collectionView.register(SearchViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchViewHeaderView.identifier)
    }
}

// MARK: SearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // ⭐️ TO DO: 텍스트 validate ⭐️
        viewModel.items.removeAll()
        
        viewModel.getItem(search: searchBar.text!) {
            // 노티나 다른걸로 전달하기
            self.mainView.collectionView.reloadData()
            
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        
        return true
    }
}

// MARK: CollectionView

extension SearchViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BaseButtonsView.identifier, for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCell.identifier, for: indexPath) as? SearchItemCell else { return UICollectionViewCell() }
        let item = viewModel.items[indexPath.item]
        // ⭐️ TO DO: 필터 기능으로 변경하기 ⭐️
        //        print(indexPath, "cellForRowAt")
        if viewModel.repository.fetchFilter(item).count != 0 {
            viewModel.items[indexPath.item].isWished = true
        }
        
        cell.update(item: viewModel.items[indexPath.item])
        
        cell.wishButtonAction = { [weak self] in
            guard let self else { return }
            self.viewModel.items[indexPath.item].isWished.toggle()
            // 다르게 구현
            if self.viewModel.items[indexPath.item].isWished {
                do {
                    try self.viewModel.addWish(viewModel.items[indexPath.item])
                } catch {
                    print("관심 추가 에러")
                }
            } else {
                self.viewModel.removeWish(item)
            }
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        viewModel.checkWishItem(indexPath: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        viewModel.checkWishItem(indexPath: indexPath)
    }
    
}


extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ⭐️ TO DO: 웹뷰 ⭐️
        
        print("🔥 ")
    }
}

// MARK: Prefetch

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {

//            viewModel.checkWishItem(indexPath: indexPath)
//
//            if indexPath.item == viewModel.items.count - 15 {
//                viewModel.page += 1
//
//                let searchText = mainView.searchBar.text!
//                prefetchingIndexPaths[indexPath] = viewModel.getItem(search: searchText) {
//                    collectionView.reloadData()
//                }
//                print(indexPath, "prefetch 지금")
//            }
        }
        
        
    }
    
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            prefetchingIndexPaths[indexPath]?.cancel()
            print(indexPath, "cancel")
        }
    }
}
