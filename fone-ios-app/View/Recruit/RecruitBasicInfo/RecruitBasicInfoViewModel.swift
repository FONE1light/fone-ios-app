//
//  RecruitBasicInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/6/23.
//

import Foundation

final class RecruitBasicInfoViewModel: CommonViewModel {
    var jobType: Job?
    
    func moveToNextStep() {
        let recruitConditionInfoViewModel = RecruitConditionInfoViewModel(sceneCoordinator: sceneCoordinator)
        recruitConditionInfoViewModel.jobType = jobType
        let recuirtConditionInfoScene = Scene.recruitConditionInfo(recruitConditionInfoViewModel)
        sceneCoordinator.transition(to: recuirtConditionInfoScene, using: .push, animated: true)
    }
}
