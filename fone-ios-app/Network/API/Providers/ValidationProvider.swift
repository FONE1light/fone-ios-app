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
    case validateTitle(recruitBasicInfo: RecruitBasicInfo)
    case validateRole(recruitConditionInfo: RecruitConditionInfo)
    case validateProject(recruitWorkInfo: RecruitWorkInfo)
    case validateProjectDetails(recruitWorkConditionInfo: RecruitWorkConditionInfo)
    case validateSummary(recruitDetailInfo: RecruitDetailInfo)
    case validateManager(recruitContactInfo: RecruitContactInfo)
}

extension ValidationTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        switch self {
        case .validateContactLink: return "/api/v1/job-openings/validate/contact"
        case .validateTitle: return "/api/v1/job-openings/validate/title"
        case .validateRole: return "/api/v1/job-openings/validate/role"
        case .validateProject: return "/api/v1/job-openings/validate/project"
        case .validateProjectDetails: return "/api/v1/job-openings/validate/project-details"
        case .validateSummary: return "/api/v1/job-openings/validate/summary"
        case .validateManager: return "/api/v1/job-openings/validate/manager"
        
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .validateContactLink(recruitContactLinkInfo: let recruitContactLinkInfo):
            return .requestJSONEncodable(recruitContactLinkInfo)
        case .validateTitle(recruitBasicInfo: let recruitBasicInfo):
            return .requestJSONEncodable(recruitBasicInfo)
        case .validateRole(recruitConditionInfo: let recruitConditionInfo):
            return .requestJSONEncodable(recruitConditionInfo)
        case .validateProject(recruitWorkInfo: let recruitWorkInfo):
            return .requestJSONEncodable(recruitWorkInfo)
        case .validateProjectDetails(recruitWorkConditionInfo: let recruitWorkConditionInfo):
            return .requestJSONEncodable(recruitWorkConditionInfo)
        case .validateSummary(recruitDetailInfo: let recruitDetailInfo):
            return .requestJSONEncodable(recruitDetailInfo)
        case .validateManager(recruitContactInfo: let recruitContactInfo):
            return .requestJSONEncodable(recruitContactInfo)
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
