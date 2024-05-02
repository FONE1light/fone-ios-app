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
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
    }
    
    static var tabBar: UITabBar? {
        UIApplication.keyWindow?
            .rootViewController?.view.subviews
            .filter { $0 is UITabBar }
            .first as? UITabBar
    }
    
    
    static var viewOfKeyWindow: UIView? {
        UIApplication.keyWindow?.rootViewController?.view
    }
}
