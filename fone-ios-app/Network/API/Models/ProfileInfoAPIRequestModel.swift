//
//  ProfileInfoAPIRequestModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/21/24.
//

struct ProfileRequest: Codable {
    let type: String?
    let firstPage: RegisterContactLinkInfo?
    let secondPage: RegisterBasicInfo?
    let thirdPage: RegisterDetailInfo?
    let fourthPage: RegisterDetailContentInfo?
    let fifthPage: RegisterCareerInfo?
    let sixthPage: RegisterInterestInfo?

    init(
        jobType: String?,
        registerContactLinkInfo: RegisterContactLinkInfo?,
        registerBasicInfo: RegisterBasicInfo?,
        registerDetailInfo: RegisterDetailInfo?,
        registerDetailContentInfo: RegisterDetailContentInfo?,
        registerCareerInfo: RegisterCareerInfo?,
        registerInterestInfo: RegisterInterestInfo?
        
    ) {
        type = jobType
        firstPage = registerContactLinkInfo
        secondPage = registerBasicInfo
        thirdPage = registerDetailInfo
        fourthPage = registerDetailContentInfo
        fifthPage = registerCareerInfo
        sixthPage = registerInterestInfo
    }
}

// 페이지1: 연락 링크
struct RegisterContactLinkInfo: Codable {
    let contactMethod: String?
    let contact: String?
}

// 페이지2: 기본 정보 입력
struct RegisterBasicInfo: Codable {
    let name, hookingComment: String?
    let profileImages: [String]?
    let representativeImageURL: String?

    enum CodingKeys: String, CodingKey {
        case name, hookingComment, profileImages
        case representativeImageURL = "representativeImageUrl"
    }
}

// 페이지3: 상세 정보 입력
struct RegisterDetailInfo: Codable {
    let birthday, gender: String?
    let height, weight: Int?
    let email: String?
    let domains: [String]?
    let specialty: String?
    let snsUrls: [SnsURL]?
}

// 페이지4: 상세 요강 입력
struct RegisterDetailContentInfo: Codable {
    let details: String?
}

// 페이지5: 주요 경력 입력
struct RegisterCareerInfo: Codable {
    let career, careerDetail: String?
}

// 페이지6: 관심사 선택
struct RegisterInterestInfo: Codable {
    let categories: [String]?
}

// MARK: - SnsURL
struct SnsURL: Codable {
    // e.g. "YOUTUBE"
    let sns: String?
    let url: String?
}
