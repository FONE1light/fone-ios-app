//
//  Job.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/14.
//

import Foundation

protocol Selection {
    var name: String { get }
}

enum Job: Selection, CaseIterable {
    case actor
    case staff
    case normal
    case hunter
    
    var name: String {
        switch self {
        case .actor: return "ACTOR"
        case .staff: return "STAFF"
        case .normal: return "NORMAL"
        case .hunter: return "HUNTER"
        }
    }
    
    var serverName: String {
        return self.name
    }
}
