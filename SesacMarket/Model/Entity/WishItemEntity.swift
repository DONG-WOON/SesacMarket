//
//  WishItemEntity.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import Foundation
import RealmSwift

class WishItemEntity: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var title: String
    @Persisted var stringURL: String
    @Persisted var price: String
    @Persisted var mallName: String
    @Persisted var productID: String
    @Persisted var maker: String
    @Persisted var isWished: Bool
    
    var originalImageURL: URL? {
        return URL(string: stringURL)
    }
    
    convenience init(_id: ObjectId, title: String, stringURL: String, price: String, mallName: String, productID: String, maker: String, isWished: Bool) {
        self.init()
        
        self._id = _id
        self.title = title
        self.stringURL = stringURL
        self.price = price
        self.mallName = mallName
        self.productID = productID
        self.maker = maker
        self.isWished = isWished
    }
    
    convenience init(domain: Item) {
        self.init()
        
        self.title = validate(text: domain.validatedTitle)
        self.stringURL = domain.stringURL
        self.price = domain.price
        self.mallName = domain.mallName
        self.productID = domain.productID
        self.maker = domain.maker
        self.isWished = domain.isWished
    }
}


extension WishItemEntity {
    func validate(text: String) -> String {
        return text.replacingOccurrences(of: "[//<b>//</b>]", with: "", options: .regularExpression)
    }
}



