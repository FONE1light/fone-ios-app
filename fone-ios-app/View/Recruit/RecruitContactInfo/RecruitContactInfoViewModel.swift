//
//  RecruitContactInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/13/23.
//

import Foundation
import RxSwift

struct RecruitContactInfo {
    let manager, email: String?
}

final class RecruitContactInfoViewModel: CommonViewModel {
    let disposeBag = DisposeBag()
    var jobType: Job?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    var recruitWorkInfo: RecruitWorkInfo?
    var recruitWorkConditionInfo: RecruitWorkConditionInfo?
    var recruitDetailInfo: RecruitDetailInfo?
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitBasicInfo: RecruitBasicInfo?, recruitConditionInfo: RecruitConditionInfo?, recruitWorkInfo: RecruitWorkInfo?, recruitWorkConditionInfo: RecruitWorkConditionInfo?, recruitDetailInfo: RecruitDetailInfo) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitBasicInfo = recruitBasicInfo
        self.recruitConditionInfo = recruitConditionInfo
        self.recruitWorkInfo = recruitWorkInfo
        self.recruitWorkConditionInfo = recruitWorkConditionInfo
        self.recruitDetailInfo = recruitDetailInfo
    }
    
    func createJobOpenings(recruitContactInfo: RecruitContactInfo) {
        let jobOpeningRequest = JobOpeningRequest(recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo, recruitWorkInfo: recruitWorkInfo, recruitWorkConditionInfo: recruitWorkConditionInfo, recruitDetailInfo: recruitDetailInfo, recruitContactInfo: recruitContactInfo, jobType: jobType)
        jobOpeningInfoProvider.rx.request(.createJobOpenings(jobOpeningRequest: jobOpeningRequest))
            .mapObject(JobOpeningContent.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print(response)
                
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
}
