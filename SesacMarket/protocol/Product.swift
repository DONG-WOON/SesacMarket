//
//  Product.swift
//  SesacMarket
//
//  Created by 서동운 on 9/11/23.
//

import Foundation

protocol Product {
    var productID: String { get set }
    var title: String { get set }
    var stringURL: String { get set }
    var price: String { get set }
    var mallName: String { get set }
    var maker: String { get set }
    
    var validatedTitle: String { get }
    var decimalPrice: String { get }
}
