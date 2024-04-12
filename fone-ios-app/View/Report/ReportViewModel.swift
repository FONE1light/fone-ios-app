//
//  ReportViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 4/8/24.
//

import Foundation

final class ReportViewModel: CommonViewModel {
    let profileImageURL: String?
    let nickname: String?
    let userJob: String?
    
    init(sceneCoordinator: SceneCoordinatorType, profileImageURL: String?, nickname: String?, userJob: String?) {
        self.profileImageURL = profileImageURL
        self.nickname = nickname
        self.userJob = userJob
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
}
