//
//  SceneDelegate.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let searchVC = SearchViewController(viewModel: SearchViewModel())
            .configure {
                $0.tabBarItem.image = UIImage(systemName: Image.search)
                $0.title = "검색"
            }
            .embedNavigationController()
        
        let wishVC = WishViewController(viewModel: WishViewModel())
            .configure {
                $0.tabBarItem.image = UIImage(systemName: Image.wish)
                $0.title = "좋아요 목록"
            }
            .embedNavigationController()
        
        let tabBarController = TabBarController(vc: [wishVC, searchVC])
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

