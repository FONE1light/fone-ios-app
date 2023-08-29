//
//  LoginViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import Foundation

class LoginViewModel: CommonViewModel {
    func moveToQuestion() {
        let questionViewModel = QuestionViewModel(sceneCoordinator: self.sceneCoordinator)
        let questionPasswordScene = Scene.question(questionViewModel)
        self.sceneCoordinator.transition(to: questionPasswordScene, using: .fullScreenModal, animated: true)
    }
}
