//
//  SNSWebViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/15/23.
//

import Foundation

class SNSWebViewModel: CommonViewModel {
    
    var url: String?
    
    init(sceneCoordinator: SceneCoordinatorType, url: String) {
        super.init(sceneCoordinator: sceneCoordinator)
        self.url = url
    }
}
