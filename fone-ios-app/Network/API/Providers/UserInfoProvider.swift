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
    case sendSMS(phoneNumber: String)
    case emailSignUp(EmailSignUpInfo)
    case socialSignUp(SocialSignUpInfo)
    case findID(code: String, phoneNumber: String)
    case findPassword(code: String, phoneNumber: String)
    case resetPassword(password: String, phoneNumber: String, token: String)
    case socialSignIn(accessToken: String, loginType: String)
    case modifyUserInfo(userInfo: UserInfo)
    case logout
    case signout
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
        case .emailSignIn:
            return "/api/v1/users/email/sign-in"
        case .reissueToken:
            return "/api/v1/users/reissue"
        case .sendSMS:
            return "/api/v1/users/sms/send"
        case .emailSignUp:
            return "/api/v1/users/email/sign-up"
        case .socialSignUp:
            return "/api/v1/users/social/sign-up"
        case .findID:
            return "/api/v1/users/sms/find-id"
        case .findPassword:
            return "/api/v1/users/sms/find-password"
        case .resetPassword:
            return "/api/v1/users/password"
        case .socialSignIn:
            return "/api/v1/users/social/sign-in"
        case .modifyUserInfo:
            return "/api/v1/users"
        case .logout:
            return "/api/v1/users/log-out"
        case .signout:
            return "/api/v1/users/sign-out"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMyPage, .checkNicknameDuplication:
            return .get
        case .emailSignIn, .reissueToken, .sendSMS, .emailSignUp, .findID, .findPassword, .socialSignIn, .socialSignUp, .logout:
            return .post
        case .resetPassword, .modifyUserInfo, .signout:
            return .patch
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
        case .sendSMS(let phoneNumber):
            return .requestParameters(parameters: ["phoneNumber": phoneNumber], encoding: JSONEncoding.default)
        case .emailSignUp(let emailSignUpInfo): // TODO: 확인 후 통일
            return .requestJSONEncodable(emailSignUpInfo)
        case .socialSignUp(let socialSignUpInfo):
            return .requestJSONEncodable(socialSignUpInfo)
        case .findID(let code, let phoneNumber):
            return .requestParameters(parameters: ["code": code, "phoneNumber": phoneNumber], encoding: JSONEncoding.default)
        case .findPassword(let code, let phoneNumber):
            return .requestParameters(parameters: ["code": code, "phoneNumber": phoneNumber], encoding: JSONEncoding.default)
        case .resetPassword(let password, let phoneNumber, let token):
            return .requestParameters(parameters: ["password": password, "phoneNumber": phoneNumber, "token": token], encoding: JSONEncoding.default)
        case .socialSignIn(let accessToken, let loginType):
            return .requestParameters(parameters: ["accessToken": accessToken, "loginType": loginType], encoding: JSONEncoding.default)
        case .modifyUserInfo(let userInfo):
            return .requestJSONEncodable(userInfo)
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
        case .emailSignIn, .reissueToken, .sendSMS, .emailSignUp, .findID, .findPassword, .resetPassword, .socialSignIn, .socialSignUp:
            commonHeaders["Content-Type"] = "application/json;charset=UTF-8"
        case .modifyUserInfo, .logout, .signout:
            let accessToken = Tokens.shared.accessToken.value
            let authorization = "Bearer \(accessToken)"
            commonHeaders["Authorization"] = authorization
            commonHeaders["Content-Type"] = "application/json;charset=UTF-8"
        default:
            break
        }
        return commonHeaders
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

#if DEBUG
    let userInfoProvider = MoyaProvider<UserInfoTarget>(session: Session(interceptor: AuthInterceptor.shared)
//        requestClosure: TimeoutClosure,
//        plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter), logOptions: .verbose))]
    )
#else
    let userInfoProvider = MoyaProvider<UserInfoTarget>(
//        requestClosure: TimeoutClosure
    )
#endif
let tokenProvider = MoyaProvider<UserInfoTarget>()
