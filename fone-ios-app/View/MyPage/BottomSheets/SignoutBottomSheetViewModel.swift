//
//  SignoutBottomSheetViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 3/8/24.
//

import UIKit
import RxSwift

class SignoutBottomSheetViewModel: CommonViewModel {
    
    private var disposeBag = DisposeBag()
    
    func signout() {
        userInfoProvider.rx.request(.signout)
            .mapObject(Result<String?>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        response.message?.toast()
                        Tokens.shared.accessToken.value = ""
                        owner.moveToLogin()
                    } else {
                        "회원 탈퇴 실패".toast()
                    }
                }
                , onError: { error in
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