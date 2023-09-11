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
    var searchString: String?
    var isLoading = false
    
    var prefetchingIndexPaths: [IndexPath: Cancelable?] = [:]
    
    @discardableResult
    // ⭐️ TO DO: 검색어를 중간에 지울경우 이슈 생김 ⭐️
    func fetchItem(completion: @escaping () -> Void, onFailure: @escaping (SesacError) -> Void) -> Cancelable? {
        let result = validate(text: searchString)
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
        try WishItemEntityRepository.shared.createItem(item)
    }
    
    func removeWish(_ item: Item) throws {
        guard let wishItemEntity = WishItemEntityRepository.shared.fetchWishItem(forPrimaryKeyPath: item.productID) else { return }
        do {
            try WishItemEntityRepository.shared.deleteItem(wishItemEntity)
        } catch {
            throw SesacError.doNotDelete
        }
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
            do {
                try addWish(item)
            } catch {
                throw SesacError.saveError
            }
        } else {
            do {
                try removeWish(item)
            } catch {
                throw SesacError.doNotDelete
            }
        }
    }
}
