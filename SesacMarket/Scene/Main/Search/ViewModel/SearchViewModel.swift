//
//  SearchViewModel.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation
import Combine

final class SearchViewModel: ValidateTextProtocol {
    // ⭐️ TO DO: usecase추가  ⭐️
    
    var items: [Item] = []
    var page = 1
    var sort: Sort = .sim
    
    var prefetchingIndexPaths: [IndexPath: Cancelable?] = [:]
    
    @discardableResult
    func fetchItem(search: String?, completion: @escaping () -> Void, onFailure: @escaping (Error) -> Void) -> Cancelable? {
        items.removeAll()
        let result = validate(text: search)
        switch result {
        case .success(let search):
            return APIManager.shared.request(search: search, page: page, sort: sort)
            { [weak self] items in
                guard let self else { return }
                self.items.append(contentsOf: items)
                completion()
            } onFailure: { error in
                onFailure(error)
            }
        case .failure(let error):
            onFailure(error)
            return nil
        }
    }
    
    func cancelPrefetch(in indexPaths: [IndexPath]) {
        if !prefetchingIndexPaths.isEmpty {
            for indexPath in indexPaths {
                prefetchingIndexPaths[indexPath]??.cancel()
            }
        }
    }
    
    
    // repository
    func addWish(_ item: Item) throws {
        try WishItemEntityRepository.shared.createItem(WishItemEntity(domain: item))
    }
    
    func removeWish(_ item: Item) {
        guard let wishItemEntity = WishItemEntityRepository.shared.fetchItem(WishItemEntity.self, forPrimaryKeyPath: item.productID) else { return }
        WishItemEntityRepository.shared.deleteItem(wishItemEntity)
    }
    
    func checkWishItem(in indexPaths: [IndexPath], completion: ((IndexPath) -> Void)? = nil) {
        guard !items.isEmpty else { return }
        
        for indexPath in indexPaths {
            let item = items[indexPath.item]
            let wishItem = WishItemEntityRepository.shared.fetchItem(WishItemEntity.self, forPrimaryKeyPath: item.productID)
            
            items[indexPath.item].isWished = wishItem != nil ? true : false
            completion?(indexPath)
        }
    }
    
    func wishButtonAction(in indexPath: IndexPath) throws {
        items[indexPath.item].isWished.toggle()
        let item = items[indexPath.item]
        
        if item.isWished {
            do {
                try addWish(item)
            } catch {
                throw RepositoryError.saveError
            }
        } else {
            removeWish(item)
        }
    }
}
