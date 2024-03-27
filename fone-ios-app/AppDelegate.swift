//
//  AppDelegate.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/05.
//

import UIKit
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let coordinator = SceneCoordinator(window: window!)
        
        // MARK: 소셜로그인 초기화 (kakao)
        SocialLoginManager.shared.initailize(sceneCoordinator: coordinator)
        RemoteConfigManager.shared.initialize(sceneCoordinator: coordinator) { isVersionCheckPassed in
            
            DispatchQueue.main.async {
                var destinationScene: Scene
                
                if isVersionCheckPassed {
                    destinationScene = self.checkLoginStatus(coordinator)
                } else {
                    destinationScene = Scene.fakeLaunchScreen(coordinator)
                }
                coordinator.transition(to: destinationScene, using: .root, animated: false)
            }
        }
        
        sleep(3)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            ATTrackingAlertManager.shared.initialize()
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}


// MARK: - 화면 이동
extension AppDelegate {
    private func checkLoginStatus(_ coordinator: SceneCoordinator) -> Scene {
        var destinationScene: Scene
        let accessToken = Tokens.shared.accessToken.value
        if !accessToken.isEmpty {
            // 사용 중 토큰 갱신 상황을 최소화하기 위해 자동 로그인 시 토큰 갱신
            UserManager.shared.reissueToken { _ in }
            destinationScene = Scene.home(coordinator)
        } else {
            let loginViewModel = LoginViewModel(sceneCoordinator: coordinator)
            destinationScene = Scene.login(loginViewModel)
        }
        
        return destinationScene
    }
}
