//
//  UIApplication+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/12/23.
//

import UIKit

extension UIApplication {
    /// deprecated 되지 않은 값 이용해 keyWindow 추출
    static var keyWindow: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
    }
}
