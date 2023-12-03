//
//  RecruitDetailViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import Foundation

final class JobOpeningDetailViewModel: CommonViewModel {
    var jobOpeningDetail: JobOpeningContent?
    
    lazy var authorInfo = AuthorInfo(createdAt: jobOpeningDetail?.createdAt, profileUrl: jobOpeningDetail?.profileURL, nickname: jobOpeningDetail?.nickname, userJob: jobOpeningDetail?.userJob, viewCount: jobOpeningDetail?.viewCount)
    
    lazy var titleInfo = TitleInfo(categories: jobOpeningDetail?.categories, title: jobOpeningDetail?.title)
    
    lazy var recruitCondition = RecruitCondition(type: jobOpeningDetail?.type, deadLine: jobOpeningDetail?.deadline, dday: jobOpeningDetail?.dday, casting: jobOpeningDetail?.casting, gender: jobOpeningDetail?.gender, career: jobOpeningDetail?.career, domains: jobOpeningDetail?.domains, numberOfRecruits: jobOpeningDetail?.numberOfRecruits, ageMin: jobOpeningDetail?.ageMin, ageMax: jobOpeningDetail?.ageMax)
    
    init(sceneCoordinator: SceneCoordinatorType, jobOpeningDetail: JobOpeningContent) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobOpeningDetail = jobOpeningDetail
    }
}
