//
//  GenderType.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/19/23.
//

import Foundation

enum GenderType: String, CaseIterable {
    case IRRELEVANT
    case MAN
    case WOMAN
    
    var string: String {
        switch self {
        case .IRRELEVANT:
            "성별무관"
        case .MAN:
            "남자"
        case .WOMAN:
            "여자"
        }
    }
    
    static func getType(rawValue: String?) -> GenderType? {
        GenderType.allCases.filter { $0.rawValue == rawValue }.first
    }
}
