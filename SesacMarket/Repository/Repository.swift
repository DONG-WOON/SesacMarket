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
    func fetchItem(_ item: T.Type, forPrimaryKeyPath: String) -> T?
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
    
    var message: String {
        switch self {
        case .fetchError:
            return "불러오기에 실패하였습니다. 잠시 후 다시 시도해주세요."
        case .saveError:
            return "저장에 실패하였습니다. 잠시 후 다시 시도해주세요."
        case .itemIsNil:
            return "유효하지 않은 상품입니다."
        case .itemIsInvalid:
            return "유효하지 않은 상품입니다."
        case .updateError:
            return "업데이트에 실패하였습니다. 잠시 후 다시 시도해주세요."
        }
    }
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
    
    func fetchItem(_ item: T.Type, forPrimaryKeyPath: String) -> T? {
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
}

