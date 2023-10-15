//
//  UserInfoProvider.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/17.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum UserInfoTarget {
    case fetchMyPage
    case checkNicknameDuplication(nickname: String)
    case emailSignIn(emailSignInInfo: EmailSignInInfo)
    case reissueToken(tokenInfo: TokenInfo)
}

extension UserInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        switch self {
        case .fetchMyPage:
            return "/api/v1/users"
        case .checkNicknameDuplication:
            return "/api/v1/users/check-nickname-duplication"
        case .emailSignIn(_):
            return "/api/v1/users/email/sign-in"
        case .reissueToken(_):
            return "/api/v1/users/reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMyPage, .checkNicknameDuplication(_):
            return .get
        case .emailSignIn(_), .reissueToken(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .checkNicknameDuplication(let nickname):
            let param = ["nickname": nickname]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case .emailSignIn(let emailSignInInfo):
            return .requestJSONEncodable(emailSignInInfo)
        case .reissueToken(let tokenInfo):
            return .requestJSONEncodable(tokenInfo)
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
        case .emailSignIn(_), .reissueToken(_):
            commonHeaders["Content-Type"] = "application/json"
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
