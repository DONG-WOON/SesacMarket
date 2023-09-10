//
//  BaseViewController.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController, UIConfigurable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        setAttributes()
        setConstraints()
    }
    
    func configureViews() { }
    
    func setAttributes() {
        view.backgroundColor = .systemBackground
    }
    
    func setConstraints() { }
}
