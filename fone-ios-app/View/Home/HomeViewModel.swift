//
//  HomeViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/11.
//

import Foundation
import RxSwift
import Moya

class HomeViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    var homeInfoDataSubject = BehaviorSubject<HomeInfoData?>(value: nil)
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        fetchHome()
    }
    
    func fetchHome(isRetry: Bool = false) {
        homeInfoProvider.rx.request(.fetchHome)
            .mapObject(HomeInfo.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                self.homeInfoDataSubject.onNext(response.data)
            }, onError: { error in
                if isRetry {
                    self.moveToLogin()
                } else if let moyaError = error as? MoyaError {
                    if moyaError.response?.statusCode == 401 {
                        self.reissueToken()
                    }
                }
                print("\(error)")
            }).disposed(by: disposeBag)
    }
    
    func reissueToken() {
        let tokenInfo = TokenInfo(accessToken: Tokens.shared.accessToken.value, refreshToken: Tokens.shared.refreshToken.value)
        
        userInfoProvider.rx.request(.reissueToken(tokenInfo: tokenInfo))
            .mapObject(ReissueTokenModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                Tokens.shared.accessToken.value = response.data.accessToken
                Tokens.shared.refreshToken.value = response.data.refreshToken
                self.fetchHome(isRetry: true)
            }, onError: { error in
                print("\(error)")
            }).disposed(by: disposeBag)
    }
    
    func moveToLogin() {
        let loginViewModel = LoginViewModel(sceneCoordinator: self.sceneCoordinator)
        let loginScene = Scene.login(loginViewModel)
        self.sceneCoordinator.transition(to: loginScene, using: .root, animated: true)
    }
}
