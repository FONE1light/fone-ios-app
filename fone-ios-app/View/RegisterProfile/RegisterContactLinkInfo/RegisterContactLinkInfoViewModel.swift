//
//  RegisterContactLinkInfoViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/20/24.
//

import Foundation

class RegisterContactLinkInfoViewModel: CommonViewModel {
    var jobType: Job?
}

extension RegisterContactLinkInfoViewModel {
    func moveToRegisterBasicInfo() {
        let registerBasicInfoViewModel = RegisterBasicInfoViewModel(sceneCoordinator: sceneCoordinator)
        registerBasicInfoViewModel.jobType = jobType
        
        let registerScene = Scene.registerBasicInfo(registerBasicInfoViewModel)
        sceneCoordinator.transition(to: registerScene, using: .push, animated: true)
    }
}
