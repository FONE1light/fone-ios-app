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
//    case jobOpenings(type: Job, sort: String, page: Int)
    case jobOpenings(jobOpeningFilterRequest: JobOpeningFilterRequest)
    case createJobOpenings(jobOpeningRequest: JobOpeningRequest)
    case jobOpeningDetail(jobOpeningId: Int, type: Job)
    case scraps
    case scrapJobOpening(jobOpeningId: Int)
    case myRegistrations
    case deleteJobOpening(jobOpeningId: Int)
    case getRegions
    case getDistricts(region: String)
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
        case .myRegistrations:
            return "/api/v1/job-openings/my-registrations"
        case .deleteJobOpening(let jobOpeningId):
            return "/api/v1/job-openings/\(jobOpeningId)"
        case .getRegions:
            return "/api/v1/job-openings/locations/regions"
        case .getDistricts(let region):
            return "/api/v1/job-openings/locations/districts/\(region)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .jobOpenings, .jobOpeningDetail, .scraps, .myRegistrations, .getRegions, .getDistricts:
            return .get
        case .createJobOpenings, .scrapJobOpening:
            return .post
        case .deleteJobOpening:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .jobOpenings(let jobOpeningFilterRequest):
            // GET이라 requestJSONEncodable 사용 불가(body에 넣지 않기 위해)
            return .requestParameters(parameters: [
                "type": jobOpeningFilterRequest.type,
                "sort": jobOpeningFilterRequest.sort,
                "page": jobOpeningFilterRequest.page,
                "size": jobOpeningFilterRequest.size,
                "ageMax": jobOpeningFilterRequest.ageMax ?? 200,
                "ageMin": jobOpeningFilterRequest.ageMin ?? 0,
                "categories": jobOpeningFilterRequest.stringCategories ?? "",
                "genders": jobOpeningFilterRequest.stringGenders ?? "",
            ], encoding: URLEncoding.default)
        case .createJobOpenings(let jobOpeningRequest):
            return .requestJSONEncodable(jobOpeningRequest)
        case .jobOpeningDetail(_, let type):
            return .requestParameters(parameters: ["type": type.name], encoding: URLEncoding.default)
        case .scraps, .myRegistrations, .getRegions:
            return .requestPlain
        case .scrapJobOpening(let jobOpeningId), .deleteJobOpening(let jobOpeningId): // 없어도 에러 발생하지 않으나 스웨거 정의대로 넣어서 보냄
            return .requestParameters(parameters: [
                "jobOpeningId": jobOpeningId
            ], encoding: URLEncoding.default)
        case .getDistricts(let region):
            return .requestParameters(parameters: ["region": region], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let accessToken = Tokens.shared.accessToken.value
        let authorization = "Bearer \(accessToken)"
        return ["Authorization": authorization]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension JobOpeningInfoTarget {
    private var pageSize: Int {
        10
    }
}

let jobOpeningInfoProvider = MoyaProvider<JobOpeningInfoTarget>(session: Session(interceptor: AuthInterceptor.shared))
