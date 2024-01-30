//
//  CompetitionInfoProvider.swift
//  fone-ios-app
//
//  Created by 여나경 on 1/30/24.
//

import Foundation
import Moya

enum CompetitionInfoTarget {
    case competitions
    case scraps
}

extension CompetitionInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        switch self {
        case .competitions:
            "/api/v1/competitions"
        case .scraps:
            "/api/v1/competitions/scraps"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
//        case let .competitions(type, sort, page, size):
//            return .requestParameters(parameters: [
//                "type": type.name,
//                "sort": sort,
//                "page": page,
//                "size": size
//            ], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            let accessToken = Tokens.shared.accessToken.value
            let authorization = "Bearer \(accessToken)"
            return ["Authorization": authorization]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

let competitionInfoProvider = MoyaProvider<CompetitionInfoTarget>(session: Session(interceptor: AuthInterceptor.shared))
