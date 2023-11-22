//
//  CareerType.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/19/23.
//

import Foundation

enum CareerType: String {
    case IRRELEVANT
    case MORE_THAN_10YEARS
    case LESS_THAN_10YEARS
    case LESS_THAN_6YEARS
    case LESS_THAN_3YEARS
    case LESS_THAN_1YEARS
    case NEWCOMER
    
    var string: String {
        switch self {
        case .IRRELEVANT:
            return "경력무관"
        case .MORE_THAN_10YEARS:
            return "10년 이상"
        case .LESS_THAN_10YEARS:
            return "10년 미만"
        case .LESS_THAN_6YEARS:
            return "6년 미만"
        case .LESS_THAN_3YEARS:
            return "3년 미만"
        case .LESS_THAN_1YEARS:
            return "1년 미만"
        case .NEWCOMER:
            return "신입"
        }
    }
}
