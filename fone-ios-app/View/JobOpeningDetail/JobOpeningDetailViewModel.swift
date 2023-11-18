//
//  RecruitDetailViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import Foundation

final class JobOpeningDetailViewModel: CommonViewModel {
    var jobOpeningDetail: JobOpeningContent?
    
    init(sceneCoordinator: SceneCoordinatorType, jobOpeningDetail: JobOpeningContent) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobOpeningDetail = jobOpeningDetail
    }
}
