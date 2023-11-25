//
//  UserManager.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/22/23.
//

import UIKit
import RxSwift

final class UserManager {
    static let shared = UserManager()
    var disposeBag = DisposeBag()
    
    func reissueToken(completion: @escaping(Bool) -> Void) {
        let tokenInfo = TokenInfo(accessToken: Tokens.shared.accessToken.value, refreshToken: Tokens.shared.refreshToken.value)
        
        tokenProvider.rx.request(.reissueToken(tokenInfo: tokenInfo))
            .mapObject(ReissueTokenModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                Tokens.shared.accessToken.value = response.data.accessToken
                Tokens.shared.refreshToken.value = response.data.refreshToken
                completion(true)
            }, onError: { error in
                print("\(error)")
                completion(false)
            }).disposed(by: disposeBag)
    }
    
    func moveToLogin() {
        if let keyWindow = UIApplication.shared.delegate?.window {
            let coordinator = SceneCoordinator(window: keyWindow!)
            let loginViewModel = LoginViewModel(sceneCoordinator: coordinator)
            let loginScene = Scene.login(loginViewModel)
            coordinator.transition(to: loginScene, using: .root, animated: true)
        }
    }
}
