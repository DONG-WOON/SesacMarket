//
//  Service.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation
import Moya

enum Service {
    case search(query: String, size: Int, page: Int, sort: Sort)
}

extension Service: TargetType {
    var baseURL: URL {
        return URL(string: "https://openapi.naver.com/v1")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search/shop.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    /// display = size, start = page
    var task: Moya.Task {
        switch self {
        case let .search(query, display, start, sort):
            return .requestParameters(parameters: ["query": query,
                                                   "display": display,
                                                   "start": start,
                                                   "sort": sort.rawValue],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["X-Naver-Client-Id": APIKEY.client_id,
                "X-Naver-Client-Secret": APIKEY.client_Secret]
    }
}
