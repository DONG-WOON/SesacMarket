//
//  NetworkError.swift
//  SesacMarket
//
//  Created by 서동운 on 9/10/23.
//

import Foundation

enum NetworkError: Error {
    case invalidQuery
    case invalidURL
    case serverError
    case mappingError
    case statusCodeIsNil
    case unknown
    
    var message: String {
        switch self {
            
        case .invalidQuery, .invalidURL:
            return "검색어가 잘못되었습니다. 다시 입력해주세요."
        case .serverError, .mappingError, .statusCodeIsNil, .unknown:
            return "서버에 오류가 발생했습니다. 나중에 다시 시도해주세요."
        }
    }
}
