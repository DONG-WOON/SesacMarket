//
//  Extension+UIView.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit.UIView

extension UIView: Identifiable { }
extension UIView {
    
    func rounded(radius: CGFloat = 10) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func makeBorder(width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    convenience init(_ backgroundColor: UIColor) {
        self.init()
        
        self.backgroundColor = backgroundColor
    }
}

