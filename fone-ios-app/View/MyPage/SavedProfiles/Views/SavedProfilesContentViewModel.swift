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
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        fetch()
    }
    
    func fetch() {
        profileInfoProvider.rx.request(.profilesWanted)
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
                            job: Job.getType(name: $0.userJob)
                        )
                    }
                    owner.savedProfiles.accept(profiles)
                },
                onError: { [weak self] error in
                    error.localizedDescription.toast()
                }).disposed(by: disposeBag)
        
    }
}
