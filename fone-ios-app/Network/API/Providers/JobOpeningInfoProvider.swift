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
    case jobOpenings(type: Job, sort: [String], page: Int, size: Int)
    case createJobOpenings(jobOpeningRequest: JobOpeningRequest)
    case jobOpeningDetail(jobOpeningId: Int, type: Job)
    case scraps
}

extension JobOpeningInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        switch self {
        case .jobOpenings, .createJobOpenings:
            return "/api/v1/job-openings"
        case .jobOpeningDetail(let jopOpeningId, _):
            return "/api/v1/job-openings/\(jopOpeningId)" //
        case .scraps:
            return "/api/v1/job-openings/scraps"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .jobOpenings, .jobOpeningDetail, .scraps:
            return .get
        case .createJobOpenings:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .jobOpenings(let type, let sort, let page, let size):
            return .requestParameters(parameters: [
                "type": type.name,
                "sort": sort,
                "page": page,
                "size": size
            ], encoding: URLEncoding.default)
        case .createJobOpenings(let jobOpeningRequest):
            return .requestJSONEncodable(jobOpeningRequest)
        case .jobOpeningDetail(_, let type):
            return .requestParameters(parameters: ["type": type.name], encoding: URLEncoding.default)
        case .scraps:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .jobOpenings, .createJobOpenings, .jobOpeningDetail, .scraps:
            let accessToken = Tokens.shared.accessToken.value
            let authorization = "Bearer \(accessToken)"
            return ["Authorization": authorization]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

let jobOpeningInfoProvider = MoyaProvider<JobOpeningInfoTarget>(session: Session(interceptor: AuthInterceptor.shared))
