//
//  JobHuntingDetailViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import Foundation

final class JobHuntingDetailViewModel: CommonViewModel {
    var jobHuntingDetail: JobOpeningContent? // FIXME: JobHuntingContent?
    
    lazy var authorInfo = AuthorInfo(createdAt: jobHuntingDetail?.createdAt, profileUrl: jobHuntingDetail?.profileURL, nickname: jobHuntingDetail?.nickname, userJob: jobHuntingDetail?.userJob, viewCount: jobHuntingDetail?.viewCount)
    
    lazy var titleInfo = TitleInfo(categories: jobHuntingDetail?.categories, title: jobHuntingDetail?.title)
    
    lazy var recruitCondition = RecruitCondition(type: jobHuntingDetail?.type, deadLine: jobHuntingDetail?.deadline, dday: jobHuntingDetail?.dday, casting: jobHuntingDetail?.casting, gender: jobHuntingDetail?.gender, career: jobHuntingDetail?.career, domains: jobHuntingDetail?.domains, numberOfRecruits: jobHuntingDetail?.numberOfRecruits, ageMin: jobHuntingDetail?.ageMin, ageMax: jobHuntingDetail?.ageMax)
    
    init(sceneCoordinator: SceneCoordinatorType, jobHuntingDetail: JobOpeningContent) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobHuntingDetail = jobHuntingDetail
    }
}
