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
        Observable.combineLatest(emailIsValidSubject, passwordIsValidSubject, confirmPasswordIsValidSubject)
            .map{ $0 && $1 && $2}
    }()
    
    func moveToSignUp(email: String, password: String) {
        let signUpSelectionViewModel = SignUpSelectionViewModel(sceneCoordinator: self.sceneCoordinator)
        signUpSelectionViewModel.signInInfo = EmailSignInInfo(email: email, password: password)
        
        let signUpScene = Scene.signUpSelection(signUpSelectionViewModel)
        self.sceneCoordinator.transition(to: signUpScene, using: .push, animated: true)
    }
}
