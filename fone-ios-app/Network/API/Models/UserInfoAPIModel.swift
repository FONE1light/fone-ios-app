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

// MARK: - ReissueTokenModel
struct ReissueTokenModel: Codable {
    let result: String
    let data: TokenModel
    let message: String
    let errorCode: String?
}

// MARK: - TokenModel
struct TokenModel: Codable {
    let accessToken, refreshToken, tokenType: String
    let expiresIn: Int
    let issuedAt: String
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

// MARK: - EmailSignInInfo
struct EmailSignInInfo: Codable {
    let email: String
    let password: String
}

// MARK: - EmailSignInResponseModel
struct EmailSignInResponseModel: Codable {
    let result: String
    let data: EmailSignInData?
    let message: String
    let errorCode: String?
}

// MARK: - EmailSignInData
struct EmailSignInData: Codable {
    let user: User
    let token: TokenModel
}

// MARK: - TokenInfo
struct TokenInfo: Codable {
    let accessToken: String
    let refreshToken: String
}

// MARK: - SendSMSResponseModel
struct SendSMSResponseModel: Codable {
    let result: String
    let message: String
    let errorCode: String?
}

