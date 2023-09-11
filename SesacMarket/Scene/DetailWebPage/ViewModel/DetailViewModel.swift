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
        
        let isWished = isWished()
        
        if isWished {
            do {
                try removeWish()
                return item.isWished
            } catch {
                throw SesacError.doNotDelete
            }
        } else {
            do {
                try addWish(item)
                return item.isWished
            } catch {
                throw SesacError.saveError
            }
        }
    }
    
    func addWish(_ item: T) throws {
        try WishItemEntityRepository.shared.createItem(item)
    }
    
    func removeWish() throws {
        guard let wishItemEntity = WishItemEntityRepository.shared.fetchWishItem(forPrimaryKeyPath: item.productID) else { return }
        do {
           try WishItemEntityRepository.shared.deleteItem(wishItemEntity)
        } catch {
            throw SesacError.doNotDelete
        }
    }
    
    func isWished() -> Bool {
        guard let _ = WishItemEntityRepository.shared.fetchWishItem(forPrimaryKeyPath: item.productID) else { return false }
        return true
    }
}
