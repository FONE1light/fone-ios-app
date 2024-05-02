//
//  EmailSignUpViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/02.
//

import Foundation
import RxSwift

class EmailSignUpViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    var emailTextSubject = BehaviorSubject<String>(value: "")
    var emailSendedSubject = BehaviorSubject<Bool>(value: false)
    var emailConfirmedSubject = BehaviorSubject<Bool>(value: false)
    var passwordTextSubject = BehaviorSubject<String>(value: "")
    var confirmPasswordTextSubjext = BehaviorSubject<String>(value: "")
    
    lazy var emailIsValidSubject: Observable<Bool> = {
        emailTextSubject
            .filter { $0 != "" }
            .map { $0.isValidEmail() }
    }()
    
    lazy var passwordIsValidSubject: Observable<Bool> = {
        passwordTextSubject
            .filter { $0 != "" }
            .map { $0.isValidPassword() }
    }()
    
    lazy var confirmPasswordIsValidSubject: Observable<Bool> = {
        Observable.combineLatest(passwordTextSubject, confirmPasswordTextSubjext)
            .filter { $1 != "" }
            .map { $0 == $1 }
    }()
    
    lazy var nextButtonEnabled: Observable<Bool> = {
        Observable.combineLatest(emailIsValidSubject, emailConfirmedSubject, passwordIsValidSubject, confirmPasswordIsValidSubject)
            .map{ $0 && $1 && $2 && $3}
    }()
    
    func moveToSignUp(name: String, email: String, password: String) {
        let signUpSelectionViewModel = SignUpSelectionViewModel(sceneCoordinator: self.sceneCoordinator)
        let emailSignInInfo = EmailSignInInfo(email: email, password: password)
        let signInInfo = SignInInfo(
            type: .email,
            name: name,
            email: email,
            emailSignInInfo: emailSignInInfo
        )
        signUpSelectionViewModel.signInInfo = signInInfo
        
        let signUpScene = Scene.signUpSelection(signUpSelectionViewModel)
        self.sceneCoordinator.transition(to: signUpScene, using: .push, animated: true)
    }
    
    func checkEmail(email: String) {
        userInfoProvider.rx.request(.checkEmail(email: email))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result?.isSuccess ?? false {
                    owner.sendEmail(email: email)
                } else {
                    response.message?.toast(positionType: .withBottomSheet)
                }
            }, onError: { error in
                error.showToast(modelType: String.self, positionType: .withBottomSheet)
            }).disposed(by: disposeBag)
    }
    
    func sendEmail(email: String) {
        userInfoProvider.rx.request(.sendEmail(email: email))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result?.isSuccess ?? false {
                    "인증번호를 전송하였습니다.".toast(positionType: .withBottomSheet)
                    owner.emailSendedSubject.onNext(true)
                }
            }).disposed(by: disposeBag)
    }
}
