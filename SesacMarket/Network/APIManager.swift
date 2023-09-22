//
//  APIManager.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation
import Moya

public typealias Cancelable = Cancellable

struct APIManager {
    private let provider = MoyaProvider<NetworkService>()
    static let shared = APIManager()
    
    @discardableResult
    func request(search: String, size: Int = 30, page: Int, sort: Sort, completion: @escaping (Result<[Item], SesacError>) -> Void) -> Cancellable {
        return provider.request(.search(query: search, size: size, page: page, sort: sort)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(Response.self)
                    return completion(.success(data.items))
                } catch {
                    return completion(.failure(SesacError.mappingError))
                }
            case .failure(let error):
                guard let statusCode = error.response?.statusCode else {
                    return completion(.failure(SesacError.statusCodeIsNil))
                }
                switch statusCode {
                case 400:
                    return completion(.failure(SesacError.invalidQuery))
                case 404:
                    return completion(.failure(SesacError.invalidURL))
                case 500:
                    return completion(.failure(SesacError.serverError))
                default:
                    return completion(.failure(SesacError.unknown))
                }
            }
        }
    }
}
