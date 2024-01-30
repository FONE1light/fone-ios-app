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
}
