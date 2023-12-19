//
//  APIConfig.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/17.
//

import Foundation


// TODO: 서버 구조 확인, 필요 없으면 삭제
enum APIConfig {
    case DEV // 개발 서버
    case STAGING // 테스트 서버
    case PRODUCT // 운영 서버
}

extension APIConfig {
    var baseURL: String {
        switch self {
        case .DEV: return "http://3.37.114.103"
        case .STAGING, .PRODUCT: return "http://3.39.0.194"
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
    
    // FIXME: 테스트용이므로 실제 사용 시 재설정. 구조 변경도 고려
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
