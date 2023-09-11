//
//  NetworkService.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation
import Moya

enum NetworkService {
    case search(query: String, size: Int, page: Int, sort: Sort)
    case web(productID: String)
    
    var endPoint: String {
        switch self {
        case .search:
            return "https://openapi.naver.com/v1"
        case .web:
            return "https://msearch.shopping.naver.com/product"
        }
    }
}

extension NetworkService: TargetType {
    var baseURL: URL {
        return URL(string: self.endPoint)!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search/shop.json"
        case .web(productID: let productID):
            return "/\(productID)"
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
                                                   "sort": sort.string],
                                      encoding: URLEncoding.queryString)
        case .web:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["X-Naver-Client-Id": APIKEY.client_id,
                "X-Naver-Client-Secret": APIKEY.client_Secret]
    }
}

extension NetworkService {
    func getURL() -> URL {
        var url = baseURL
        url.appendPathComponent(path)
        
        return url
    }
}
