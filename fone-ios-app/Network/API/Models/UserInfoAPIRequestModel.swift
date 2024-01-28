//
//  UserInfoAPIRequestModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/24/23.
//

import Foundation

// MARK: - 로그인

enum SignInType {
    case email
    case social
}

// API 아닌 화면에서 사용하는 모델
// 로그인 API의 response에서 받아올 데이터의 모음
struct SignInInfo {
    var type: SignInType
    var name: String?
    /// 소셜로그인 일 때 사용
    var email: String?
    // AppleID 로그인 시 사용하는 user identifier
    var identifier: String?
    
    var emailSignInInfo: EmailSignInInfo?
    var socialSignInfo: SocialSignInInfo?
}

// MARK: - EmailSignInInfo
struct EmailSignInInfo: Codable {
    let email: String
    let password: String
}

// MARK: - SocialSignInInfo
struct SocialSignInInfo: Codable {
    let accessToken: String
    let loginType: String
}

// MARK: - 회원가입

// FIXME: optional로 바꾸고 SocialSignUpInfo와 통합?
// MARK: - EmailSignUpInfo
struct EmailSignUpInfo: Codable {
    let name, password: String
    let token: String
    
    let email: String
    
    let job: String
    let interests: [String]
    
    let nickname, birthday, gender: String
    let profileUrl: String
    
    let phoneNumber: String
    let agreeToTermsOfServiceTermsOfUse: Bool
    let agreeToPersonalInformation: Bool
    let isReceiveMarketing: Bool
    
    // AppleID 로그인 시에만 필요
    let identifier: String
}

struct SignUpSelectionInfo {
    let job: String?
    let interests: [String]?
}

struct SignUpPersonalInfo {
    let nickname, birthday, gender: String?
    let profileURL: String?
}

struct SignUpPhoneNumberInfo {
    let phoneNumber: String?
    let agreeToTermsOfServiceTermsOfUse: Bool?
    let agreeToPersonalInformation: Bool?
    let isReceiveMarketing: Bool?
}

// MARK: - SocialSignUpInfo
struct SocialSignUpInfo: Codable {
    let accessToken: String
    let loginType: String
    
    let email: String
    
    let job: String
    let interests: [String]
    
    let nickname, birthday, gender: String
    let profileUrl: String
    
    let phoneNumber: String
    let agreeToTermsOfServiceTermsOfUse: Bool
    let agreeToPersonalInformation: Bool
    let isReceiveMarketing: Bool
    
    /// AppleID 로그인 시 필요
    let identifier: String
}

/// 유저 수정 API request model
struct UserInfo: Codable {
    let interests: [String]?
    let job, nickname, profileURL: String?

    enum CodingKeys: String, CodingKey {
        case interests, job, nickname
        case profileURL = "profileUrl"
    }
}


