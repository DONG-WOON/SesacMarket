//
//  AppDelegate.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let realmConfiguration = Realm.Configuration(schemaVersion: 2) { migration,oldSchemaVersion in
            
        }
        
        Realm.Configuration.defaultConfiguration = realmConfiguration
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = .label
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
     
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
     
    }


}

