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
    
    func showAlertMessage(title: String, message: String? = nil, button: String = "확인", handler: (() -> ())? = nil ) { //매개변수 기본값
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default) { _ in
            handler?()
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
