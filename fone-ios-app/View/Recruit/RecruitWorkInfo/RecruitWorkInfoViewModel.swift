//
//  RecruitWorkInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/7/23.
//

import Foundation

struct RecruitWorkInfo {
    let produce: String
    let workTitle: String
    let director: String
    let genres: [String]
    let logline: String
}

final class RecruitWorkInfoViewModel: CommonViewModel {
    var jobType: Job?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    
    func moveToNextStep(recruitWorkInfo: RecruitWorkInfo) {
        let recruitWorkConditionViewModel = RecruitWorkConditionViewModel(sceneCoordinator: sceneCoordinator)
        recruitWorkConditionViewModel.jobType = jobType
        recruitWorkConditionViewModel.recruitBasicInfo = recruitBasicInfo
        recruitWorkConditionViewModel.recruitConditionInfo = recruitConditionInfo
        recruitWorkConditionViewModel.recruitWorkInfo = recruitWorkInfo
        let recuirtWorkConditionScene = Scene.recruitWorkCondition(recruitWorkConditionViewModel)
        sceneCoordinator.transition(to: recuirtWorkConditionScene, using: .push, animated: true)
    }
}
