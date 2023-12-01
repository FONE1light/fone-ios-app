//
//  RegisterCareerViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/27/23.
//

import Foundation

class RegisterCareerViewModel: CommonViewModel {
    
    func moveToRegisterInterest() {
        let sceneCoordinator = sceneCoordinator
        let registerInterestViewModel = RegisterInterestViewModel(sceneCoordinator: sceneCoordinator)
        
        let scene = Scene.registerInterest(registerInterestViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
