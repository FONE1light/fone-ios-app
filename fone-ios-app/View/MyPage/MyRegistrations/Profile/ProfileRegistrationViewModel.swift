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
                
                owner.profileRegistrations.accept(profiles)
                
            },
            onError: { error in
            }).disposed(by: disposeBag)
        
    }
}
