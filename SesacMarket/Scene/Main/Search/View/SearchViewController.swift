//
//  SearchViewController.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit
import SkeletonView
import RxSwift

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
        
        let visibleIndexPaths = mainView.indexPathsForVisibleItems
        viewModel.checkWishItem(in: visibleIndexPaths) { [weak self] indexPath in
            self?.mainView.reloadItems(at: [indexPath])
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
        viewModel.sortButtonDidTapped(sort: sort) {
            self.mainView.reloadData()
        } onFailure: { error in
            self.showAlertMessage(title: "검색 실패", message: error.message)
        }
    }
}

// MARK: SearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        mainView.showAnimatedGradientSkeleton()
        
        viewModel.searchBarButtonDidTapped(searchBar.text) {
            self.mainView.stopSkeletonAnimation()
            self.mainView.hideSkeleton()

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

extension SearchViewController {
    
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

extension SearchViewController: SkeletonCollectionViewDataSource {
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SearchItemCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: SearchItemCell.identifier, for: indexPath)
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
        
        let collectionView = mainView.collectionView
        
        let offsetY = scrollView.contentOffset.y
        let deviceHeight = UIScreen.main.bounds.height
        guard scrollView.frame.size.height > 0 else { return }
        
        guard !viewModel.isLoading else { return }
        
        let isOffsetPrefetchable = offsetY + scrollView.frame.size.height >= scrollView.contentSize.height - (deviceHeight)
        
        if isOffsetPrefetchable {
            viewModel.prefetch() {
                self.viewModel.isLoading = false
                collectionView.reloadData()
            } onFailure: { error in
                self.showAlertMessage(title: "검색 실패", message: error.message)
            }
        }
    }
}
