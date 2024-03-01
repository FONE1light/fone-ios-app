//
//  JobOpeningSortOptions.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/25/23.
//

import UIKit
import PanModal

enum JobOpeningSortOptions: CaseIterable, Options {
    /// 최신순
    case recent
    /// 조회순
    case view
    /// 마감임박순
    case deadline
    
    var title: String? {
        switch self {
        case .recent: "최신순"
        case .view: "조회순"
        case .deadline: "마감임박순"
        }
    }
    
    var serverParameter: String? {
        switch self {
        case .recent: "createdAt,DESC"
        case .view: "viewCount,DESC"
        case .deadline: "deadline,ASC"
        }
    }
    
    static func getType(title: String?) -> JobOpeningSortOptions? {
        JobOpeningSortOptions.allCases.filter { $0.title == title }.first
    }
}
