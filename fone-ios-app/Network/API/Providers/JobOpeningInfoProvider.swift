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
    case scrapJobOpening(jobOpeningId: Int)
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
        case .scrapJobOpening(let jobOpeningId):
            return "/api/v1/job-openings/\(jobOpeningId)/scrap"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .jobOpenings, .jobOpeningDetail, .scraps:
            return .get
        case .createJobOpenings, .scrapJobOpening:
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
        case .scrapJobOpening(let jobOpeningId): // 없어도 에러 발생하지 않으나 스웨거 정의대로 넣어서 보냄
            return .requestParameters(parameters: [
                "jobOpeningId": jobOpeningId
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .jobOpenings, .createJobOpenings, .jobOpeningDetail, .scraps, .scrapJobOpening:
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
