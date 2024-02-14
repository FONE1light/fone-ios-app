//
//  RecruitDetailViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import Foundation

final class JobOpeningDetailViewModel: CommonViewModel {
    var jobOpeningDetail: JobOpeningContent?
    
    lazy var authorInfo = AuthorInfo(createdAt: jobOpeningDetail?.createdAt, profileUrl: jobOpeningDetail?.userProfileURL, nickname: jobOpeningDetail?.userNickname, userJob: jobOpeningDetail?.userJob, viewCount: jobOpeningDetail?.viewCount)
    
    lazy var titleInfo = TitleInfo(categories: jobOpeningDetail?.recruitBasicInfo?.categories, title: jobOpeningDetail?.recruitBasicInfo?.title)
    
    lazy var recruitCondition = RecruitCondition(type: jobOpeningDetail?.type, recruitmentEndDate: jobOpeningDetail?.recruitBasicInfo?.recruitmentEndDate, dday: jobOpeningDetail?.dday, recruitConditionInfo: jobOpeningDetail?.recruitConditionInfo)
    
    init(sceneCoordinator: SceneCoordinatorType, jobOpeningDetail: JobOpeningContent) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobOpeningDetail = jobOpeningDetail
    }
}
