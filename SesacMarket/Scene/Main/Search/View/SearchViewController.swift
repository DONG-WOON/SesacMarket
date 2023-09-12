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
        super.configureViews()
        
        mainView.searchBar.delegate = self
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        mainView.collectionView.register(SearchItemCell.self, forCellWithReuseIdentifier: SearchItemCell.identifier)
        mainView.collectionView.register(SearchViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchViewHeaderView.identifier)
    }
}

// MARK: SortButton Delegate

extension SearchViewController: SortButtonDelegate {
    func sortButtonDidTapped(_ sort: Sort) {
        viewModel.sort = sort
        guard !viewModel.items.isEmpty else { return }
        viewModel.items.removeAll()
        viewModel.page = 1
        viewModel.fetchItem() {
            self.mainView.collectionView.reloadData()
        } onFailure: { error in
            self.showAlertMessage(title: "검색 실패", message: error.message)
        }
    }
}

// MARK: SearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isLoading = false
        viewModel.page = 1
        viewModel.items.removeAll()
        viewModel.searchString = searchBar.text
        searchBar.endEditing(true)
        viewModel.fetchItem() {
            self.mainView.collectionView.reloadData()
            if !self.viewModel.items.isEmpty {
                self.mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: true)
            }
        } onFailure: { error in
            self.showAlertMessage(title: "검색 실패", message: error.message)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: CollectionView

extension SearchViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchViewHeaderView.identifier, for: indexPath) as? SearchViewHeaderView else { return UICollectionReusableView() }
        headerView.currentSort = viewModel.sort
        headerView.delegate = self
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
                self?.showAlertMessage(title: "저장 오류", message: (error as? SesacError)?.message)
                return
            }
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
}


extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainView.searchBar.endEditing(true)
        let item = viewModel.items[indexPath.item]
        let vc = DetailViewController(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Prefetch

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mainView.searchBar.searchTextField.isEditing {
            mainView.searchBar.endEditing(true)
        }
        
        let offsetY = scrollView.contentOffset.y
        let collectionView = mainView.collectionView
        let deviceHeight = UIScreen.main.bounds.height
        guard scrollView.frame.size.height > 0 else { return }
        
        guard !viewModel.isLoading else { return }
        
        if offsetY + scrollView.frame.size.height >= scrollView.contentSize.height - (deviceHeight) {
            viewModel.isLoading = true
            guard !viewModel.items.isEmpty else { return }
           
            viewModel.page += 1
            viewModel.fetchItem() {
                self.viewModel.isLoading = false
                collectionView.reloadData()
            } onFailure: { error in
                self.showAlertMessage(title: "검색 실패", message: error.message)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        viewModel.cancelPrefetch(in: indexPaths)
    }
}
