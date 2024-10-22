//
//  TabBarType.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit

enum TabBarType {
    case scrap
    case savedProfiles
    case myRegistrations
}

extension TabBarType {
    var titles: [String] {
        switch self {
        case .scrap: return ["구인구직", "공모전"]
        case .savedProfiles: return ["배우", "스태프"]
        case .myRegistrations: return ["모집", "프로필"]
        }
    }
    
    func getViewControllers(sceneCoordinator: SceneCoordinatorType) -> [UIViewController] {
        switch self {
        case .scrap:
            let jobViewModel = JobViewModel(sceneCoordinator: sceneCoordinator)
            let competitionViewModel = CompetitionViewModel(sceneCoordinator: sceneCoordinator)
            return [
                Scene.scrapJob(jobViewModel).instantiate(),                 // 구인구직 탭
                Scene.scrapCompetition(competitionViewModel).instantiate()  // 공모전 탭
            ]
        case .savedProfiles:
            let actorViewModel = SavedProfilesContentViewModel(sceneCoordinator: sceneCoordinator, jobType: .actor)
            let staffViewModel = SavedProfilesContentViewModel(sceneCoordinator: sceneCoordinator, jobType: .staff)
            return [
                Scene.savedProfilesContent(actorViewModel).instantiate(), // 배우 탭
                Scene.savedProfilesContent(staffViewModel).instantiate()  // 스태프 탭
            ]
        case .myRegistrations:
            let jobRegistrationViewModel = JobRegistrationViewModel(sceneCoordinator: sceneCoordinator)
            let profileRegistrationViewModel = ProfileRegistrationViewModel(sceneCoordinator: sceneCoordinator)
            return [
                Scene.jobRegistrations(jobRegistrationViewModel).instantiate(), // 모집 탭
                Scene.profileRegistrations(profileRegistrationViewModel).instantiate() // 프로필 탭
            ]
        }
    }
}
