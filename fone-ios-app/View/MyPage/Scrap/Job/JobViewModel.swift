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
    var jobScraps = PublishRelay<[JobOpening]?>()
    
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
                        let categories = jobOpening.recruitBasicInfo?.categories?.compactMap { Category.getType(serverName: $0) }
                        let jobType = Job.getType(name: jobOpening.type)
                        let genre = Genre.getType(name: jobOpening.recruitWorkInfo?.genres?.first)?.koreanName
                        let domain = Domain.getType(serverName: jobOpening.recruitConditionInfo?.domains?.first)?.name
                        return JobOpening(
                            id: jobOpening.id,
                            profileUrl: jobOpening.userProfileURL,
                            isVerified: jobOpening.isVerified,
                            categories: categories,
                            isScrap: jobOpening.isScrap,
                            title: jobOpening.recruitBasicInfo?.title,
                            dDay: jobOpening.dday,
                            genre: genre,
                            domain: domain,
                            produce: jobOpening.recruitWorkInfo?.produce,
                            job: jobType
                        )
                    }
                    
                    owner.jobScraps.accept(jobScraps)
                },
                onError: { error in
                    error.showToast(modelType: JobOpeningsData.self)
                }).disposed(by: disposeBag)
    }
    
    func toggleScrap(id: Int?) {
        guard let id = id else { return }
        jobOpeningInfoProvider.rx.request(.scrapJobOpening(jobOpeningId: id))
            .mapObject(Result<ScrapJobOpeningResponseResult>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess != true {
                        "스크랩을 실패했습니다.".toast()
                    }
                },
                onError: { error in
                    error.showToast(modelType: ScrapJobOpeningResponseResult.self)
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
