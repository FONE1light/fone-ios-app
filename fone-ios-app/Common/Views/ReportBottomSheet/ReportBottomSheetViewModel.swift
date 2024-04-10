//
//  ReportBottomSheetViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 4/10/24.
//

import Foundation

class ReportBottomSheetViewModel: CommonViewModel {
    private let profileImageURL: String?
    private let nickname: String?
    private let userJob: String?
    
    init(sceneCoordinator: SceneCoordinatorType, profileImageURL: String?, nickname: String?, userJob: String?) {
        self.profileImageURL = profileImageURL
        self.nickname = nickname
        self.userJob = userJob
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
}
