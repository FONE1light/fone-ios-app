//
//  RecruitDetailInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/10/23.
//

import Foundation

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
    
    func moveToNextStep() {
        let recruitContactInfoViewModel = RecruitContactInfoViewModel(sceneCoordinator: sceneCoordinator)
        recruitContactInfoViewModel.jobType = jobType
        let recuirtContactInfoScene = Scene.recruitContactInfo(recruitContactInfoViewModel)
        sceneCoordinator.transition(to: recuirtContactInfoScene, using: .push, animated: true)
    }
}
