//
//  JobOpeningInfoProvider.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/18/23.
//

import Foundation
import Moya
import RxSwift

enum APIError: Error {
    case tokenExpired
}

enum JobOpeningInfoTarget {
    case jobOpenings(type: Job)
    case jobOpeningDetail(jobOpeningId: Int, type: Job)
}

extension JobOpeningInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        switch self {
        case .jobOpenings:
            return "/api/v1/job-openings"
        case .jobOpeningDetail(let jopOpeningId, _):
            return "/api/v1/job-openings/\(jopOpeningId)" //
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .jobOpenings(let type):
            return .requestParameters(parameters: ["type": type.name], encoding: URLEncoding.default)
        case .jobOpeningDetail(_, let type):
            return .requestParameters(parameters: ["type": type.name], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .jobOpenings, .jobOpeningDetail:
            let accessToken = Tokens.shared.accessToken.value
            let authorization = "Bearer \(accessToken)"
            return ["Authorization": authorization]
        }
    }
}

let jobOpeningInfoProvider = MoyaProvider<JobOpeningInfoTarget>()
