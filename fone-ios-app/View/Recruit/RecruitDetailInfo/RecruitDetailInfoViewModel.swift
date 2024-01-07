//
//  RecruitDetailInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/10/23.
//

import Foundation

struct RecruitDetailInfo {
    let details: String?
}

final class RecruitDetailInfoViewModel: CommonViewModel {
    var jobType: Job?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    var recruitWorkInfo: RecruitWorkInfo?
    var recruitWorkConditionInfo: RecruitWorkConditionInfo?
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitBasicInfo: RecruitBasicInfo?, recruitConditionInfo: RecruitConditionInfo?, recruitWorkInfo: RecruitWorkInfo?, recruitWorkConditionInfo: RecruitWorkConditionInfo?) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitBasicInfo = recruitBasicInfo
        self.recruitConditionInfo = recruitConditionInfo
        self.recruitWorkInfo = recruitWorkInfo
        self.recruitWorkConditionInfo = recruitWorkConditionInfo
    }
    
    func moveToNextStep(recruitDetailInfo: RecruitDetailInfo) {
        let recruitContactInfoViewModel = RecruitContactInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo, recruitWorkInfo: recruitWorkInfo, recruitWorkConditionInfo: recruitWorkConditionInfo, recruitDetailInfo: recruitDetailInfo)
        let recuirtContactInfoScene = Scene.recruitContactInfo(recruitContactInfoViewModel)
        sceneCoordinator.transition(to: recuirtContactInfoScene, using: .push, animated: true)
    }
}
