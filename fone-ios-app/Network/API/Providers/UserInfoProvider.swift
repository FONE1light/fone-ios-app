//
//  UserInfoProvider.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/17.
//

import Foundation
import Moya
import RxSwift

enum UserInfoTarget {
    case fetchMyPage
    case checkNicknameDuplication(nickname: String)
}

extension UserInfoTarget: TargetType {
    var baseURL: URL {
        "http://3.39.0.194".url!
    }
    
    var path: String {
        switch self {
        case .fetchMyPage:
            return "/api/v1/users"
        case .checkNicknameDuplication:
            return "/api/v1/users/check-nickname-duplication"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        switch self {
        case .checkNicknameDuplication(let nickname):
            let param = ["nickname": nickname]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
        
    }
    
    // FIXME: 로그인 혹은 회원가입 후 토큰 받으면 유효한 토큰 설정
    var headers: [String : String]? {
        var commonHeaders: [String: String] = [:]
//        commonHeaders["Content-Type"] = "application/json;charset=UTF-8"
        
        switch self {
        case .fetchMyPage:
            commonHeaders[Tokens.shared.accessToken.key] = Tokens.shared.accessToken.value // TODO: MOCK,
        default:
            break
        }
        return commonHeaders
    }
    
    
}

#if DEBUG
    let userInfoProvider = MoyaProvider<UserInfoTarget>(
//        requestClosure: TimeoutClosure,
//        plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter), logOptions: .verbose))]
    )
#else
    let userInfoProvider = MoyaProvider<UserInfoTarget>(
//        requestClosure: TimeoutClosure
    )
#endif
