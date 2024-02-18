//
//  JobInfoAPIRequestModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 1/27/24.
//

import Foundation

// MARK: - JobOpeningRequest
struct JobOpeningRequest: Codable {
    let type: String?
    let firstPage: RecruitContactLinkInfo?
    let secondPage: RecruitBasicInfo?
    let thirdPage: RecruitConditionInfo?
    let fourthPage: RecruitWorkInfo?
    let fifthPage: RecruitWorkConditionInfo?
    let sixthPage: RecruitDetailInfo?
    let seventhPage: RecruitContactInfo?
    
    init(recruitContactLinkInfo: RecruitContactLinkInfo?,
         recruitBasicInfo: RecruitBasicInfo?,
         recruitConditionInfo: RecruitConditionInfo?,
         recruitWorkInfo: RecruitWorkInfo?,
         recruitWorkConditionInfo: RecruitWorkConditionInfo?,
         recruitDetailInfo: RecruitDetailInfo?,
         recruitContactInfo: RecruitContactInfo?, jobType: Job?) {
        type = jobType?.serverName
        firstPage = recruitContactLinkInfo
        secondPage = recruitBasicInfo
        thirdPage = recruitConditionInfo
        fourthPage = recruitWorkInfo
        fifthPage = recruitWorkConditionInfo
        sixthPage = recruitDetailInfo
        seventhPage = recruitContactInfo
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
