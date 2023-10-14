//
//  TabBarType.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit

enum TabBarType {
    case savedProfiles
    case myRegistrations
}

extension TabBarType {
    var titles: [String] {
        switch self {
        case .savedProfiles: return ["배우", "스태프"]
        case .myRegistrations: return ["모집", "프로필"]
        }
    }
    
    var viewControllers: [UIViewController] {
        switch self {
        case .savedProfiles:
            return [
                SavedProfilesContentViewController(backgroundColor: .beige_624418), // 배우 탭
                SavedProfilesContentViewController(backgroundColor: .gray) // 스태프 탭
            ]
        case .myRegistrations:
            return [
               ScrapViewController(), // 모집 탭
               ProfileRegistrationViewController() // 프로필 탭
            ]
        }
    }
}
