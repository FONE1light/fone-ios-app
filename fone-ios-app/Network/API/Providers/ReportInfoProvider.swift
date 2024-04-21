//
//  ReportInfoProvider.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 4/13/24.
//

import Foundation
import Moya

enum ReportInfoTarget {
    case reports(reportInfo: ReportInfo)
}

extension ReportInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        return "/api/v1/reports"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .reports(let reportInfo):
            return .requestJSONEncodable(reportInfo)
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

let reportInfoProvider = MoyaProvider<ReportInfoTarget>(session: Session(interceptor: AuthInterceptor.shared))
