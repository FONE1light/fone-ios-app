//
//  ProfilePreviewViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/21/23.
//

import Foundation

class ProfilePreviewViewModel: CommonViewModel {
    let imageUrl: String?
    
    init(sceneCoordinator: SceneCoordinatorType, imageUrl: String?) {
        self.imageUrl = imageUrl
        super.init(sceneCoordinator: sceneCoordinator)
    }
}
