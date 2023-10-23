//
//  SocialLoginManager.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 10/15/23.
//

import Foundation
import RxSwift
import KakaoSDKCommon
import KakaoSDKUser

enum SocialLoginType: String {
    case APPLE, GOOGLE, KAKAO
}

final class SocialLoginManager {
    static let shared: SocialLoginManager = SocialLoginManager()
    var disposeBag = DisposeBag()
    var sceneCoordinator: SceneCoordinatorType?
    
    func initailize(sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
        // MARK: KakaoLogin
        let kakaoAppKey = "ee40509f29760cb723e4aa58c379f1da"
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        
    }
    
    func login(loginType: SocialLoginType) {
        switch loginType {
        case .KAKAO:
            loginWithKakaoTalk()
        case .GOOGLE:
            break
        case .APPLE:
            break
        }
    }
    
    func loginWithKakaoTalk() {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    let accessToken = oauthToken?.accessToken ?? ""
                    self.socialSignIn(accessToken: accessToken, loginType: SocialLoginType.KAKAO.rawValue)
                }
            }
        }
    }
    
    func socialSignIn(accessToken: String, loginType: String) {
        userInfoProvider.rx.request(.socialSignIn(accessToken: accessToken, loginType: loginType))
            .mapObject(EmailSignInResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result == "SUCCESS" {
                    guard let token = response.data?.token else { return }
                    Tokens.shared.accessToken.value = token.accessToken
                    Tokens.shared.refreshToken.value = token.refreshToken
                    owner.moveToHome()
                } else {
                    owner.moveToSocialSignUp(accessToken: accessToken, loginType: loginType)
                }
            }, onError: { error in
                print(error.localizedDescription)
                "\(error)".toast(positionType: .withButton)
            }).disposed(by: disposeBag)
    }
    
    func moveToSocialSignUp(accessToken: String, loginType: String) {
        guard let coordinator = self.sceneCoordinator as? SceneCoordinator else { return }
        
        let signUpSelectionViewModel = SignUpSelectionViewModel(sceneCoordinator: coordinator)
        signUpSelectionViewModel.socialSingUpInfo = (accessToken, loginType)
        
        let signUpScene = Scene.signUpSelection(signUpSelectionViewModel)
        coordinator.transition(to: signUpScene, using: .push, animated: true)
    }
    
    func moveToHome() {
        guard let coordinator = self.sceneCoordinator as? SceneCoordinator else { return }
        
        let homeScene = Scene.home(coordinator)
        coordinator.transition(to: homeScene, using: .root, animated: true)
    }
}
