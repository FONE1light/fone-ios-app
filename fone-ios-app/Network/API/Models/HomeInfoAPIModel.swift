//
//  HomeInfoAPIModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/14.
//

// MARK: - HomeInfo
struct HomeInfo: Codable {
    let result: String?
    let data: HomeInfoData?
    let message: String?
    let errorCode: String?
}

// MARK: - HomeInfoData
struct HomeInfoData: Codable {
    let order: [String]?
    let jobOpening: JobOpeningModuleInfo?
    let competition: CompetitionModuleInfo?
    let profile: ProfileModuleInfo?
}

// MARK: - JobOpeningModuleInfo
struct JobOpeningModuleInfo: Codable {
    let title, subTitle: String?
    let data: JobOpeningModuleData?
}

// MARK: - JobOpeningModuleData
struct JobOpeningModuleData: Codable {
    let content: [JobOpeningContent]?
    let pageable: Pageable?
    let totalPages, totalElements: Int?
    let last: Bool?
    let size, number: Int?
    let sort: Sort?
    let numberOfElements: Int?
    let first, empty: Bool?
}

// MARK: - JobOpeningContent
struct JobOpeningContent: Codable {
    let ageMax, ageMin: Int?
    let career, casting: String?
    let categories: [String]?
    let createdAt, dday: String?
    let domains: [String]?
    let gender: String?
    let id: Int?
    let imageUrls: [String]?
    let isScrap, isVerified: Bool?
    let nickname: String?
    let numberOfRecruits: Int?
    let profileURL: String?
    let recruitmentEndDate, recruitmentStartDate: String?
    let representativeImageURL: String?
    let scrapCount: Int?
    let title, type, userJob: String?
    let viewCount: Int?
    let work: Work?

    enum CodingKeys: String, CodingKey {
        case ageMax, ageMin, career, casting, categories, createdAt, dday, domains, gender, id, imageUrls, isScrap, isVerified, nickname, numberOfRecruits
        case profileURL = "profileUrl"
        case recruitmentEndDate, recruitmentStartDate
        case representativeImageURL = "representativeImageUrl"
        case scrapCount, title, type, userJob, viewCount, work
    }
}

// MARK: - CompetitionModuleInfo
struct CompetitionModuleInfo: Codable {
    let title, subTitle: String?
    let data: CompetitionModuleData?
}

// MARK: - CompetitionModuleData
struct CompetitionModuleData: Codable {
    let content: [CompetitionContent]?
    let pageable: Pageable?
    let totalPages, totalElements: Int?
    let last: Bool?
    let size, number: Int?
    let sort: Sort?
    let numberOfElements: Int?
    let first, empty: Bool?
}

// MARK: - CompetitionContent
struct CompetitionContent: Codable {
    let id: Int?
    let title: String?
    let imageURL: String?
    let screeningStartDate, screeningEndDate, exhibitStartDate, exhibitEndDate: String?
    let showStartDate, agency, details: String?
    let viewCount, scrapCount: Int?
    let isScrap: Bool?
    let linkURL: String?
    let screeningDDay, screeningDate, exhibitDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case imageURL = "imageUrl"
        case screeningStartDate, screeningEndDate, exhibitStartDate, exhibitEndDate, showStartDate, agency, details, viewCount, scrapCount, isScrap
        case linkURL = "linkUrl"
        case screeningDDay, screeningDate, exhibitDate
    }
}

// MARK: - ProfileModuleInfo
struct ProfileModuleInfo: Codable {
    let title, subTitle: String?
    let data: ProfileModuleData?
}

// MARK: - ProfileModuleData
struct ProfileModuleData: Codable {
    let content: [ProfileContent]?
    let pageable: Pageable?
    let totalPages, totalElements: Int?
    let last: Bool?
    let size, number: Int?
    let sort: Sort?
    let numberOfElements: Int?
    let first, empty: Bool?
}

// MARK: - ProfileContent
struct ProfileContent: Codable {
    let id: Int?
    let name, hookingComment, birthday, gender: String?
    let height, weight: Int?
    let email, sns: String?
    let snsUrls: [String]?
    let specialty, details, type, career: String?
    let careerDetail: String?
    let categories: [String]?
    let domains, profileUrls, profileImages: [String]?
    let viewCount: Int?
    let profileURL, representativeImageURL: String?
    let isWant: Bool?
    let age: Int?
    let createdAt, userNickname, userProfileURL, userJob: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, hookingComment, birthday, gender, height, weight, email, sns, snsUrls, specialty, details, type, career, careerDetail, categories, domains, profileUrls, profileImages, viewCount
        case profileURL = "profileUrl"
        case representativeImageURL = "representativeImageUrl"
        case isWant, age, createdAt, userNickname
        case userProfileURL = "userProfileUrl"
        case userJob
    }
}

// MARK: - Pageable
struct Pageable: Codable {
    let sort: Sort?
    let offset, pageNumber, pageSize: Int?
    let paged, unpaged: Bool?
}

// MARK: - Sort
struct Sort: Codable {
    let empty, unsorted, sorted: Bool?
}

// MARK: - Work
struct Work: Codable {
    let details, director, email: String?
    let genres: [String]?
    let logline, manager, produce: String?
    let salary: Int?
    let salaryType: String?
    let selectedDays: [String]?
    let workTitle, workingCity, workingDate, workingDistrict: String?
    let workingEndDate: String?
//    let workingEndTime: WorkingTime?
    let workingLocation, workingStartDate: String?
//    let workingStartTime: WorkingTime?
    let workingTime: String?
}
