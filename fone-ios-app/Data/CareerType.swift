//
//  CareerType.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/19/23.
//

import UIKit

enum CareerType: String, Selection, CaseIterable {
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
    
    /// 프로필 등록하기 화면에서 사용되는 문자열(배우 등록하기, 스태프 등록하기)
    var name: String {
        switch self {
        case .NEWCOMER: "신입"
        case .LESS_THAN_1YEARS: "1년 미만"
        case .LESS_THAN_3YEARS: "1~3년"
        case .LESS_THAN_6YEARS: "4~6년"
        case .LESS_THAN_10YEARS: "7~10년"
        case .MORE_THAN_10YEARS: "10년~"
        default: ""
        }
    }
    
    // TODO: 서버 연결 시 완성
    var serverName: String {
        switch self {
        default: "<서버enum>"
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
    
    static func getType(serverName: String) -> CareerType? {
        return CareerType.allCases.filter { $0.serverName == serverName }.first
    }
}
