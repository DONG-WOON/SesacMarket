//
//  TabBarController.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    init(vc viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = .label
        tabBarAppearance.isTranslucent = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
