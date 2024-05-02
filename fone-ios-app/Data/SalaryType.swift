//
//  SalaryType.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/19/23.
//

import Foundation

enum SalaryType: String {
    case ANNUAL
    case MONTHLY
    case DAILY
    case HOURLY
    case PER_SESSION
    case LATER_ON
    
    var string: String {
        switch self {
        case .ANNUAL:
            return "연봉"
        case .MONTHLY:
            return "월급"
        case .DAILY:
            return "일급"
        case .HOURLY:
            return "시급"
        case .PER_SESSION:
            return "회차"
        case .LATER_ON:
            return "추후협의"
        }
    }
}
