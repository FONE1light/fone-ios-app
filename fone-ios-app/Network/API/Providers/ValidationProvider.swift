//
//  ValidationProvider.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 1/28/24.
//

import Foundation
import Moya

enum ValidationTarget {
    case validateContactLink(recruitContactLinkInfo: RecruitContactLinkInfo)
    case validateSummary(recruitDetailInfo: RecruitDetailInfo)
}

extension ValidationTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        switch self {
        case .validateContactLink: return "/api/v1/job-openings/validate/contact"
        case .validateSummary: return "/api/v1/job-openings/validate/summary"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .validateContactLink(recruitContactLinkInfo: let recruitContactLinkInfo):
            return .requestJSONEncodable(recruitContactLinkInfo)
        case .validateSummary(recruitDetailInfo: let recruitDetailInfo):
            return .requestJSONEncodable(recruitDetailInfo)
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

let validationProvider = MoyaProvider<ValidationTarget>(session: Session(interceptor: AuthInterceptor.shared))
