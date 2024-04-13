//
//  ReportBottomSheetViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 4/10/24.
//

import Foundation

class ReportBottomSheetViewModel: CommonViewModel {
    let profileImageURL: String?
    let nickname: String?
    let userJob: String?
    let from: JobSegmentType?
    let typeId: Int?
    
    init(sceneCoordinator: SceneCoordinatorType, profileImageURL: String?, nickname: String?, userJob: String?, from: JobSegmentType?, typeId: Int?) {
        self.profileImageURL = profileImageURL
        self.nickname = nickname
        self.userJob = userJob
        self.from = from
        self.typeId = typeId
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
}
