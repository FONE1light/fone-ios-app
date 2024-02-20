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
    let createdAt, dday: String?
    let recruitContactLinkInfo: RecruitContactLinkInfo?
    let recruitBasicInfo: RecruitBasicInfo?
    let recruitConditionInfo: RecruitConditionInfo?
    let recruitWorkInfo: RecruitWorkInfo?
    let recruitWorkConditionInfo: RecruitWorkConditionInfo?
    let recruitDetailInfo: RecruitDetailInfo?
    let recruitContactInfo: RecruitContactInfo?
    let id: Int?
    let isScrap, isVerified, contactable: Bool?
    let scrapCount: Int?
    let type, userJob, userNickname: String?
    let userProfileURL: String?
    let viewCount: Int?
    let workingDate: String?
    
    enum CodingKeys: String, CodingKey {
        case contactable, createdAt, dday, id, isScrap, isVerified, scrapCount, type, userJob, userNickname, viewCount, workingDate
        case recruitContactLinkInfo = "firstPage"
        case recruitBasicInfo = "secondPage"
        case recruitConditionInfo = "thirdPage"
        case recruitWorkInfo = "fourthPage"
        case recruitWorkConditionInfo = "fifthPage"
        case recruitDetailInfo = "sixthPage"
        case recruitContactInfo = "seventhPage"
        case userProfileURL = "userProfileUrl"
    }
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

// MARK: - Content
struct ProfileContent: Codable {
    let id: Int?
    let registerContactLinkInfo: RegisterContactLinkInfo?
    let registerBasicInfo: RegisterBasicInfo?
    let registerDetailInfo: RegisterDetailInfo?
    let registerDetailContent: RegisterDetailContent?
    let registerCareer: RegisterCareer?
    let registerInterest: RegisterInterest?
    let type: String?
    let viewCount: Int?
    let isWant: Bool?
    let createdAt, userNickname, userProfileURL, userJob: String?
    let age: Int?

    enum CodingKeys: String, CodingKey {
        case id, type, viewCount, isWant, createdAt, userNickname
        case userProfileURL = "userProfileUrl"
        case userJob, age
        case registerContactLinkInfo = "firstPage"
        case registerBasicInfo = "secondPage"
        case registerDetailInfo = "thirdPage"
        case registerDetailContent = "fourthPage"
        case registerCareer = "fifthPage"
        case registerInterest = "sixthPage"
    }
}

// MARK: - FirstPage
struct RegisterContactLinkInfo: Codable {
    let contactMethod: String?
    let contact: String?
}

// MARK: - SecondPage
struct RegisterBasicInfo: Codable {
    let name, hookingComment: String?
    let profileImages: [String]?
    let representativeImageURL: String?

    enum CodingKeys: String, CodingKey {
        case name, hookingComment, profileImages
        case representativeImageURL = "representativeImageUrl"
    }
}

// MARK: - ThirdPage
struct RegisterDetailInfo: Codable {
    let birthday, gender: String?
    let height, weight: Int?
    let email: String?
    let domains: [String]?
    let specialty: String?
    let snsUrls: [SnsURL]?
}

// MARK: - FourthPage
struct RegisterDetailContent: Codable {
    let details: String?
}

// MARK: - FifthPage
struct RegisterCareer: Codable {
    let career, careerDetail: String?
}

// MARK: - SixthPage
struct RegisterInterest: Codable {
    let categories: [String]?
}

// MARK: - SnsURL
struct SnsURL: Codable {
    let url: String?
    // e.g. "YOUTUBE"
    let sns: String?
}

// MARK: - 공통 사용
struct Pageable: Codable {
    let sort: Sort?
    let offset, pageNumber, pageSize: Int?
    let paged, unpaged: Bool?
}

struct Sort: Codable {
    let empty, unsorted, sorted: Bool?
}
