//
//  Repository.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import Foundation
import RealmSwift

protocol Repository {
    associatedtype T: Product
    
    func fetchWishItems() -> [Product]
    func fetchWishItem(forPrimaryKeyPath: String) -> Product?
    func createItem(_ item: T) throws
    func updateItem(_ item: T, update: (WishItemEntity?) -> Void) throws
    func deleteItem(_ item: T) throws
}

final class WishItemEntityRepository: Repository {
    typealias T = Item
    static let shared = WishItemEntityRepository()
    
    private let realm = try! Realm()
    
    private init() { }
    
    func fetchWishItems() -> [Product] {
        let result = fetchWishItemEntities()
        return result.map { $0.convertToItem() }
    }
    
    private func fetchWishItemEntities() -> Results<WishItemEntity> {
        let result = realm.objects(WishItemEntity.self)
        return result
    }
    
    func fetchWishItem(forPrimaryKeyPath: String) -> Product? {
        return fetchWishItem(forPrimaryKeyPath: forPrimaryKeyPath)?.convertToItem()
    }
    
    
    private func fetchWishItem(forPrimaryKeyPath: String) -> WishItemEntity? {
        let result = realm.object(ofType: WishItemEntity.self, forPrimaryKey: forPrimaryKeyPath)
        return result
    }
    
    func createItem(_ item: T) throws {
        do {
            try realm.write{
                realm.add(WishItemEntity(domain: item))
            }
        } catch {
            throw SesacError.saveError
        }
    }
    
    func updateItem(_ item: T, update: (WishItemEntity?) -> Void) throws {
        
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

    func deleteItem(_ item: T) throws {
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

