//
//  RecruitWorkInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/7/23.
//

import Foundation

struct RecruitWorkInfo {
    let produce: String?
    let workTitle: String?
    let director: String?
    let genres: [String]?
    let logline: String?
}

final class RecruitWorkInfoViewModel: CommonViewModel {
    var jobType: Job?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitBasicInfo: RecruitBasicInfo?, recruitConditionInfo: RecruitConditionInfo?) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitBasicInfo = recruitBasicInfo
        self.recruitConditionInfo = recruitConditionInfo
    }
    
    func moveToNextStep(recruitWorkInfo: RecruitWorkInfo) {
        let recruitWorkConditionViewModel = RecruitWorkConditionViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo, recruitWorkInfo: recruitWorkInfo)
        let recuirtWorkConditionScene = Scene.recruitWorkCondition(recruitWorkConditionViewModel)
        sceneCoordinator.transition(to: recuirtWorkConditionScene, using: .push, animated: true)
    }
}
