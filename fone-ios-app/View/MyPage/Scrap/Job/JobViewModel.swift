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
        
        fetchJobScraps()
    }
    
    private func fetchJobScraps() {
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

extension JobViewModel {
    /// 구인구직 상세(모집 상세)로 이동
    func goJobOpeningDetail(jobOpeningId: Int, type: Job) {
        jobOpeningInfoProvider.rx.request(.jobOpeningDetail(jobOpeningId: jobOpeningId, type: type))
            .mapObject(JobOpeningInfo.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                guard let jobOpening = response.data?.jobOpening else {
                    response.message.toast()
                    return }
                let viewModel = JobOpeningDetailViewModel(sceneCoordinator: owner.sceneCoordinator, jobOpeningDetail: jobOpening)
                let detailScene = Scene.jobOpeningDetail(viewModel)
                owner.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
            },
            onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
}
