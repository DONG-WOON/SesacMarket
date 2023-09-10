//
//  Repository.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import Foundation
import RealmSwift

protocol Repository {
    associatedtype T: Object
    
    func fetchItems(_ item: T.Type) -> Results<T>
    func fetchItem(_ item: T.Type, forPrimaryKeyPath: KeyPath<T, ObjectId>) -> T?
    func createItem(_ item: T) throws
    func updateItem(_ item: T, update: (T) -> Void) throws
    func deleteItems(_ item: Results<T>)
    func deleteItem(_ item: T)
}

enum RepositoryError: Error {
    case fetchError
    case saveError
    case itemIsNil
    case itemIsInvalid
    case updateError
}

final class WishItemEntityRepository<T: WishItemEntity>: Repository {
    
    private let realm = try! Realm()
    
    var wishItemEntities: Results<T>!
    
    init() {
        self.wishItemEntities = fetchItems(T.self)
    }
    
    func fetchItems(_ item: T.Type) -> Results<T> {
        let result = realm.objects(item)
        return result
    }
    
    func fetchItem(_ item: T.Type, forPrimaryKeyPath: KeyPath<T, ObjectId>) -> T? {
        let result = realm.object(ofType: item, forPrimaryKey: forPrimaryKeyPath)
        return result
    }
    
    func createItem(_ item: T) throws {
        do {
            try realm.write{
                realm.add(item)
            }
        } catch {
            throw RepositoryError.saveError
        }
    }
    
    func updateItem(_ item: T, update: (T) -> Void) throws {
        do {
            try realm.write{
                update(item)
                realm.add(item, update: .modified)
            }
        } catch {
            throw RepositoryError.updateError
        }
    }
    
    func deleteItems(_ item: Results<T>) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
      
    }
    
    func deleteItem(_ item: T) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchSortedItem<U>(by keyPath: KeyPath<T, U>, ascending: Bool = true) -> Results<T> where U: _HasPersistedType, U.PersistedType : SortableType {
        let data = realm.objects(T.self).sorted(by: keyPath, ascending: ascending)
        return data
    }
    
    //수정
    func fetchFilter(_ keyItem: Item) -> Results<T> {
        let data = realm.objects(T.self).where { $0.productID == keyItem.productID }
        return data
    }
}

