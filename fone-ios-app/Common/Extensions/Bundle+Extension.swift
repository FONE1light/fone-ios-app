//
//  Bundle+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 3/23/24.
//

import Foundation

extension Bundle {
    /// CFBundleShortVersionString
    class var appVersion: String{
        if let value = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return value
        }
        return ""
    }
    
    /// CFBundleVersion
    class var appBuild: String{
        if let value = Bundle.main.infoDictionary?["CFBundleVersion"] as? String{
            return value
        }
        return ""
    }

    /// CFBundleIdentifier
    class var bundleIdentifier: String{
        if let value = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            return value
        }
        return ""
    }
}
