//
//  UIConfigurable.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit

@objc protocol UIConfigurable {
    func configureViews()
    @objc optional func setAttributes()
    func setConstraints()
}
