//
//  SearchViewModel.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation
import Combine

final class SearchViewModel: ValidateTextProtocol {
   
    var items: [Item] = []
    var page = 1
    var sort: Sort = .sim
    var searchString: String?
    var isLoading = false
    
    func fetchItem(onSuccess: @escaping () -> Void, onFailure: @escaping (SesacError) -> Void) {
        let result = validate(text: searchString)
        switch result {
        case .success(let search):
            APIManager.shared.request(search: search, page: page, sort: sort) { [weak self] result in
                switch result {
                case .success(let items):
                    guard let self else { return }
                    if items.isEmpty {
                        onFailure(.invalidQuery)
                        return
                    }
                    
                    let fetchedItemsLastID = items.last?.productID
                    let currentItemsLastID = self.items.last?.productID
                    
                    if fetchedItemsLastID == currentItemsLastID {
                        return
                    }
                    
                    self.items.append(contentsOf: items)
                    
                    onSuccess()
                case .failure(let error):
                    onFailure(error)
                }
            }
        case .failure(let error):
            onFailure(error)
        }
    }
    
    func addWish(_ item: Item) throws {
        try WishItemEntityRepository.shared.createItem(item)
    }
    
    func removeWish(_ item: Item) throws {
        try WishItemEntityRepository.shared.deleteItem(item)
    }
    
    func checkWishItem(in indexPaths: [IndexPath], completion: ((IndexPath) -> Void)? = nil) {
        guard !items.isEmpty else { return }
        
        for indexPath in indexPaths {
            let item = items[indexPath.item]
            let wishItem = WishItemEntityRepository.shared.fetchWishItem(forPrimaryKeyPath: item.productID)
            
            items[indexPath.item].isWished = wishItem != nil ? true : false
            completion?(indexPath)
        }
    }
    
    func wishButtonAction(in indexPath: IndexPath) throws {
        items[indexPath.item].isWished.toggle()
        let item = items[indexPath.item]
        
        if item.isWished {
            try addWish(item)
        } else {
            try removeWish(item)
        }
    }
    
    func searchBarButtonDidTapped(_ searchText: String?, onSuccess: @escaping () -> Void, onFailure: @escaping (SesacError) -> Void) {
        
        isLoading = false
        reset()
        searchString = searchText
        
        fetchItem(onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func sortButtonDidTapped(sort: Sort, onSuccess: @escaping () -> Void, onFailure: @escaping (SesacError) -> Void) {
        self.sort = sort
        guard !items.isEmpty else { return }
        reset()
        
        fetchItem(onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func prefetch(onSuccess: @escaping () -> Void, onFailure: @escaping (SesacError) -> Void) {
        isLoading = true
        guard !items.isEmpty else { return }
       
        page += 1
        fetchItem(onSuccess: onSuccess, onFailure: onFailure)
    }
    
    private func reset() {
        items.removeAll()
        page = 1
    }
}
