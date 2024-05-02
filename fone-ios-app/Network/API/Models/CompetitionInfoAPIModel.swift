//
//  CompetitionInfoAPIModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 1/30/24.
//

import Foundation

struct CompetitionsData: Codable {
    let competitions: CompetitionModuleData?
    let totalCount: Int?
}
