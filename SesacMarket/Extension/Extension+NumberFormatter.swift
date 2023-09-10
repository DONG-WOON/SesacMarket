//
//  Extension+NumberFormatter.swift
//  SesacMarket
//
//  Created by 서동운 on 9/10/23.
//

import Foundation



extension NumberFormatter {
    
    static let DecimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
