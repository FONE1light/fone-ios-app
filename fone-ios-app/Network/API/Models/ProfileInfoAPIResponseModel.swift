//
//  ProfileInfoAPIResponseModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/27/23.
//

// MARK: - ProfilesData
struct ProfilesData: Codable {
    let profiles: ProfilesContent?
}

// FIXME: 추후 개발하며 필요한 것 주석 해제
// MARK: - Profiles
struct ProfilesContent: Codable {
    let content: [ProfileContent]?
//    let pageable: Pageable?
//    let last: Bool?
//    let totalPages, totalElements, size, number: Int?
//    let sort: Sort?
//    let first: Bool?
//    let numberOfElements: Int?
//    let empty: Bool?
}

// MARK: - ProfileData
struct ProfileData: Codable {
    let profile: ProfileContent?
}
