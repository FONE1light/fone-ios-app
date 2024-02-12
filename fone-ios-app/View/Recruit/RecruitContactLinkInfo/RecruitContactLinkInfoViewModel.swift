//
//  RecruitContactLinkInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2/9/24.
//

import Foundation

final class RecruitContactLinkInfoViewModel: CommonViewModel {
    var jobType: Job?
    
    func moveToNextStep() {
        let recruitBasicInfoViewModel = RecruitBasicInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType)
        let recruitBasicInfoScene = Scene.recruitBasicInfo(recruitBasicInfoViewModel)
        sceneCoordinator.transition(to: recruitBasicInfoScene, using: .push, animated: true)
    }
}
