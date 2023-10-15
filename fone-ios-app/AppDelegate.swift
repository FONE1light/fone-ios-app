//
//  AppDelegate.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/05.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(3)
        let coordinator = SceneCoordinator(window: window!)
        var destinationScene: Scene
        
        let refreshToken = Tokens.shared.refreshToken.value
        if !refreshToken.isEmpty {
            destinationScene = Scene.home(coordinator)
        } else {
            let loginViewModel = LoginViewModel(sceneCoordinator: coordinator)
            destinationScene = Scene.login(loginViewModel)
        }
        
        coordinator.transition(to: destinationScene, using: .root, animated: false)
        
        return true
    }
}

