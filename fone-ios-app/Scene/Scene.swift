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
        }
    }
}
