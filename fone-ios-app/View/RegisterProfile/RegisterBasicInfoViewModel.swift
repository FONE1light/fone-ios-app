//
//  RegisterBasicInfoViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/18/23.
//

import Foundation

class RegisterBasicInfoViewModel: CommonViewModel {
    
    func moveToRegisterDetailInfo() {
        let sceneCoordinator = sceneCoordinator
        let registerDetailInfoViewModel = RegisterDetailInfoViewModel(sceneCoordinator: sceneCoordinator)
        
        let scene = Scene.registerDetailInfo(registerDetailInfoViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
