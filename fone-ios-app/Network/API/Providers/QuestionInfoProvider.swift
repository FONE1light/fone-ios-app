//
//  QuestionInfoProvider.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/30.
//

import Foundation
import Moya

enum QuestionInfoTarget {
    case questions(questionInfo: QuestionInfo)
}

extension QuestionInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        return "/api/v1/questions"
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        switch self {
        case .questions(let questionInfo):
            return .requestJSONEncodable(questionInfo)
        }
    }
    
    var headers: [String: String]? {
        let accessToken = Tokens.shared.accessToken.value
        let authorization = "Bearer \(accessToken)"
        return ["Authorization": authorization]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

let questionInfoProvider = MoyaProvider<QuestionInfoTarget>(session: Session(interceptor: AuthInterceptor.shared))
