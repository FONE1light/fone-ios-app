//
//  RecruitConditionInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/5/23.
//

import Foundation

final class RecruitConditionInfoViewModel: CommonViewModel {
    var jobType: Job?
    
    func moveToNextStep() {
        let recruitWorkInfoViewModel = RecruitWorkInfoViewModel(sceneCoordinator: sceneCoordinator)
        recruitWorkInfoViewModel.jobType = jobType
        let recuirtWorkInfoScene = Scene.recruitWorkInfo(recruitWorkInfoViewModel)
        sceneCoordinator.transition(to: recuirtWorkInfoScene, using: .push, animated: true)
    }
}
