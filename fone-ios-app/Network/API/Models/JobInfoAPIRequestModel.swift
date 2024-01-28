//
//  JobInfoAPIRequestModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 1/27/24.
//

import Foundation

// MARK: - JobOpeningRequest
struct JobOpeningRequest: Codable {
    let ageMax, ageMin: Int?
    let career, casting: String?
    let categories: [String]?
    let domains: [String]?
    let gender: String?
    let imageUrls: [String]?
    let numberOfRecruits: Int?
    let recruitmentEndDate, recruitmentStartDate: String?
    let representativeImageURL: String? = ""
    let title, type: String?
    let work: WorkRequest?

    enum CodingKeys: String, CodingKey {
        case ageMax, ageMin, career, casting, categories, domains, gender, imageUrls, numberOfRecruits
        case recruitmentEndDate, recruitmentStartDate
        case representativeImageURL = "representativeImageUrl"
        case title, type, work
    }
    
    init(recruitBasicInfo: RecruitBasicInfo?,
         recruitConditionInfo: RecruitConditionInfo?,
         recruitWorkInfo: RecruitWorkInfo?,
         recruitWorkConditionInfo: RecruitWorkConditionInfo?,
         recruitDetailInfo: RecruitDetailInfo?,
         recruitContactInfo: RecruitContactInfo?, jobType: Job?) {
        ageMax = recruitConditionInfo?.ageMax ?? 0
        ageMin = recruitConditionInfo?.ageMin ?? 0
        career = recruitConditionInfo?.career ?? ""
        casting = recruitConditionInfo?.casting ?? ""
        categories = recruitBasicInfo?.categories?.map { $0.serverName }
        domains = recruitConditionInfo?.domains
        gender = recruitConditionInfo?.gender
        imageUrls = recruitBasicInfo?.imageUrls ?? []
        numberOfRecruits = recruitConditionInfo?.numberOfRecruits ?? 0
        recruitmentEndDate = recruitBasicInfo?.endDate ?? ""
        recruitmentStartDate = recruitBasicInfo?.startDate ?? ""
        title = recruitBasicInfo?.title
        type = jobType?.serverName
        work = WorkRequest(recruitWorkInfo: recruitWorkInfo, recruitWorkConditionInfo: recruitWorkConditionInfo, recruitDetailInfo: recruitDetailInfo, recruitContactInfo: recruitContactInfo)
    }
}

struct WorkRequest: Codable {
    let details, director, email: String?
    let genres: [String]?
    let logline, manager, produce: String?
    let salary: Int?
    let salaryType: String?
    let selectedDays: [String]?
    let workTitle, workingCity, workingDistrict: String?
    let workingStartTime, workingEndTime: String?
    let workingStartDate, workingEndDate: String?
    
    init(recruitWorkInfo: RecruitWorkInfo?,
         recruitWorkConditionInfo: RecruitWorkConditionInfo?,
         recruitDetailInfo: RecruitDetailInfo?,
         recruitContactInfo: RecruitContactInfo?) {
        details = recruitDetailInfo?.details
        director = recruitWorkInfo?.director
        email = recruitContactInfo?.email
        genres = recruitWorkInfo?.genres
        logline = recruitWorkInfo?.logline
        manager = recruitContactInfo?.manager
        produce = recruitWorkInfo?.produce
        salary = recruitWorkConditionInfo?.salary
        salaryType = recruitWorkConditionInfo?.salaryType
        selectedDays = recruitWorkConditionInfo?.selectedDays
        workTitle = recruitWorkInfo?.workTitle
        workingCity = recruitWorkConditionInfo?.workingCity
        workingDistrict = recruitWorkConditionInfo?.workingDistrict
        workingEndDate = recruitWorkConditionInfo?.workingEndDate
        workingEndTime = recruitWorkConditionInfo?.workingEndTime
        workingStartDate = recruitWorkConditionInfo?.workingStartDate
        workingStartTime = recruitWorkConditionInfo?.workingStartTime
    }
}
