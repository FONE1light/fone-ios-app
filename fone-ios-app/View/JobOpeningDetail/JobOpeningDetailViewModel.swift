//
//  RecruitDetailViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import Foundation
import RxSwift

final class JobOpeningDetailViewModel: CommonViewModel {
    private var disposeBag = DisposeBag()
    var jobOpeningDetail: JobOpeningContent?
    
    var scrapSubject = PublishSubject<Bool>()
    
    lazy var authorInfo = AuthorInfo(createdAt: jobOpeningDetail?.createdAt, profileUrl: jobOpeningDetail?.userProfileURL, nickname: jobOpeningDetail?.userNickname, userJob: jobOpeningDetail?.userJob, viewCount: jobOpeningDetail?.viewCount)
    
    lazy var titleInfo = TitleInfo(categories: jobOpeningDetail?.recruitBasicInfo?.categories, title: jobOpeningDetail?.recruitBasicInfo?.title)
    
    lazy var recruitCondition = RecruitCondition(type: jobOpeningDetail?.type, recruitmentEndDate: jobOpeningDetail?.recruitBasicInfo?.recruitmentEndDate, dday: jobOpeningDetail?.dday, recruitConditionInfo: jobOpeningDetail?.recruitConditionInfo)
    
    init(sceneCoordinator: SceneCoordinatorType, jobOpeningDetail: JobOpeningContent) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobOpeningDetail = jobOpeningDetail
    }
    
    func scrapJobOpening(id: Int) {
        jobOpeningInfoProvider.rx.request(.scrapJobOpening(jobOpeningId: id))
            .mapObject(Result<ScrapJobOpeningResponseResult>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess != true {
                        "스크랩을 실패했습니다.".toast()
                    }
                    let result = response.data?.result == "SCRAPPED"
                    owner.scrapSubject.onNext(result)
                },
                onError: { error in
                    error.showToast(modelType: ScrapJobOpeningResponseResult.self)
                }).disposed(by: disposeBag)
    }
}
