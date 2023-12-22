//
//  Domain.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/1/23.
//

import UIKit

enum Domain: CaseIterable, Selection {
    case director
    case scenario
    case planning
    case filming
    case gaffer
    case record
    case painting
    case art
    case makeUp
    case edit
    case music
    case picture
    case etc
    
    var name: String {
        switch self {
        case .director: "기획/제작"
        case .scenario: "시나리오"
        case .planning: "연출"
        case .filming: "촬영"
        case .gaffer: "조명"
        case .record: "녹음"
        case .painting: "그림"
        case .art: "미술"
        case .makeUp: "분장"
        case .edit: "편집"
        case .music: "음악"
        case .picture: "사진"
        case .etc: "기타"
        }
    }
    
    
    var serverName: String {
        switch self {
        case .art: "ART"
        case .director: "DIRECTOR"
        case .edit: "EDIT"
        case .etc: "ETC"
        case .filming: "FILMING"
        case .gaffer: "GAFFER"
        case .makeUp: "MAKE_UP"
        case .music: "MUSIC"
        case .painting: "PAINTING"
        case .picture: "PICTURE"
        case .planning: "PLANNING"
        case .record: "RECORD"
        case .scenario: "SCENARIO"
        }
    }
    
    var tagTextColor: UIColor? { nil }
    
    var tagBackgroundColor: UIColor? { nil }
    
    var tagCornerRadius: CGFloat? { nil }
    
    static func getType(serverName: String) -> Domain? {
        return Domain.allCases.filter { $0.serverName == serverName }.first
    }
}
