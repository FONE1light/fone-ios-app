//
//  JobHuntingDetailViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/13/23.
//

import Foundation

final class JobHuntingDetailViewModel: CommonViewModel {
    var jobType: Job?
    var jobHuntingDetail: JobOpeningContent? // FIXME: JobHuntingContent?
    
    lazy var authorInfo = AuthorInfo(createdAt: jobHuntingDetail?.createdAt, profileUrl: jobHuntingDetail?.profileURL, nickname: jobHuntingDetail?.nickname, userJob: jobHuntingDetail?.userJob, viewCount: jobHuntingDetail?.viewCount)
    
    lazy var titleInfo = TitleInfo(categories: jobHuntingDetail?.categories, title: jobHuntingDetail?.title)
    
    lazy var recruitCondition = RecruitCondition(type: jobHuntingDetail?.type, deadLine: jobHuntingDetail?.deadline, dday: jobHuntingDetail?.dday, casting: jobHuntingDetail?.casting, gender: jobHuntingDetail?.gender, career: jobHuntingDetail?.career, domains: jobHuntingDetail?.domains, numberOfRecruits: jobHuntingDetail?.numberOfRecruits, ageMin: jobHuntingDetail?.ageMin, ageMax: jobHuntingDetail?.ageMax)
    
    init(sceneCoordinator: SceneCoordinatorType, jobHuntingDetail: JobOpeningContent) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobHuntingDetail = jobHuntingDetail
    }
    
    func fetchJobHuntingContent() {
        authorInfo = AuthorInfo(
            createdAt: jobHuntingDetail?.createdAt, 
            profileUrl: jobHuntingDetail?.profileURL,
            nickname: jobHuntingDetail?.nickname,
            userJob: jobHuntingDetail?.userJob,
            viewCount: jobHuntingDetail?.viewCount,
            instagramUrl: "",
            youtubeUrl: "https://youtu.be/RuORKyaDPCo?si=9AkP2UkPg6XkaZZr"
        )
    }
    
    func moveToSNSWebView(_ url: String?) {
        guard let url = url else { return }
//        let sNSWebViewModel = SNSWebViewModel(sceneCoordinator: sceneCoordinator)
//        SNSWebViewModel.url = url
        
        let scene = Scene.snsWebViewController
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
