//
//  JobRegistrationViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit
import RxSwift
import RxCocoa

class JobRegistrationViewModel: CommonViewModel {
    
    private var disposeBag = DisposeBag()
    var jobRegistrations = PublishRelay<[JobOpening]?>()
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        fetchRegistrations()
    }
    
    private func fetchRegistrations() {
        jobOpeningInfoProvider.rx.request(.myRegistrations)
            .mapObject(Result<JobOpeningsData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    let jobOpeningsContent = response.data?.jobOpenings?.content
                    let jobRegistrations = jobOpeningsContent?.map { jobOpening in
                        let categories = jobOpening.categories?.compactMap { Category.getType(serverName: $0) }
                        let jobType = Job.getType(name: jobOpening.type)
                        let genre = Genre.getType(name: jobOpening.work?.genres?.first)?.koreanName
                        let domain = Domain.getType(serverName: jobOpening.domains?.first)?.name
                        return JobOpening(
                            id: jobOpening.id,
                            profileUrl: jobOpening.profileURL,
                            isVerified: jobOpening.isVerified,
                            categories: categories,
                            isScrap: nil,
                            title: jobOpening.title,
                            dDay: jobOpening.dday,
                            genre: genre,
                            domain: domain,
                            produce: jobOpening.work?.produce,
                            job: jobType
                        )
                    }
                    owner.jobRegistrations.accept(jobRegistrations)
                },
                onError: { error in
                    error.showToast(modelType: JobOpeningsData.self)
                }).disposed(by: disposeBag)
    }
}
