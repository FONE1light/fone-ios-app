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
    
    func logout() {
        userInfoProvider.rx.request(.logout)
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
                        "로그아웃 실패".toast()
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
