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
        "http://3.39.0.194"
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
            return "access_token"
        case .refreshToken:
            return "refresh_token"
        }
    }
    
    // FIXME: 테스트용이므로 실제 사용 시 재설정. 구조 변경도 고려
    var value: String {
        switch self {
        case .accessToken:
            return "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJwcmltZWFkbWluIiwic2NvcGUiOlsicmVhZCIsIndyaXRlIl0sImV4cCI6MTY0NTUzNzA4NSwiaXNzdWVkX2F0IjoxNjQ1NTMzNDg1ODg5LCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIl0sImp0aSI6ImI5ZmFkNzY5LWYwNjYtNGU2MC1iZWYyLTllMDE0NzVjNzAyYyIsImNsaWVudF9pZCI6ImN1cmwifQ.Ls_quM54efPKXNwQygfTQdQuPxGbdJlqicdTS5dt5JBVTx1Bs46N3d-ftGTVd9RfnM7GsGCLwR-eqIkRKMrNpxG4TBdyImpmF_Fig50R6SdU8EXOtqTZVOUx5YCvy21Vm6LI1xyTOme_FcJBFrd3DzTHMepDhzFgusWJE4B6jE_IhTj19h1l194urq2_HyqmZctnlvuH5XxcG_JQelgPy4xyHyHaH3v1kdplRvwiiYYVvRZkYDmieqcpnfj7G6rIOHKgf62hGzxaohuoRGjp1J72ktp-Nwe9NDRfsTz9raSRVKgNYs186D4e_LCoe9d2f1_jMgyE_PzhJvGXHq-tPw"
        case .refreshToken:
            return ""
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
