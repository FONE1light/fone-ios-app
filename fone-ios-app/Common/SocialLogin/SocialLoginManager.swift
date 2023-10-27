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

import FirebaseCore
import FirebaseAuth
import GoogleSignIn

import AuthenticationServices

enum SocialLoginType: String {
    case APPLE, GOOGLE, KAKAO
}

final class SocialLoginManager {
    static let shared: SocialLoginManager = SocialLoginManager()
    var disposeBag = DisposeBag()
    var sceneCoordinator: SceneCoordinatorType?
    var email: String = ""
    
    func initailize(sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
        // MARK: KakaoLogin
        let kakaoAppKey = "ee40509f29760cb723e4aa58c379f1da"
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        
        // MARK: GoogleLogin
        FirebaseApp.configure()
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
                    self.getKakaoUserEmail()
                    self.socialSignIn(accessToken: accessToken, loginType: SocialLoginType.KAKAO.rawValue)
                }
            }
        }
    }
    
    func loginWithGoogle(presentingVC: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [unowned self] result, error in
            guard error == nil else {
                print(error as Any)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  let email = user.profile?.email else { return }
            self.email = email
            self.socialSignIn(accessToken: idToken, loginType: SocialLoginType.GOOGLE.rawValue)
        }
    }
    
    func loginWithApple(presentingVC: UIViewController) {
        guard let presentingVC = presentingVC as? ASAuthorizationControllerDelegate else { return }
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = presentingVC
        authorizationController.presentationContextProvider = presentingVC as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
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
        signUpSelectionViewModel.socialSingUpInfo = (accessToken, loginType, email)
        
        let signUpScene = Scene.signUpSelection(signUpSelectionViewModel)
        coordinator.transition(to: signUpScene, using: .push, animated: true)
    }
    
    func moveToHome() {
        guard let coordinator = self.sceneCoordinator as? SceneCoordinator else { return }
        
        let homeScene = Scene.home(coordinator)
        coordinator.transition(to: homeScene, using: .root, animated: true)
    }
}

// MARK: KakaoLogin
extension SocialLoginManager {
    /// 카카오 이메일 가져오기
    private func getKakaoUserEmail() {
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print(error)
            }
            self.email = user?.kakaoAccount?.email ?? ""
        }
    }
}

// MARK: AppleLogin
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let identityToken = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityToken, encoding: .utf8) {
                SocialLoginManager.shared.email = appleIDCredential.email ?? ""
                SocialLoginManager.shared.socialSignIn(accessToken: identityTokenString, loginType: SocialLoginType.APPLE.rawValue)
            }
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
