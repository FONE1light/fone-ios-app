//
//  RegisterDetailInfoStaffViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/28/23.
//

import UIKit
import RxRelay

class RegisterDetailInfoStaffViewModel: CommonViewModel {
    
    let selectedDomains = BehaviorRelay<[Selection]>(value: [])
    
    func moveToRegisterDetailContent() {
        let sceneCoordinator = sceneCoordinator
        let registerDetailContentViewModel = RegisterDetailContentViewModel(sceneCoordinator: sceneCoordinator)
        registerDetailContentViewModel.jobType = .staff
        
        let scene = Scene.registerDetailContent(registerDetailContentViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
