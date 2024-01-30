//
//  JobViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/02.
//

import Foundation
import RxSwift
import RxCocoa

class JobViewModel: CommonViewModel {
    
    private var disposeBag = DisposeBag()
    
    var jobScraps = PublishRelay<[JobScrap]?>()
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        fetchScraps()
    }
    
    private func fetchScraps() {
        jobOpeningInfoProvider.rx.request(.scraps)
            .mapObject(Result<JobOpeningsData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
//                    print(response.data?.jobOpenings?.content)
                    let jobOpeningsContent = response.data?.jobOpenings?.content
                    
                    let jobScraps = jobOpeningsContent?.map { jobOpening in
                        let categories = jobOpening.categories?.compactMap { Category.getType(serverName: $0) }
                        let jobType = Job.getType(name: jobOpening.type)
                        let genre = Genre.getType(name: jobOpening.work?.genres?.first)?.koreanName
                        let domain = Domain.getType(serverName: jobOpening.domains?.first)?.name
                        return JobScrap(
                            id: jobOpening.id,
                            profileUrl: jobOpening.profileURL,
                            isVerified: jobOpening.isVerified,
                            categories: categories,
                            isScrap: jobOpening.isScrap,
                            title: jobOpening.title,
                            dDay: jobOpening.dday,
                            genre: genre,
                            domain: domain,
                            produce: jobOpening.work?.produce,
                            job: jobType
                        )
                    }
                    
                    owner.jobScraps.accept(jobScraps)
                },
                onError: { error in
                    error.showToast(modelType: JobOpeningsData.self)
                }).disposed(by: disposeBag)
    }
}
