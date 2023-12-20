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
    
    // FIXME: 아마도 jobHuntingDetail 하나로 통합
    var mockUrls: [String]?
    
    lazy var authorInfo = AuthorInfo(
        createdAt: jobHuntingDetail?.createdAt,
        profileUrl: jobHuntingDetail?.profileURL,
        nickname: jobHuntingDetail?.nickname,
        userJob: jobHuntingDetail?.userJob,
        viewCount: jobHuntingDetail?.viewCount
    )
    
    lazy var titleInfo = TitleInfo(categories: jobHuntingDetail?.categories, title: jobHuntingDetail?.title)
    
    lazy var recruitCondition = RecruitCondition(type: jobHuntingDetail?.type, deadLine: jobHuntingDetail?.deadline, dday: jobHuntingDetail?.dday, casting: jobHuntingDetail?.casting, gender: jobHuntingDetail?.gender, career: jobHuntingDetail?.career, domains: jobHuntingDetail?.domains, numberOfRecruits: jobHuntingDetail?.numberOfRecruits, ageMin: jobHuntingDetail?.ageMin, ageMax: jobHuntingDetail?.ageMax)
    
    init(sceneCoordinator: SceneCoordinatorType, jobHuntingDetail: JobOpeningContent) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobHuntingDetail = jobHuntingDetail
    }
    
    // TODO: API 통신
    func fetchJobHuntingDetail() {
        authorInfo = AuthorInfo(
            createdAt: jobHuntingDetail?.createdAt,
            profileUrl: jobHuntingDetail?.profileURL,
            nickname: jobHuntingDetail?.nickname,
            userJob: jobHuntingDetail?.userJob,
            viewCount: jobHuntingDetail?.viewCount,
            instagramUrl: "https://www.instagram.com/fone.wing/",
            youtubeUrl: "https://www.youtube.com/"
        )
        let mockUrlCat = "https://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRoT6NNDUONDQmlthWrqIi_frTjsjQT4UZtsJsuxqxLiaFGNl5s3_pBIVxS6-VsFUP_"
        let mockUrlDog = "https://thumbor.forbes.com/thumbor/fit-in/900x510/https://www.forbes.com/advisor/wp-content/uploads/2023/07/top-20-small-dog-breeds.jpeg.jpg"
        
        mockUrls = [mockUrlCat, mockUrlDog, mockUrlCat, mockUrlCat, mockUrlCat, mockUrlCat, mockUrlCat, mockUrlCat, mockUrlCat]
    }
    
    func moveToJobHuntingProfiles() {
        let jobHuntingProfilesViewModel = JobHuntingProfilesViewModel(sceneCoordinator: sceneCoordinator)
        jobHuntingProfilesViewModel.name = authorInfo?.nickname
        jobHuntingProfilesViewModel.imageUrls = mockUrls
        let scene = Scene.jobHuntingProfiles(jobHuntingProfilesViewModel)
        sceneCoordinator.transition(to: scene, using: .fullScreenModal, animated: false)
    }
    
    func moveToSNSWebView(_ url: String?) {
        guard let url = url else { return }
        let viewModel = SNSWebViewModel(sceneCoordinator: sceneCoordinator, url: url)
        let scene = Scene.snsWebViewController(viewModel)
        sceneCoordinator.transition(to: scene, using: .fullScreenModal, animated: true)
    }
    
    func showProfilePreviewBottomSheet(of index: Int) {
        guard let imageUrl = mockUrls?[index] else { return }
        sceneCoordinator.transition(to: .profilePreviewBottomSheet(imageUrl), using: .pageSheetModal, animated: true)
    }
}
