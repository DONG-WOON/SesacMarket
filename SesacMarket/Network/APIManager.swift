//
//  APIManager.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation
import Moya

struct APIManager {
    private let provider = MoyaProvider<Service>()
    static let shared = APIManager()
    
    private init() { }
    
    func request(search: String, size: Int = 30, page: Int, sort: Sort) {
        provider.request(.search(query: search, size: size, page: page, sort: sort)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(Response.self)
                    dump(data)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
