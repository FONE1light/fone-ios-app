//
//  HomeInfoAPIModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/14.
//

// MARK: - HomeInfo
struct HomeInfo: Codable {
    let result: String
    let data: HomeInfoData
    let message: String
    let errorCode: String?
}

// MARK: - HomeInfoData
struct HomeInfoData: Codable {
    let order: [String]
    let jobOpening, competition, profile: ModuleInfo
}

// MARK: - ModuleInfo
struct ModuleInfo: Codable {
    let title, subTitle: String
    let data: ModuleData
}

// MARK: - ModuleData
struct ModuleData: Codable {
    let content: [Content]
    let pageable: Pageable
    let last: Bool
    let totalPages, totalElements, size, number: Int
    let sort: Sort
    let first: Bool
    let numberOfElements: Int
    let empty: Bool
}

// MARK: - Content
struct Content: Codable {
    let id: Int
    let title: String?
    let categories: [String]
    let deadline: String?
    let casting: String?
    let numberOfRecruits: Int?
    let gender: String
    let ageMax, ageMin: Int?
    let career, type: String
    let domains: [String]
    let viewCount: Int
    let scrapCount: Int?
    let work: [String: String?]?
    let isScrap: Bool?
    let nickname: String?
    let profileURL: String
    let createdAt: String
    let dday, name, hookingComment, birthday: String?
    let height, weight: Int?
    let email, sns, specialty, details: String?
    let careerDetail: String?
    let profileUrls: [String]?
    let isWant: Bool?
    let age: Int?
    let userNickname: String?

    enum CodingKeys: String, CodingKey {
        case id, title, categories, deadline, casting, numberOfRecruits, gender, ageMax, ageMin, career, type, domains, viewCount, scrapCount, work, isScrap, nickname
        case profileURL = "profileUrl"
        case createdAt, dday, name, hookingComment, birthday, height, weight, email, sns, specialty, details, careerDetail, profileUrls, isWant, age, userNickname
    }
}

// MARK: - Pageable
struct Pageable: Codable {
    let sort: Sort
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, unsorted, sorted: Bool
}
