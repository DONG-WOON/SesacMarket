//
//  DetailViewModel.swift
//  SesacMarket
//
//  Created by 서동운 on 9/11/23.
//

import Foundation
import RxSwift
import RealmSwift
import RxCocoa

class DetailViewModel {
    
    let item: BehaviorSubject<Item>
    let itemIsWished = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init(item: BehaviorSubject<Item>) {
        self.item = item
    }
    
    func requestURL() -> Observable<URLRequest> {
        let _request = item.flatMap { item in
            let url = NetworkService.web(productID: item.productID).getURL()
            return Observable.just(URLRequest(url: url))
        }
        return _request
    }
    
    func toggleWishStatus() throws {
        item.map { [weak self] item in
            if WishItemEntityRepository.shared.fetchWishItem(forPrimaryKeyPath: item.productID) != nil {
                self?.itemIsWished.onNext(false)
                try self?.removeWishItem()
            } else {
                self?.itemIsWished.onNext(true)
                try self?.addWishItem()
            }
        }.subscribe()
            .disposed(by: disposeBag)
    }
    
    func addWishItem() throws {
        item.map { item in
            do {
                try WishItemEntityRepository.shared.createItem(item)
            } catch {
                throw SesacError.doNotDelete
            }
        }.subscribe()
            .disposed(by: disposeBag)
    }
    
    func removeWishItem() throws {
        item.map { item in
            do {
                try WishItemEntityRepository.shared.deleteItem(item)
            } catch {
                throw SesacError.doNotDelete
            }
        }.subscribe()
            .disposed(by: disposeBag)
    }
    
    func checkItemIsExistInWishItems() {
        item.map { item in
            guard let _ = WishItemEntityRepository.shared.fetchWishItem(forPrimaryKeyPath: item.productID) else { return false }
            return true
        }.asObservable()
            .subscribe(itemIsWished)
            .disposed(by: disposeBag)
    }
}
