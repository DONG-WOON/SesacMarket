//
//  ValidateTextProtocol.swift
//  SesacMarket
//
//  Created by 서동운 on 9/10/23.
//

import Foundation

enum SearchError: Error {
    case emptyString
    
    var message: String {
        switch self {
        case .emptyString:
            return "검색할 단어가 비었습니다. 검색할 단어를 입력해주세요."
        }
    }
}

protocol ValidateTextProtocol {
    
    func validate(text: String?) -> Result<String, SearchError>
}

extension ValidateTextProtocol {
    func validate(text: String?) -> Result<String, SearchError> {
        guard let text, !text.isEmpty else { return .failure(SearchError.emptyString) }
        
        return .success(text)
    }
}
