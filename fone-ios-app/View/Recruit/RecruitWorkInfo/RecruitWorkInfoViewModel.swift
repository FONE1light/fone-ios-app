//
//  RecruitWorkInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/7/23.
//

import Foundation

final class RecruitWorkInfoViewModel: CommonViewModel {
    var jobType: Job?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    
    func moveToNextStep() {
        let recruitWorkConditionViewModel = RecruitWorkConditionViewModel(sceneCoordinator: sceneCoordinator)
        recruitWorkConditionViewModel.jobType = jobType
        let recuirtWorkConditionScene = Scene.recruitWorkCondition(recruitWorkConditionViewModel)
        sceneCoordinator.transition(to: recuirtWorkConditionScene, using: .push, animated: true)
    }
}
