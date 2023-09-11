//
//  WishViewModel.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import Foundation
import RealmSwift

final class WishViewModel: ValidateTextProtocol {
    var wishItems: [Item] = []
    var searchText: String?
    
    func fetchWish(completion: () -> Void) {
        let result = validate(text: searchText)
        switch result {
        case .success(let text):
            wishItems = WishItemEntityRepository.shared.fetchWishItems().filter({ $0.title.uppercased().contains(text.uppercased()) })
            completion()
        case .failure(_):
            wishItems = WishItemEntityRepository.shared.fetchWishItems()
            completion()
        }
    }
    
    func removeWish(_ item: Item) throws {
        do {
            try WishItemEntityRepository.shared.deleteItem(item)
            wishItems.removeAll { $0.productID == item.productID }
        } catch {
            throw SesacError.doNotDelete
        }
    }
}
