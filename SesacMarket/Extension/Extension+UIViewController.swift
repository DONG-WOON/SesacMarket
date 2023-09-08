//
//  Extension+UIViewController.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit.UIViewController

extension UIViewController {
    
    func configure(completion: (UIViewController) -> Void) -> UIViewController {
        completion(self)
        return self
    }
    
    func embedNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        return navigationController
    }
}
