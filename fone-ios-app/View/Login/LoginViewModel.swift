//
//  LoginViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit

class LoginViewModel: CommonViewModel {
    func moveToEmailLogin() {
        let emailLoginViewModel = EmailLoginViewModel(sceneCoordinator: self.sceneCoordinator)
        let emailLoginScene = Scene.emailLogin(emailLoginViewModel)
        self.sceneCoordinator.transition(to: emailLoginScene, using: .fullScreenModal, animated: true)
    }
    
    func moveToEmailSignUp() {
        let emailSignUpViewModel = EmailSignUpViewModel(sceneCoordinator: self.sceneCoordinator)
        let emailSignUpScene = Scene.emailSignUp(emailSignUpViewModel)
        self.sceneCoordinator.transition(to: emailSignUpScene, using: .fullScreenModal, animated: true)
    }
    
    func moveToQuestion() {
        let questionViewModel = QuestionViewModel(sceneCoordinator: self.sceneCoordinator)
        let questionScene = Scene.question(questionViewModel)
        self.sceneCoordinator.transition(to: questionScene, using: .fullScreenModal, animated: true)
    }
    
    func loginWithKakaoTalk() {
        SocialLoginManager.shared.updateCoordinator(sceneCoordinator)
        SocialLoginManager.shared.loginWithKakaoTalk()
    }
    
    func loginWithGoogle(presentingVC: UIViewController) {
        SocialLoginManager.shared.updateCoordinator(sceneCoordinator)
        SocialLoginManager.shared.loginWithGoogle(presentingVC: presentingVC)
    }
    
    func loginWithApple(presentingVC: UIViewController) {
        SocialLoginManager.shared.updateCoordinator(sceneCoordinator)
        SocialLoginManager.shared.loginWithApple(presentingVC: presentingVC)
    }
}
