//
//  WeekDay.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2/4/24.
//

import Foundation

enum WeekDay: String, CaseIterable {
    case MON
    case TUE
    case WED
    case THU
    case FRI
    case SAT
    case SUN
    case LATER_ON
    
    var string: String {
        switch self {
        case .MON:
            return "월"
        case .TUE:
            return "화"
        case .WED:
            return "수"
        case .THU:
            return "목"
        case .FRI:
            return "금"
        case .SAT:
            return "토"
        case .SUN:
            return "일"
        default:
            return "추후협의"
        }
    }
    
    static func getWeekDayType(from string: String?) -> WeekDay? {
        return WeekDay.allCases.filter { $0.string == string }.first
    }
}
