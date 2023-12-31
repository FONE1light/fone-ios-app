//
//  GenderType.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/19/23.
//

import UIKit

enum GenderType: Selection, CaseIterable {
    case IRRELEVANT
    case MAN
    case WOMAN
    
    var name: String {
        switch self {
        case .IRRELEVANT:
            "성별무관"
        case .MAN:
            "남자"
        case .WOMAN:
            "여자"
        }
    }
    
    var serverName: String {
        switch self {
        case .IRRELEVANT:
            "IRRELEVANT"
        case .MAN:
            "MAN"
        case .WOMAN:
            "WOMAN"
        }
    }
    
    var tagTextColor: UIColor? {
        UIColor.violet_6D5999
    }
    
    var tagBackgroundColor : UIColor? {
        UIColor.gray_EEEFEF
    }
    
    var tagCornerRadius: CGFloat? {
        return 11
    }
    
    static func getType(serverName: String?) -> GenderType? {
        return GenderType.allCases.filter { $0.serverName == serverName }.first
    }
}
