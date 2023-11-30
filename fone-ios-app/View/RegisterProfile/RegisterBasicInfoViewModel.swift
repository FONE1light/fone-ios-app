//
//  RegisterBasicInfoViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/18/23.
//

import Foundation

class RegisterBasicInfoViewModel: CommonViewModel {
    
    var jobType: Job?
    
    func moveToRegisterDetailInfo() {
        let sceneCoordinator = sceneCoordinator
        
        var scene: Scene
        
        switch jobType {
        case .actor:
            let registerDetailInfoViewModel = RegisterDetailInfoViewModel(sceneCoordinator: sceneCoordinator)
            scene = Scene.registerDetailInfo(registerDetailInfoViewModel)
        case .staff:
            let registerDetailInfoStaffViewModel = RegisterDetailInfoStaffViewModel(sceneCoordinator: sceneCoordinator)
            scene = Scene.registerDetailInfoStaff(registerDetailInfoStaffViewModel)
        default: return
        }
        
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
