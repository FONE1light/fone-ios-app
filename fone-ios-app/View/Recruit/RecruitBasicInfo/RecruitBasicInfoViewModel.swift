//
//  RecruitBasicInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/6/23.
//

import Foundation

struct RecruitBasicInfo {
    let title: String?
    let categories: [Category]?
    let startDate: String?
    let endDate: String?
    let imageUrls: [String]?
}

final class RecruitBasicInfoViewModel: CommonViewModel {
    var jobType: Job?
    
    func moveToNextStep(recruitBasicInfo: RecruitBasicInfo) {
        let recruitConditionInfoViewModel = RecruitConditionInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitBasicInfo: recruitBasicInfo)
        let recuirtConditionInfoScene = Scene.recruitConditionInfo(recruitConditionInfoViewModel)
        sceneCoordinator.transition(to: recuirtConditionInfoScene, using: .push, animated: true)
    }
}
