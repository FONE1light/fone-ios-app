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
                    // TODO: 로그인 성공 후 처리
                    
                    UserDefaults.standard.set(response.data?.token.accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(response.data?.token.refreshToken, forKey: "refreshToken")
                    
                    response.data?.token.accessToken.toast(isKeyboardShowing: self.isKeyboardShowing)
                } else {
                    self.showLoginErrorAlertSubject.onNext(())
                    response.message.toast(isKeyboardShowing: self.isKeyboardShowing)
                }
            }).disposed(by: disposeBag)
    }
}
