//
//  UserInfoAPIModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/17.
//

import Foundation

struct UserInfoModel: Codable {
    // MARK: - UserInfoModel
    struct UserInfoModel: Codable {
        let user: User
    }

    // MARK: - User
    struct User: Codable {
        let agreeToPersonalInformation, agreeToTermsOfServiceTermsOfUse: Bool
        let birthday, email: String
        let enabled: Bool
        let gender: String
        let id: Int
        let identifier: String
        let interests: [String]
        let isReceiveMarketing: Bool
        let job, loginType, nickname, phoneNumber: String
        let profileURL: String
        
        enum CodingKeys: String, CodingKey {
            case agreeToPersonalInformation, agreeToTermsOfServiceTermsOfUse, birthday, email, enabled, gender, id, identifier, interests, isReceiveMarketing, job, loginType, nickname, phoneNumber
            case profileURL = "profileUrl"
        }
    }
}

// MARK: - CheckNicknameDuplicationModel
struct CheckNicknameDuplicationModel: Codable {
    let result: String
    let data: NicknameInfo
    let message: String
    let errorCode: String?
}

// MARK: - NicknameInfo
struct NicknameInfo: Codable {
    let nickname: String
    let isDuplicate: Bool
}