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
    case profileDetail(profileId: Int, type: Job)
}

extension ProfileInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        switch self {
        case .profiles:
            return "/api/v1/profiles"
        case .profileDetail(let profileId, _):
            return "/api/v1/profiles/\(profileId)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .profiles(type, sort):
            return .requestParameters(parameters: ["type": type.name, "sort": sort], encoding: URLEncoding.default)
        case let .profileDetail(_, type):
            return .requestParameters(parameters: ["type": type.name], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .profiles, .profileDetail:
            let accessToken = Tokens.shared.accessToken.value
            let authorization = "Bearer \(accessToken)"
            return ["Authorization": authorization]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

let profileInfoProvider = MoyaProvider<ProfileInfoTarget>(session: Session(interceptor: AuthInterceptor.shared))