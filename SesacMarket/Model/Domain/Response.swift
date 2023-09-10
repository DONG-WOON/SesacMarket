//
//  Response.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation

// MARK: - Response
struct Response: Codable {
    let start, display: Int
    let items: [Item]
}

// MARK: - Sort
enum Sort: String, CaseIterable {
    case sim
    case date
    case asc
    case dsc
    
    var title: String {
        switch self {
        case .sim:
            return "정확도순"
        case .date:
            return "날짜순"
        case .asc:
            return "가격낮은순"
        case .dsc:
            return "가격높은순"
        }
    }
}
