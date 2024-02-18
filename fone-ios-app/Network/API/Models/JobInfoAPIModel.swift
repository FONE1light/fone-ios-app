//
//  JobInfoAPIModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/18/23.
//

import Foundation

// MARK: - JobOpeningData
struct JobOpeningData: Codable {
    let jobOpening: JobOpeningContent?
}

// MARK: - JobOpeningsData
struct JobOpeningsData: Codable {
    let jobOpenings: JobOpeningsContent?
}

// FIXME: 안 쓰는 것 삭제
// MARK: - JobOpenings
struct JobOpeningsContent: Codable {
    let content: [JobOpeningContent]?
    let empty, first, last: Bool?
    let number, numberOfElements: Int?
    let pageable: Pageable?
    let size: Int?
    let sort: Sort?
    let totalElements, totalPages: Int?
}

struct ScrapJobOpeningResponseResult: Codable {
    let result: String?
}

