//
//  WishViewModel.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import Foundation
import RealmSwift

final class WishViewModel {
    var wishItems: Results<WishItemEntity>!
    
    func fetchWish(_ search: String? = nil, completion: () -> Void) {
        wishItems = WishItemEntityRepository.shared.fetchItems(WishItemEntity.self)
        completion()
    }
    
    func removeWish(_ item: WishItemEntity) {
        WishItemEntityRepository.shared.deleteItem(item)
    }
}
