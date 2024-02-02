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
        
        fetchJobRegistrations()
    }
    
    private func fetchJobRegistrations() {
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
    
    func deleteJobRegistration(id: Int) {
        jobOpeningInfoProvider.rx.request(.deleteJobOpening(jobOpeningId: id))
            .mapObject(Result<JobOpeningData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess != true {
                        "삭제를 실패했습니다.".toast()
                    } else {
                        owner.fetchJobRegistrations()
                    }
                },
                onError: { error in
                    error.showToast(modelType: JobOpeningData.self)
                }).disposed(by: disposeBag)
    }
}

// MARK: - 화면 이동
extension JobRegistrationViewModel {
    /// 모집 상세로 이동
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
