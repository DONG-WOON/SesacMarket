//
//  Item.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation

// MARK: - Item
struct Item: Codable {
    let title: String
    let stringURL: String
    let price: String
    let mallName: String
    let productID: String
    let maker: String
    
    var originalImageURL: URL? {
        return URL(string: stringURL)
    }
    var thumbnailURL: URL? {
        return URL(string: stringURL + "?type=m510")
    }
    
    var validatedTitle: String {
        return validate(text: title)
    }
    
    var decimalPrice: String {
        guard let price = NumberFormatter.DecimalFormatter.string(from: NSNumber(floatLiteral: Double(price) ?? 0)) else { return "가격정보 없음" }
        return price + "원"
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case stringURL = "image"
        case price = "lprice"
        case mallName
        case productID = "productId"
        case maker
    }
    
    init(entity: WishItemEntity) {
        
        self.title = entity.title
        self.stringURL = entity.stringURL
        self.price = entity.price
        self.mallName = entity.mallName
        self.productID = entity.productID
        self.maker = entity.maker
        self.isWished = entity.isWished
    }
}

extension Item {
    func validate(text: String) -> String {
        return text.replacingOccurrences(of: "[//<b>//</b>]", with: "", options: .regularExpression)
    }
}
