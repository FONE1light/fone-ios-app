//
//  Job.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/14.
//

import UIKit

protocol Selection {
    var name: String { get }
    
    var tagTextColor: UIColor? { get }
    var tagBackgroundColor: UIColor? { get }
    var tagCornerRadius: CGFloat? { get }
}

enum Job: Selection, CaseIterable {
    case actor
    case staff
    case normal
    case hunter
    
    static func getType(name: String?) -> Job? {
        Job.allCases.filter { $0.name == name }.first
    }
    
    var name: String {
        switch self {
        case .actor: return "ACTOR"
        case .staff: return "STAFF"
        case .normal: return "NORMAL"
        case .hunter: return "HUNTER"
        }
    }
    
    // 프로필 등록하기 화면의 navigationBar에 사용
    var koreanName: String {
        switch self {
        case .actor: return "배우"
        case .staff: return "스태프"
        default: return ""
        }
    }
    var serverName: String {
        return self.name
    }
    
    var tagTextColor: UIColor? {
        switch self {
        case .actor, .staff: return UIColor.white_FFFFFF
        default: return nil
        }
    }
    
    var tagBackgroundColor : UIColor? {
        switch self {
        case .actor: return UIColor.red_FAAABD
        case .staff: return UIColor.violet_AFA3CA
        default: return nil
        }
    }
    
    var tagCornerRadius: CGFloat? {
        switch self {
        case .actor, .staff: return 5
        default: return nil
        }
    }
}
