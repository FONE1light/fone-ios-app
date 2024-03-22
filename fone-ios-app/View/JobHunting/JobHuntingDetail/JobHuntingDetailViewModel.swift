//
//  JobHuntingDetailViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/13/23.
//

import RxSwift

final class JobHuntingDetailViewModel: CommonViewModel {
    private var disposeBag = DisposeBag()
    
    var jobType: Job?
    var jobHuntingDetail: ProfileContent
    
    var saveSubject = PublishSubject<Bool>()
    
    lazy var authorInfo = AuthorInfo(
        createdAt: jobHuntingDetail.createdAt,
        profileUrl: jobHuntingDetail.userProfileURL,
        nickname: jobHuntingDetail.userNickname,
        userJob: jobHuntingDetail.userJob,
        viewCount: jobHuntingDetail.viewCount,
        instagramUrl: jobHuntingDetail.registerDetailInfo?.snsUrls?.filter { $0.sns == "INSTAGRAM" }.first?.url,
        youtubeUrl: jobHuntingDetail.registerDetailInfo?.snsUrls?.filter { $0.sns == "YOUTUBE" }.first?.url
    )
    
    var actorInfo: ActorInfo?
    var staffInfo: StaffInfo?
    
    init(sceneCoordinator: SceneCoordinatorType, jobHuntingDetail: ProfileContent) {
        self.jobHuntingDetail = jobHuntingDetail
        super.init(sceneCoordinator: sceneCoordinator)
        
        guard let jobType = Job.getType(name: jobHuntingDetail.type) else { return }
        switch jobType {
        case .actor: setActorInfo()
        case .staff: setStaffInfo()
        default: break
        }
    }
}

extension JobHuntingDetailViewModel {

    private func setActorInfo() {
        actorInfo = ActorInfo(
            name: jobHuntingDetail.registerBasicInfo?.name,
            gender: GenderType.getType(serverName: jobHuntingDetail.registerDetailInfo?.gender),
            birthYear: jobHuntingDetail.registerDetailInfo?.birthday?.birthYear(separator: "-"),
            age: "\(jobHuntingDetail.age ?? 0)",
            height: "\(jobHuntingDetail.registerDetailInfo?.height ?? 0)",
            weight: "\(jobHuntingDetail.registerDetailInfo?.weight ?? 0)",
            email: jobHuntingDetail.registerDetailInfo?.email,
            specialty: jobHuntingDetail.registerDetailInfo?.specialty
        )
    }
    
    private func setStaffInfo() {
        staffInfo = StaffInfo(
            name: jobHuntingDetail.registerBasicInfo?.name,
            gender: GenderType.getType(serverName: jobHuntingDetail.registerDetailInfo?.gender),
            birthYear: jobHuntingDetail.registerDetailInfo?.birthday?.birthYear(separator: "-"),
            age: "\(jobHuntingDetail.age ?? 0)",
            domains: jobHuntingDetail.registerDetailInfo?.domains,
            email: jobHuntingDetail.registerDetailInfo?.email,
            specialty: jobHuntingDetail.registerDetailInfo?.specialty
        )
    }
}

extension JobHuntingDetailViewModel {
    func saveProfile() {
        guard let id = jobHuntingDetail.id else { return }
        
        profileInfoProvider.rx.request(.profileWant(profileId: id))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess != true {
                        "프로필 찜하기를 실패했습니다.".toast()
                    }
                    let isWant = owner.jobHuntingDetail.isWant ?? false
                    owner.jobHuntingDetail.isWant = !isWant
                    owner.saveSubject.onNext(!isWant)
                },
                onError: { error in
                    error.showToast(modelType: ProfilesData.self)
                })
            .disposed(by: disposeBag)
    }
}
extension JobHuntingDetailViewModel {
    
    func moveToJobHuntingProfiles() {
        let jobHuntingProfilesViewModel = JobHuntingProfilesViewModel(sceneCoordinator: sceneCoordinator)
        
        jobHuntingProfilesViewModel.name = jobHuntingDetail.registerBasicInfo?.name
        jobHuntingProfilesViewModel.imageUrls = jobHuntingDetail.registerBasicInfo?.profileImages
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
        guard let imageUrl = jobHuntingDetail.registerBasicInfo?.profileImages?[index] else { return }
        let profileViewModel = ProfilePreviewViewModel(sceneCoordinator: sceneCoordinator, imageUrl: imageUrl)
        sceneCoordinator.transition(to: .profilePreview(profileViewModel), using: .fullScreenModal, animated: true)
    }
}
