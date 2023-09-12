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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchWish() {
            mainView.collectionView.reloadData()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(WishItemCell.self, forCellWithReuseIdentifier: WishItemCell.identifier)
    }
}

// MARK: SearchBar Delegate

extension WishViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchText = searchBar.text
        viewModel.fetchWish {
            mainView.collectionView.reloadData()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        searchBar.resignFirstResponder()
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchText = nil
        viewModel.fetchWish {
            mainView.collectionView.reloadData()
        }
        searchBar.endEditing(true)
    }
}

// MARK: CollectionView

extension WishViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.wishItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishItemCell.identifier, for: indexPath) as? WishItemCell else { return UICollectionViewCell() }
        let item = viewModel.wishItems[indexPath.item]
        cell.update(item: item)
        
        cell.wishButtonAction = { [weak self] in
            do {
                try self?.viewModel.removeWish(item)
                collectionView.reloadData()
            } catch {
                self?.showAlertMessage(title: "삭제 실패", message: (error as? SesacError)?.message)
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mainView.searchBar.searchTextField.isEditing {
            mainView.searchBar.endEditing(true)
        }
    }
}

extension WishViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainView.searchBar.endEditing(true)
        let item = viewModel.wishItems[indexPath.item]
        let vc = DetailViewController(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}
