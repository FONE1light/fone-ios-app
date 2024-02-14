//
//  RecruitContactLinkInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2/9/24.
//

import Foundation

struct RecruitContactLinkInfo: Codable {
    let contact: String?
    let contactMethod: String?
}

final class RecruitContactLinkInfoViewModel: CommonViewModel {
    var jobType: Job?
    
    func moveToNextStep(recruitContactLinkInfo: RecruitContactLinkInfo) {
        let recruitBasicInfoViewModel = RecruitBasicInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitContactLinkInfo: recruitContactLinkInfo)
        let recruitBasicInfoScene = Scene.recruitBasicInfo(recruitBasicInfoViewModel)
        sceneCoordinator.transition(to: recruitBasicInfoScene, using: .push, animated: true)
    }
}
