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
    let jobOpening: JobOpeningModuleInfo
    let competition: CompetitionModuleInfo
    let profile: ProfileModuleInfo
}

// MARK: - JobOpeningModuleInfo
struct JobOpeningModuleInfo: Codable {
    let title, subTitle: String
    let data: JobOpeningModuleData
}


// MARK: - JobOpeningModuleData
struct JobOpeningModuleData: Codable {
    let content: [JobOpeningContent]
    let pageable: Pageable
    let totalPages, totalElements: Int
    let last: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let first, empty: Bool
}

// MARK: - JobOpeningContent
struct JobOpeningContent: Codable {
    let id: Int
    let title: String
    let categories: [String]
    let deadline: String
    let casting: String?
    let numberOfRecruits: Int
    let gender: String
    let ageMax, ageMin: Int
    let career, type: String
    let domains: [String]
    let viewCount, scrapCount: Int
    let work: [String: String?]
    let isScrap: Bool
    let nickname: String
    let profileURL: String
    let createdAt, userJob, dday: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, categories, deadline, casting, numberOfRecruits, gender, ageMax, ageMin, career, type, domains, viewCount, scrapCount, work, isScrap, nickname
        case profileURL = "profileUrl"
        case createdAt, userJob, dday
    }
}

// MARK: - CompetitionModuleInfo
struct CompetitionModuleInfo: Codable {
    let title, subTitle: String
    let data: CompetitionModuleData
}

// MARK: - CompetitionModuleData
struct CompetitionModuleData: Codable {
    let content: [CompetitionContent]
    let pageable: Pageable
    let totalPages, totalElements: Int
    let last: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let first, empty: Bool
}

// MARK: - CompetitionContent
struct CompetitionContent: Codable {
    let id: Int
    let title: String
    let imageURL: String
    let screeningStartDate, screeningEndDate, exhibitStartDate, exhibitEndDate: String
    let showStartDate, agency, details: String
    let viewCount, scrapCount: Int
    let isScrap: Bool
    let linkURL: String
    let screeningDDay, exhibitDDay: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case imageURL = "imageUrl"
        case screeningStartDate, screeningEndDate, exhibitStartDate, exhibitEndDate, showStartDate, agency, details, viewCount, scrapCount, isScrap
        case linkURL = "linkUrl"
        case screeningDDay, exhibitDDay
    }
}

// MARK: - ProfileModuleInfo
struct ProfileModuleInfo: Codable {
    let title, subTitle: String
    let data: ProfileModuleData
}

// MARK: - ProfileModuleData
struct ProfileModuleData: Codable {
    let content: [ProfileContent]
    let pageable: Pageable
    let totalPages, totalElements: Int
    let last: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let first, empty: Bool
}

// MARK: - ProfileContent
struct ProfileContent: Codable {
    let id: Int
    let name, hookingComment, birthday, gender: String
    let height, weight: Int
    let email, sns, specialty, details: String
    let type, career, careerDetail: String
    let categories: [String]
    let domains: [String]
    let profileUrls: [String]
    let viewCount: Int
    let profileURL: String
    let isWant: Bool
    let age: Int
    let createdAt, userNickname: String
    let userProfileURL: String
    let userJob: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, hookingComment, birthday, gender, height, weight, email, sns, specialty, details, type, career, careerDetail, categories, domains, profileUrls, viewCount
        case profileURL = "profileUrl"
        case isWant, age, createdAt, userNickname
        case userProfileURL = "userProfileUrl"
        case userJob
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
