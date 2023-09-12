//
//  WishItemEntity.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import Foundation
import RealmSwift

class WishItemEntity: Object, Product {
    
    @Persisted(primaryKey: true) var productID: String
    @Persisted var title: String
    @Persisted var stringURL: String
    @Persisted var price: String
    @Persisted var mallName: String
    @Persisted var maker: String
    @Persisted var isWished: Bool
    
    var originalImageURL: URL? {
        return URL(string: stringURL)
    }
    
    var validatedTitle: String {
        return validate(text: title)
    }
    
    var decimalPrice: String {
        guard let price = NumberFormatter.DecimalFormatter.string(from: NSNumber(floatLiteral: Double(price) ?? 0)) else { return "가격정보 없음" }
        return price + "원"
    }
    
    convenience init(productID: String, title: String, stringURL: String, price: String, mallName: String, maker: String, isWished: Bool) {
        self.init()
        
        self.productID = productID
        self.title = title
        self.stringURL = stringURL
        self.price = price
        self.mallName = mallName
        self.maker = maker
        self.isWished = isWished
    }
    
    convenience init(domain: Product) {
        self.init()
        // validatedTitle이 적용되지않음
        
        self.title = domain.validatedTitle
        self.stringURL = domain.stringURL
        self.price = domain.price
        self.mallName = domain.mallName
        self.productID = domain.productID
        self.maker = domain.maker
        self.isWished = domain.isWished
    }
    
    func convertToItem() -> Item {
        return Item(entity: self)
    }
}


extension WishItemEntity {
    func validate(text: String) -> String {
        return text.replacingOccurrences(of: "[//<b>//</b>]", with: "", options: .regularExpression)
    }
}



