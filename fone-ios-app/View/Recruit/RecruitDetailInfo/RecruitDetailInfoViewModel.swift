//
//  RecruitDetailInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/10/23.
//

import Foundation

final class RecruitDetailInfoViewModel: CommonViewModel {
    var jobType: Job?
    
    func moveToNextStep() {
        let recruitContactInfoViewModel = RecruitContactInfoViewModel(sceneCoordinator: sceneCoordinator)
        recruitContactInfoViewModel.jobType = jobType
        let recuirtContactInfoScene = Scene.recruitContactInfo(recruitContactInfoViewModel)
        sceneCoordinator.transition(to: recuirtContactInfoScene, using: .push, animated: true)
    }
}
