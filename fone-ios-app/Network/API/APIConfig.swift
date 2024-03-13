//
//  APIConfig.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/17.
//

import Foundation

enum APIConfig {
    case DEV // 개발 서버
    case STAGING // 테스트 서버
    case PRODUCT // 운영 서버
}

extension APIConfig {
    var baseURL: String {
        switch self {
        case .DEV: return "https://dev-api.f-one.app"
        case .STAGING, .PRODUCT: return "https://api.f-one.app"
        }
        
    }
    var imageUploadBaseURL: String {
        "https://du646e9qh1.execute-api.ap-northeast-2.amazonaws.com"
    }
}

class Tokens {
    static let shared = Tokens()
    
    var accessToken: Token = .accessToken
    var refreshToken: Token = .refreshToken
}

enum Token {
    case accessToken
    case refreshToken
}

extension Token {
    var key: String {
        switch self {
        case .accessToken:
            return "accessToken"
        case .refreshToken:
            return "refreshToken"
        }
    }
    
    var value: String {
        get {
            return UserDefaults.standard.string(forKey: self.key) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }
}

class APISetting {
    static let shared = APISetting()
#if DEBUG
    var config: APIConfig = .DEV
#else
    var config: APIConfig = .PRODUCT
#endif
    var defaultTimeout: TimeInterval = 10
}
