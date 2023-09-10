//
//  SearchViewModel.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation

final class SearchViewModel {
    let repository = WishItemEntityRepository()

    
    var items: [Item] = []
    var page = 1
    var sort: Sort = .sim
    
    @discardableResult
    func getItem(search: String, completion: @escaping () -> Void) -> Cancelable {
        return APIManager.shared.request(search: search, page: page, sort: sort)
        { [weak self] items in
            guard let self else { return }
            self.items.append(contentsOf: items)
            completion()
        } onFailure: { error in
            print(error)
        }
    }
    
    func addWish(_ item: Item) throws {
        try repository.createItem(WishItemEntity(domain: item))
    }
    
    func removeWish(_ item: Item) {
        guard let wishItemEntity = repository.fetchFilter(item).first else { return }
        repository.deleteItem(wishItemEntity)
    }
    
    func checkWishItem(indexPath: IndexPath) {
        let item = items[indexPath.item]
        if repository.wishItemEntities.contains(where: { $0.productID == item.productID }) {
            items[indexPath.item].isWished = true
        } else {
            items[indexPath.item].isWished = false
        }
    }
    
}
