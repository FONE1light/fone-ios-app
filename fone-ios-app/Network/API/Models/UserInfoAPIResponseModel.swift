//
//  UserInfoAPIResponseModel.swift
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
    let agreeToPersonalInformation, agreeToTermsOfServiceTermsOfUse: Bool?
    let birthday, email: String?
    let enabled: Bool?
    let gender: String?
    let id: Int?
    let identifier: String?
    let interests: [String]?
    let isReceiveMarketing: Bool?
    let job, loginType, nickname, phoneNumber: String?
    let profileURL: String?
    let isVerified: Bool?
    
    enum CodingKeys: String, CodingKey {
        case agreeToPersonalInformation, agreeToTermsOfServiceTermsOfUse, birthday, email, enabled, gender, id, identifier, interests, isReceiveMarketing, job, loginType, nickname, phoneNumber, isVerified
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
    let data: NicknameInfo?
    let message: String
    let errorCode: String?
}

// MARK: - NicknameInfo
struct NicknameInfo: Codable {
    let nickname: String
    let isDuplicate: Bool
}

// MARK: - SignInResponseModel (email, social login)
struct SignInResponseModel: Codable {
    let result: String
    let data: SignInData?
    let message: String
    let errorCode: String?
}

// MARK: - SignInData (email, social login)
struct SignInData: Codable {
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

// MARK: - FindIDResponseModel
struct FindIDResponseModel: Codable {
    let result: String
    let data: FindIDResponseData?
    let message: String
    let errorCode: String?
}

// MARK: - FindIDResponseData
struct FindIDResponseData: Codable {
    let email, loginType: String
}

// MARK: - SendSMSResponseModel
struct FindPasswordResponseModel: Codable {
    let result: String
    let data: [String: String]?
    let message: String
    let errorCode: String?
}

// MARK: - SignUpResponseModel (email, social login)
struct SignUpResponseModel: Codable {
    let result: String?
    let data: SignUpData?
    let message: String?
    let errorCode: String?
}

// MARK: - SignUpData (email, social login)
struct SignUpData: Codable {
    let user: User?
    let token: TokenModel?
}

