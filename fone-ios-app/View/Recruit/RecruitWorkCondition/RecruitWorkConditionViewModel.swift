//
//  RecruitWorkConditionViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/7/23.
//

import Foundation

struct RecruitWorkConditionInfo {
    let workingCity, workingDistrict: String?
    let workingStartDate, workingEndDate: String?
    let selectedDay: [String]?
    let workingStartTime, workingEndTime: String?
    let salaryType: String?
    let salary: Int?
}

final class RecruitWorkConditionViewModel: CommonViewModel {
    var jobType: Job?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    var recruitWorkInfo: RecruitWorkInfo?
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitBasicInfo: RecruitBasicInfo?, recruitConditionInfo: RecruitConditionInfo?, recruitWorkInfo: RecruitWorkInfo?) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitBasicInfo = recruitBasicInfo
        self.recruitConditionInfo = recruitConditionInfo
        self.recruitWorkInfo = recruitWorkInfo
    }
    
    func showSalaryTypeBottomSheet() {
        sceneCoordinator.transition(to: .salaryTypeBottomSheet(sceneCoordinator), using: .customModal, animated: true)
    }
    
    func moveToNextStep(recruitWorkConditionInfo: RecruitWorkConditionInfo) {
        let recruitDetailInfoViewModel = RecruitDetailInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo, recruitWorkInfo: recruitWorkInfo, recruitWorkConditionInfo: recruitWorkConditionInfo)
        let recuirtDetailInfoScene = Scene.recruitDetailInfo(recruitDetailInfoViewModel)
        sceneCoordinator.transition(to: recuirtDetailInfoScene, using: .push, animated: true)
    }
}
