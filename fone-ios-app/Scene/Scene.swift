//
//  Scene.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit

enum Scene {
    case home(SceneCoordinator)
    case login(LoginViewModel)
    case findIDPassword(FindIDPasswordViewModel)
    case signUpSelection(SignUpViewModel) // 회원가입1
    case signUpInfo(SignUpViewModel) // 회원가입2
    case signUpPhoneNumber(SignUpViewModel) // 회원가입3
    case signUpSuccess(SignUpViewModel) // 회원가입 완료
    case question(QuestionViewModel)
    case emailLogin(EmailLoginViewModel)
    case emailSignUp(EmailSignUpViewModel)
    case notification
}

extension Scene {
    func instantiate() -> UIViewController {
        switch self {
        case .home(let coordinator):
            let tabBarController = TabBarViewController(coordinator: coordinator)
            
            return tabBarController
            
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
            
        case .signUpSelection(let signUpViewModel):
            var signUpVC = SignUpSelectionViewController()

            DispatchQueue.main.async {
                signUpVC.bind(viewModel: signUpViewModel)
            }

            return signUpVC
            
        case .signUpInfo(let signUpViewModel):
            var signUpVC = SignUpInfoViewController()
            
            DispatchQueue.main.async {
                signUpVC.bind(viewModel: signUpViewModel)
            }
            
            return signUpVC
            
        case .signUpPhoneNumber(let signUpViewModel):
            var signUpVC = SignUpPhoneNumberViewController()
            
            DispatchQueue.main.async {
                signUpVC.bind(viewModel: signUpViewModel)
            }
            
            return signUpVC
            
        case .signUpSuccess(let signUpViewModel):
            var signUpVC = SignUpSuccessViewController()
            
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
        case .notification:
            let notiVC = NotiViewController()
            
            return notiVC
        }
    }
}
