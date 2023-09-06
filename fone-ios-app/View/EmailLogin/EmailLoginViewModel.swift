//
//  EmailLoginViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/02.
//

import Foundation
import RxSwift

class EmailLoginViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    var emailTextSubject = BehaviorSubject<String>(value: "")
    var emailIsValidSubject = PublishSubject<Bool>()
    var passwordIsEmptySubject = BehaviorSubject<Bool>(value: true)
    var isKeyboardShowing = false
    
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
    
    func emailLogin(emailSignInUserRequest: EmailSignInUserRequest) {
        userInfoProvider.rx.request(.emailSignIn(emailSignInUserRequest: emailSignInUserRequest))
            .mapObject(EmailSignInResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print("received!")
                print("response: \(response)")
                if response.result == "SUCCESS" {
                    // TODO: 로그인 성공 후 처리
                } else {
                    response.message.toast(isKeyboardShowing: self.isKeyboardShowing)
                }
            }).disposed(by: disposeBag)
    }
}
