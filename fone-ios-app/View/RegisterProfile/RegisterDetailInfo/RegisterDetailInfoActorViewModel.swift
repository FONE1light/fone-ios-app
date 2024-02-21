//
//  RegisterDetailInfoActorViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/19/23.
//

import UIKit
import RxRelay

class RegisterDetailInfoActorViewModel: CommonViewModel {
    
    func moveToRegisterDetailContent() {
        let sceneCoordinator = sceneCoordinator
        let registerDetailContentViewModel = RegisterDetailContentViewModel(sceneCoordinator: sceneCoordinator)
        registerDetailContentViewModel.jobType = .actor
        
        let scene = Scene.registerDetailContent(registerDetailContentViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
