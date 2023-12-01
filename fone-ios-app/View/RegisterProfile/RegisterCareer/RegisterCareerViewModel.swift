//
//  RegisterCareerViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/27/23.
//

import Foundation

class RegisterCareerViewModel: CommonViewModel {
    
    var jobType: Job?
    
    func moveToRegisterInterest() {
        let sceneCoordinator = sceneCoordinator
        let registerInterestViewModel = RegisterInterestViewModel(sceneCoordinator: sceneCoordinator)
        registerInterestViewModel.jobType = jobType
        
        let scene = Scene.registerInterest(registerInterestViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
