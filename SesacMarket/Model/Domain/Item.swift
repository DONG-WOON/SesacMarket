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
    let image: String
    let price: String
    let mallName: String
    let productID: String
    let maker: String
    
    enum CodingKeys: String, CodingKey {
        case title, image
        case price = "lprice"
        case mallName
        case productID = "productId"
        case maker
    }
}
