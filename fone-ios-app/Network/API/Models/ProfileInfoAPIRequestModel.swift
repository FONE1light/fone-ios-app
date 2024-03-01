//
//  ProfileInfoAPIRequestModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/21/24.
//

// 페이지1: 연락 링크
struct ContactRequest: Codable {
    let contact: String?
    let contactMethod: String?
}

// 페이지2: 기본 정보 입력
struct BasicInfoRequest: Codable {
    let name, hookingComment: String?
    let profileImages: [String]?
    let representativeImageURL: String?

    enum CodingKeys: String, CodingKey {
        case hookingComment, name, profileImages
        case representativeImageURL = "representativeImageUrl"
    }
}

// 페이지3: 상세 정보 입력
struct DetailInfoRequest: Codable {
    let birthday: String?
    let domains: [String]?
    let email, gender: String?
    let height: Int?
    let snsUrls: [SnsURL]?
    let specialty: String?
    let weight: Int?
}

// 페이지4: 상세 요강 입력
struct DetailContentRequest: Codable {
    let details: String?
}

// 페이지5: 주요 경력 입력
struct CareerRequest: Codable {
    let career, careerDetail: String?
}

// 페이지6: 관심사 선택
struct InterestRequest: Codable {
    let categories: [String]?
}
