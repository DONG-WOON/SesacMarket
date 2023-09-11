//
//  DetailViewModel.swift
//  SesacMarket
//
//  Created by 서동운 on 9/11/23.
//

import Foundation

class DetailViewModel<T: Product> {
    
    var item: T
    
    init(item: T) {
        self.item = item
    }
    
    func requestURL() -> URLRequest {
        let url = NetworkService.web(productID: item.productID).getURL()
        return URLRequest(url: url)
    }
    
    func wishButtonAction() throws -> Bool {
        item.isWished.toggle()
        
        guard WishItemEntityRepository.shared.fetchItem(WishItemEntity.self, forPrimaryKeyPath: item.productID) != nil else {
            do {
                try addWish(item)
                return item.isWished
            } catch {
                throw RepositoryError.saveError
            }
        }
        removeWish(item)
        return item.isWished
    }
    
    func addWish(_ item: T) throws {
        try WishItemEntityRepository.shared.createItem(WishItemEntity(domain: item))
    }
    
    func removeWish(_ item: T) {
        guard let wishItemEntity = WishItemEntityRepository.shared.fetchItem(WishItemEntity.self, forPrimaryKeyPath: item.productID) else { return }
        WishItemEntityRepository.shared.deleteItem(wishItemEntity)
    }
}
