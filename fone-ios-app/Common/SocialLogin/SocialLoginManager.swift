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
import Moya

enum SocialLoginType: String, CaseIterable {
    case APPLE, GOOGLE, KAKAO
    
    static func getType(string: String?) -> SocialLoginType? {
        SocialLoginType.allCases.filter { $0.rawValue == string }.first
    }
}

final class SocialLoginManager {
    static let shared: SocialLoginManager = SocialLoginManager()
    var disposeBag = DisposeBag()
    var sceneCoordinator: SceneCoordinatorType?
    var name: String?
    var identifier: String?
    var email: String = ""
    
    func initailize(sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
        // MARK: KakaoLogin
        let kakaoAppKey = "ee40509f29760cb723e4aa58c379f1da"
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        
        // MARK: GoogleLogin
        FirebaseApp.configure()
    }
    
    /// currentVC가 바뀐 최신 SceneCoordnator를 가지고 있지 않은 경우 SceneCoordinator를 업데이트 하기 위해 사용
    func updateCoordinator(_ sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
    }
    
    func loginWithKakaoTalk() {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    print("🔥loginWithKakaoTalk-FAILURE")
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    print("🔥loginWithKakaoTalk-SUCCESS")
                    let accessToken = oauthToken?.accessToken ?? ""
                    self.getKakaoUserEmailAndName()
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
                print("🔥loginWithGoogle-FAILURE")
                return
            }
            print("🔥loginWithGoogle-SUCCESS")
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  let email = user.profile?.email else { return }
            self.name = user.profile?.name
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
            .mapObject(SignInResponseModel.self)
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
            }, onError: { [weak self] error in
                guard let statusCode = (error as? MoyaError)?.response?.statusCode else { return }
                switch statusCode {
                case 400...401:
                    self?.moveToSocialSignUp(accessToken: accessToken, loginType: loginType)
                    return
                default: break
                }
                print(error.localizedDescription)
                error.showToast(modelType: EmptyData.self)
            }).disposed(by: disposeBag)
    }
    
    func moveToSocialSignUp(accessToken: String, loginType: String) {
        guard !email.isEmpty else {
            showFailToLoadEmailPopup()
            return
        }
        
        guard let coordinator = self.sceneCoordinator as? SceneCoordinator else { return }
        
        let signUpSelectionViewModel = SignUpSelectionViewModel(sceneCoordinator: coordinator)
        
        let socialSignInInfo = SocialSignInInfo(
            accessToken: accessToken,
            loginType: loginType
        )
        
        signUpSelectionViewModel.signInInfo = SignInInfo(
            type: .social,
            name: name,
            email: email,
            identifier: identifier,
            socialSignInfo: socialSignInInfo
        )
        
        let signUpScene = Scene.signUpSelection(signUpSelectionViewModel)
        coordinator.transition(to: signUpScene, using: .push, animated: true)
    }
    
    func moveToHome() {
        guard let coordinator = self.sceneCoordinator as? SceneCoordinator else { return }
        
        let homeScene = Scene.home(coordinator)
        coordinator.transition(to: homeScene, using: .root, animated: true)
    }
    
    func showFailToLoadEmailPopup() {
        let message = "이메일을 불러오지 못했습니다.\n\nApple로 로그인 시도 중이라면 다음과 같이 실행 후 다시 시도해주세요.\n\n* 설정 > Apple ID > 로그인 및 보안 > Apple로 로그인 > FONE > Apple ID 사용 중단"
        let alert = UIAlertController.createOneButtonPopup(title: message)
        guard let currentVC = (sceneCoordinator as? SceneCoordinator)?.currentVC else { return }
        currentVC.present(alert, animated: true)
    }
}

// MARK: KakaoLogin
extension SocialLoginManager {
    /// 카카오 이메일, 이름 가져오기
    private func getKakaoUserEmailAndName() {
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print(error)
            }
            self.email = user?.kakaoAccount?.email ?? ""
            self.name = user?.kakaoAccount?.name ?? user?.kakaoAccount?.profile?.nickname
        }
    }
}

extension SocialLoginManager {
    func logoutFromKakaoTalk() {
        UserApi.shared.logout { error in
            if let error = error {
                print(error.localizedDescription)
                print("🔥logoutFromKakaoTalk-FAILURE")
                return
            } else {
                print("🔥logoutFromKakaoTalk-SUCCESS")
            }
        }
    }
    
    func logoutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
        print("🔥logoutFromGoogle-SUCCESS")
    }
}

extension SocialLoginManager {
    func disconnectKakaoTalkLogin() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
                print("🔥disconnectKakaoTalkLogin-FAILURE")
            } else {
                print("unlink() success.")
                print("🔥disconnectKakaoTalkLogin-SUCCESS")
            }
        }
    }
    
    func disconnectGoogleLogin() {
        GIDSignIn.sharedInstance.disconnect()
        print("🔥disconnectGoogleLogin-SUCCESS")
    }
}

// MARK: AppleLogin
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        print("🔥loginWithApple-SUCCESS")
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let identityToken = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityToken, encoding: .utf8) {
                SocialLoginManager.shared.email = appleIDCredential.email ?? ""
                SocialLoginManager.shared.name = appleIDCredential.fullName?.toString()
                SocialLoginManager.shared.identifier = appleIDCredential.user
                SocialLoginManager.shared.socialSignIn(accessToken: identityTokenString, loginType: SocialLoginType.APPLE.rawValue)
            }
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("🔥loginWithApple-FAILURE")
        print("🔥login failed - \(error.localizedDescription)")
    }
}

extension PersonNameComponents {
    func toString() -> String {
        let familyName = self.familyName ?? ""
        let middleName = self.middleName ?? ""
        let givenName = self.givenName ?? ""
        return familyName + middleName + givenName
    }
}
