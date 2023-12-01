//
//  RegisterDetailContentViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/26/23.
//

import Foundation

class RegisterDetailContentViewModel: CommonViewModel {
    func moveToRegisterCareer() {
        let sceneCoordinator = sceneCoordinator
        let registerCareerViewModel = RegisterCareerViewModel(sceneCoordinator: sceneCoordinator)
        
        let scene = Scene.registerCareer(registerCareerViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
        
    }
}

