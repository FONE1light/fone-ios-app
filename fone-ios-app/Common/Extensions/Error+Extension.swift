//
//  Error+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 1/30/24.
//

import Foundation
import Moya

extension Error {
    /// 서버의 `message`를 토스트로 보여주거나 `localizedDescription`를 토스트로 보여줌
    func showToast<T: Codable>(modelType: T.Type, positionType: ToastPositionType = .withNothing, isKeyboardShowing: Bool = false) {
        guard let response = (self as? MoyaError)?.response,
              let errorData = try? response.mapObject(Result<T>.self),
              let message = errorData.message,
              !message.isEmpty else {
            return localizedDescription.toast(positionType: positionType, isKeyboardShowing: isKeyboardShowing)
        }
        print(errorData)
        message.toast(positionType: positionType, isKeyboardShowing: isKeyboardShowing)
    }
}
