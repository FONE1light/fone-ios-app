//
//  UIApplication+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/12/23.
//

import UIKit

extension UIApplication {
    static func getKeyWindow() -> UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
    }
}
