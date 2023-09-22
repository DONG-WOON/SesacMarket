//
//  ValidateTextProtocol.swift
//  SesacMarket
//
//  Created by 서동운 on 9/10/23.
//

import Foundation

protocol ValidateTextProtocol {
    func validate(text: String?) -> Result<String, SesacError>
}

extension ValidateTextProtocol {
    func validate(text: String?) -> Result<String, SesacError> {
        guard let text, !text.isEmpty else {
            return .failure(SesacError.emptyString)
        }
        return .success(text)
    }
}
