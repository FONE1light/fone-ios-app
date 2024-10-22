//
//  LogoutBottomSheetViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/6/24.
//

import UIKit
import RxSwift

class LogoutBottomSheetViewModel: CommonViewModel {
    
    private var disposeBag = DisposeBag()
    private let loginType: SocialLoginType?
    
    init(sceneCoordinator: SceneCoordinatorType, loginType: SocialLoginType?) {
        self.loginType = loginType
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func logout() {
        switch loginType {
        case .GOOGLE:
            SocialLoginManager.shared.logoutFromGoogle()
        case .KAKAO:
            SocialLoginManager.shared.logoutFromKakaoTalk()
        default: break
        }
        
        userInfoProvider.rx.request(.logout)
            .mapObject(Result<String?>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        response.message?.toast()
                        Tokens.shared.accessToken.value = ""
                        Tokens.shared.refreshToken.value = ""
                        owner.moveToLogin()
                    } else {
                        "로그아웃 실패".toast()
                    }
                }, onError: { error in
                    error.showToast(modelType: String.self)
                }).disposed(by: disposeBag)
    }
    
    private func moveToLogin() {
        if let keyWindow = UIApplication.shared.delegate?.window {
            let coordinator = SceneCoordinator(window: keyWindow!)
            let loginViewModel = LoginViewModel(sceneCoordinator: coordinator)
            let loginScene = Scene.login(loginViewModel)
            coordinator.transition(to: loginScene, using: .root, animated: true)
        }
    }
}
