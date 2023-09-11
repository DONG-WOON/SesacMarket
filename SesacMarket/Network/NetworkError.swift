//
//  NetworkError.swift
//  SesacMarket
//
//  Created by 서동운 on 9/10/23.
//

import Foundation

enum SesacError: Error {
    case invalidQuery
    case invalidURL
    case serverError
    case mappingError
    case statusCodeIsNil
    case unknown
    case fetchError
    case saveError
    case itemIsNil
    case itemIsInvalid
    case updateError
    case emptyString
    case doNotDelete
    
    var message: String {
        switch self {
        case .invalidQuery, .invalidURL, .mappingError:
            return "검색어가 잘못되었습니다. 다시 입력해주세요."
        case .serverError, .statusCodeIsNil, .unknown:
            return "서버에 오류가 발생했습니다. 나중에 다시 시도해주세요."
        case .fetchError:
            return "불러오기에 실패하였습니다. 잠시 후 다시 시도해주세요."
        case .saveError:
            return "저장에 실패하였습니다. 잠시 후 다시 시도해주세요."
        case .itemIsNil, .itemIsInvalid:
            return "유효하지 않은 상품입니다."
        case .updateError:
            return "업데이트에 실패하였습니다. 잠시 후 다시 시도해주세요."
        case .emptyString:
            return "검색할 단어가 비었습니다. 검색할 단어를 입력해주세요."
        case .doNotDelete:
            return "삭제에 실패하였습니다. 잠시 후 다시 시도해주세요."
        }
    }
}
