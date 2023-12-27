//
//  ProfileInfoProvider.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/27/23.
//

import Foundation
import Moya

enum ProfileInfoTarget {
    case profiles(type: Job, sort: [String])
//    case profileDetail(profileId: Int, type: Job)
}

extension ProfileInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        switch self {
        case .profiles:
            return "/api/v1/profiles"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .profiles(let type, let sort):
            return .requestParameters(parameters: ["type": type.name, "sort": sort], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .profiles:
            let accessToken = Tokens.shared.accessToken.value
            let authorization = "Bearer \(accessToken)"
            return ["Authorization": authorization]
        }
    }
}

let profileInfoProvider = MoyaProvider<ProfileInfoTarget>()
