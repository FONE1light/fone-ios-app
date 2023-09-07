//
//  Scene.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit

enum Scene {
    //    case home()
    case login(LoginViewModel)
    case findIDPassword(FindIDPasswordViewModel)
    case signUp(SignUpViewModel)
    case question(QuestionViewModel)
    case emailLogin(EmailLoginViewModel)
    case emailSignUp(EmailSignUpViewModel)
}

extension Scene {
    func instantiate() -> UIViewController {
        switch self {
        case .login(let loginViewModel):
            var loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            
            DispatchQueue.main.async {
                loginVC.bind(viewModel: loginViewModel)
            }
            
            let loginNav = UINavigationController(rootViewController: loginVC)
            
            return loginNav
            
        case .findIDPassword(let findIDPasswordViewModel):
            var findIDPasswordVC = FindIDPasswordViewController(nibName: "FindIDPasswordViewController", bundle: nil)
            
            DispatchQueue.main.async {
                findIDPasswordVC.bind(viewModel: findIDPasswordViewModel)
            }
            
            return findIDPasswordVC
            
        case .signUp(let signUpViewModel):
            var signUpVC = SignUpViewController()
            
            DispatchQueue.main.async {
                signUpVC.bind(viewModel: signUpViewModel)
            }
            
            return signUpVC
            
        case .question(let questionViewModel):
            var questionVC = QuestionViewController(nibName: "QuestionViewController", bundle: nil)
            
            DispatchQueue.main.async {
                questionVC.bind(viewModel: questionViewModel)
            }
            
            return questionVC
            
        case .emailLogin(let emailLoginViewModel):
            var emailLoginVC = EmailLoginViewController(nibName: "EmailLoginViewController", bundle: nil)
            
            DispatchQueue.main.async {
                emailLoginVC.bind(viewModel: emailLoginViewModel)
            }
            
            let emailLoginNav = UINavigationController(rootViewController: emailLoginVC)
            
            return emailLoginNav
            
        case .emailSignUp(let emailSignUpViewModel):
            var emailSignUpVC = EmailSignUpViewController(nibName: "EmailSignUpViewController", bundle: nil)
            
            DispatchQueue.main.async {
                emailSignUpVC.bind(viewModel: emailSignUpViewModel)
            }
            
            let emailSignUpNav = UINavigationController(rootViewController: emailSignUpVC)
            
            return emailSignUpNav
        }
    }
}
