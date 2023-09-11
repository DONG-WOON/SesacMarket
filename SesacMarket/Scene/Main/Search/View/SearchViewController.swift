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
        
        let visibleIndexPaths = mainView.collectionView.indexPathsForVisibleItems
        viewModel.checkWishItem(in: visibleIndexPaths) { [weak self] indexPath in
            self?.mainView.collectionView.reloadItems(at: [indexPath])
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
        
        viewModel.fetchItem(search: searchBar.text) {
            self.mainView.collectionView.reloadData()
        } onFailure: { error in
            self.showAlertMessage(title: "검색 실패", message: error.message)
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: CollectionView

extension SearchViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchViewHeaderView.identifier, for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCell.identifier, for: indexPath) as? SearchItemCell else { return UICollectionViewCell() }
       
        viewModel.checkWishItem(in: [indexPath])
        
        cell.update(item: viewModel.items[indexPath.item])
        
        cell.wishButtonAction = { [weak self] in
            do {
                try self?.viewModel.wishButtonAction(in: indexPath)
            } catch {
                self?.showAlertMessage(title: "저장 오류", message: error.message)
                return
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
        
        print("🔥")
    }
}

// MARK: Prefetch

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    }
    
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        viewModel.cancelPrefetch(in: indexPaths)
    }
}
