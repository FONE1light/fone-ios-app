//
//  JobInfoAPIModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/18/23.
//

import Foundation

// MARK: - JobOpeningInfo
struct JobOpeningInfo: Codable {
    let result: String
    let data: JobOpeningData?
    let message: String
    let errorCode: String?
}

// MARK: - JobOpeningData
struct JobOpeningData: Codable {
    let jobOpening: JobOpeningContent?
}
