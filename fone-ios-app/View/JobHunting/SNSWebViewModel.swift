//
//  SNSWebViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/15/23.
//

import Foundation

class SNSWebViewModel: CommonViewModel {
    
    var url: String?
    var title: String?
    
    init(sceneCoordinator: SceneCoordinatorType, url: String, title: String = "개인 SNS") {
        super.init(sceneCoordinator: sceneCoordinator)
        self.url = url
        self.title = title
    }
}
