//
//  EmailLoginViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/02.
//

import UIKit
import RxSwift

class EmailLoginViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    var emailTextSubject = BehaviorSubject<String>(value: "")
    var passwordIsEmptySubject = BehaviorSubject<Bool>(value: true)
    var showLoginErrorAlertSubject = PublishSubject<Void>()
    var isKeyboardShowing = false
    
    lazy var emailIsValidSubject: Observable<Bool> = {
        emailTextSubject
            .filter { $0 != "" }
            .map { $0.isValidEmail() }
    }()
    
    lazy var loginButtonEnable: Observable<Bool> = {
        Observable.combineLatest(emailTextSubject, passwordIsEmptySubject) { (email, passwordIsEmpty) -> Bool in
            
            return !email.isEmpty && !passwordIsEmpty
        }
    }()
    
    func moveToFindIDPassword() {
        let findIDPasswordViewModel = FindIDPasswordViewModel(sceneCoordinator: self.sceneCoordinator)
        let findIDPasswordScene = Scene.findIDPassword(findIDPasswordViewModel)
        self.sceneCoordinator.transition(to: findIDPasswordScene, using: .push, animated: true)
    }
    
    func emailLogin(emailSignInInfo: EmailSignInInfo) {
        userInfoProvider.rx.request(.emailSignIn(emailSignInInfo: emailSignInInfo))
            .mapObject(EmailSignInResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print("received!")
                print("response: \(response)")
                if response.result == "SUCCESS" {
                    guard let token = response.data?.token else { return }
                    Tokens.shared.accessToken.value = token.accessToken
                    Tokens.shared.refreshToken.value = token.refreshToken
                    self.moveToHome()
                } else {
                    self.showLoginErrorAlertSubject.onNext(())
                }
            }).disposed(by: disposeBag)
    }
    
    func moveToHome() {
        guard let coordinator = self.sceneCoordinator as? SceneCoordinator else { return }
        let homeScene = Scene.home(coordinator)
        self.sceneCoordinator.transition(to: homeScene, using: .root, animated: true)
    }
}
