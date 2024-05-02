//
//  ReportInfoAPIModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 4/13/24.
//

import Foundation

// MARK: - ReportInfo
struct ReportInfo: Codable {
    let details: String?
    let inconveniences: [String]?
    let type: String?
    let typeId: Int?
}
