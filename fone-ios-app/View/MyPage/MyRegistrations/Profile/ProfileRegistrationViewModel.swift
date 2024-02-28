//
//  ProfileRegistrationViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileRegistrationViewModel: CommonViewModel {
    
    private var disposeBag = DisposeBag()
    var profileRegistrations = PublishRelay<[Profile]?>()
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        fetchProfileRegistrations()
    }
    
    private func fetchProfileRegistrations() {
        profileInfoProvider.rx.request(.myRegistrations)
            .mapObject(Result<ProfilesData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
            onNext: { owner, response in
                let profilesContent = response.data?.profiles?.content
                let profiles = profilesContent?.map {
                    let birthYear = String($0.registerDetailInfo?.birthday?.split(separator: "-").first ?? "")
                    let age = "\($0.age ?? 0)"
                    return Profile(
                        id: $0.id,
                        imageUrl: $0.userProfileURL,
                        name: $0.registerBasicInfo?.name,
                        age: age,
                        isSaved: $0.isWant,
                        birthYear: birthYear,
                        job: Job.getType(name: $0.type)
                    )
                }
                
                owner.profileRegistrations.accept(profiles)
                
            },
            onError: { error in
                error.showToast(modelType: ProfilesData.self)
            }).disposed(by: disposeBag)
        
    }
    
    func deleteProfileRegistration(id: Int) {
        profileInfoProvider.rx.request(.deleteProfile(profileId: id))
            .mapObject(Result<ProfilesData>.self) // FIXME: 아래로 대체
        //            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess != true {
                        "삭제를 실패했습니다.".toast()
                    } else {
                        owner.fetchProfileRegistrations()
                    }
                },
                onError: { error in
                    error.showToast(modelType: ProfilesData.self)
                }).disposed(by: disposeBag)
    }
}

// MARK: - 화면 이동
extension ProfileRegistrationViewModel {
    /// 프로필 상세로 이동
    func goJobHuntingDetail(jobHuntingId: Int, type: Job) {
        profileInfoProvider.rx.request(.profileDetail(profileId: jobHuntingId, type: type))
            .mapObject(Result<ProfileData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
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
                print(error.localizedDescription)
                error.localizedDescription.toast()
            }).disposed(by: disposeBag)
        
    }
}
