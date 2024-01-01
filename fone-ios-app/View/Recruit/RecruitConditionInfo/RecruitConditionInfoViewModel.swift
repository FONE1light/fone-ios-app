//
//  RecruitConditionInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/5/23.
//

import Foundation
import RxRelay

struct RecruitConditionInfo {
    let casting: String
    let domains: [String]
    let numberOfRecruits: Int
    let gender: String
    let ageMin, ageMax: Int
    let career: String  //FIXME: [String]이어야할 것 같은데 서버 확인 필요.
}

final class RecruitConditionInfoViewModel: CommonViewModel {
    var jobType: Job?
    var recruitBasicInfo: RecruitBasicInfo?
    let selectedDomains = BehaviorRelay<[Selection]>(value: [])
    
    func moveToNextStep(recruitConditionInfo: RecruitConditionInfo) {
        let recruitWorkInfoViewModel = RecruitWorkInfoViewModel(sceneCoordinator: sceneCoordinator)
        recruitWorkInfoViewModel.jobType = jobType
        recruitWorkInfoViewModel.recruitBasicInfo = recruitBasicInfo
        recruitWorkInfoViewModel.recruitConditionInfo = recruitConditionInfo
        let recruitWorkInfoScene = Scene.recruitWorkInfo(recruitWorkInfoViewModel)
        sceneCoordinator.transition(to: recruitWorkInfoScene, using: .push, animated: true)
    }
}
