//
//  RegisterDetailInfoViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/19/23.
//

import UIKit
import RxRelay

class RegisterDetailInfoViewModel: CommonViewModel {
    
    var instagramLink = BehaviorRelay<String?>(value: nil)
    var youtubeLink = BehaviorRelay<String?>(value: nil)
    
    func moveToRegisterDetailContent() {
        let sceneCoordinator = sceneCoordinator
        let registerDetailContentViewModel = RegisterDetailContentViewModel(sceneCoordinator: sceneCoordinator)
        
        let scene = Scene.registerDetailContent(registerDetailContentViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
