//
//  SavedProfilesContentViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/11.
//

import RxSwift
import RxCocoa

class SavedProfilesContentViewModel: CommonViewModel {
    
    private var disposeBag = DisposeBag()
    
    var savedProfiles = PublishRelay<[Profile]?>()
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        fetchProfilesWanted(jobType: jobType)
    }
    
    func fetchProfilesWanted(jobType: Job) {
        profileInfoProvider.rx.request(.profilesWanted(type: jobType))
            .mapObject(Result<ProfilesData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    let profilesContent = response.data?.profiles?.content
                    let profiles = profilesContent?.map {
                        let birthYear = String($0.birthday?.split(separator: "-").first ?? "")
                        let age = "\($0.age ?? 0)"
                        return Profile(
                            id: $0.id,
                            imageUrl: $0.userProfileURL,
                            name: $0.name,
                            age: age,
                            isSaved: $0.isWant,
                            birthYear: birthYear,
                            job: Job.getType(name: $0.type)
                        )
                    }
                    owner.savedProfiles.accept(profiles)
                },
                onError: { error in
                    error.showToast(modelType: ProfilesData.self)
                }).disposed(by: disposeBag)
    }
    
    func toggleWanted(id: Int?) {
        guard let id = id else { return }
        profileInfoProvider.rx.request(.profileWant(profileId: id))
            .mapObject(Result<ProfilesData>.self) // 대체
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess != true {
                        "프로필 찜하기를 실패했습니다.".toast()
                    }
                },
                onError: { error in
                    error.showToast(modelType: ProfilesData.self)
                }).disposed(by: disposeBag)
    }
}

extension SavedProfilesContentViewModel {
    /// 프로필 상세로 이동
    func goJobHuntingDetail(jobHuntingId: Int, type: Job) {
        profileInfoProvider.rx.request(.profileDetail(profileId: jobHuntingId, type: type))
            .mapObject(Result<ProfileData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    guard let profile = response.data?.profile else {
                        response.message?.toast()
                        return
                    }
                    
                    let viewModel = JobHuntingDetailViewModel(sceneCoordinator: owner.sceneCoordinator, jobHuntingDetail: profile)
                    viewModel.jobType = type
                    
                    let detailScene = Scene.jobHuntingDetail(viewModel)
                    owner.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
                },
                onError: { error in
                    error.localizedDescription.toast()
                }).disposed(by: disposeBag)
        
    }
}
