//
//  UserInfoAPIRequestModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/24/23.
//

import Foundation

// MARK: - SignInInfo. API 아닌 화면에서 사용하는 모델
struct SignInInfo {
    var name: String?
    var emailSignInInfo: EmailSignInInfo?
}

// MARK: - EmailSignInInfo
struct EmailSignInInfo: Codable {
    let email: String
    let password: String
}

// MARK: - EmailSignUpInfo
struct EmailSignUpInfo: Codable {
    let name, email, password: String
    
    let job: String
    let interests: [String]
    
    let nickname, birthday, gender: String
    let profileUrl: String
    
    let phoneNumber: String
    let agreeToTermsOfServiceTermsOfUse: Bool
    let agreeToPersonalInformation: Bool
    let isReceiveMarketing: Bool
    
    let token, identifier: String
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
    var phoneNumber: String?
    var agreeToTermsOfServiceTermsOfUse: Bool?
    var agreeToPersonalInformation: Bool?
    var isReceiveMarketing: Bool?
}
