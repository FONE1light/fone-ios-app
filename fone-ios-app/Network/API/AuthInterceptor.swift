//
//  AuthInterceptor.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/22/23.
//

import Foundation
import Moya
import Alamofire

final class AuthInterceptor: RequestInterceptor {

    static let shared = AuthInterceptor()

    private init() {}

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        // 토큰 갱신 API 호출
        UserManager.shared.reissueToken { success in
            if success {
                print("Retry-토큰 재발급 성공")
                completion(.retry)
            } else {
                // 갱신 실패 -> 로그인 화면으로 전환
                completion(.doNotRetry)
                Tokens.shared.accessToken.value = ""
                Tokens.shared.refreshToken.value = ""
                "다시 로그인 해주세요.".toast()
                UserManager.shared.moveToLogin()
            }
        }
    }
}
