//
//  Repository.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import Foundation
import RealmSwift

final class WishItemEntityRepository {
    typealias T = Product
    static let shared = WishItemEntityRepository()
    
    private let realm = try! Realm()
    
    private init() { }
    
    func fetchWishItems() -> [Item] {
        let result = fetchWishItemEntities()
        return result.map { $0.convertToItem() }
    }
    
    private func fetchWishItemEntities() -> Results<WishItemEntity> {
        let result = realm.objects(WishItemEntity.self)
        return result
    }
    
    func fetchWishItem(forPrimaryKeyPath: String) -> Item? {
        return fetchWishItem(forPrimaryKeyPath: forPrimaryKeyPath)?.convertToItem()
    }
    
    
    private func fetchWishItem(forPrimaryKeyPath: String) -> WishItemEntity? {
        let result = realm.object(ofType: WishItemEntity.self, forPrimaryKey: forPrimaryKeyPath)
        return result
    }
    
    func createItem(_ item: Item) throws {
        do {
            try realm.write{
                realm.add(WishItemEntity(domain: item))
            }
        } catch {
            throw SesacError.saveError
        }
    }
    
    func updateItem(_ item: Item, update: (WishItemEntity?) -> Void) throws {
        
        guard let wishItem = realm.object(ofType: WishItemEntity.self, forPrimaryKey: item.productID) else {
            throw SesacError.updateError
        }
        
        do {
            try realm.write{
                update(wishItem)
                realm.add(wishItem, update: .modified)
            }
        } catch {
            throw SesacError.updateError
        }
    }

    func deleteItem(_ item: Item) throws {
        guard let wishItem = realm.object(ofType: WishItemEntity.self, forPrimaryKey: item.productID) else {
            throw SesacError.doNotDelete
        }
        do {
            try realm.write {
                realm.delete(wishItem)
            }
        } catch {
            throw SesacError.doNotDelete
        }
    }
}

