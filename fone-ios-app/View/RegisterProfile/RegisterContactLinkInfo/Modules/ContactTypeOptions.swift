//
//  ContactTypeOptions.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/21/24.
//

import Foundation

enum ContactTypeOptions: CaseIterable, Options {
    case kakaoOpenChat
    case email
    case googleForm
    
    var title: String? {
        switch self {
        case .kakaoOpenChat: "카카오 오픈채팅"
        case .email: "이메일"
        case .googleForm: "구글폼"
        }
    }
    
    var serverParameter: String? {
        switch self {
        case .kakaoOpenChat: "KAKAO"
        case .email: "EMAIL"
        case .googleForm: "GOOGLE_FORM"
        }
    }
    
    var textFieldPlaceholder: String? {
        switch self {
        case .kakaoOpenChat, .googleForm: "링크를 첨부할 수 있어요"
        case .email: "이메일 주소를 첨부할 수 있어요"
        }
    }
    
    static func getType(title: String?) -> ContactTypeOptions? {
        ContactTypeOptions.allCases.filter { $0.title == title }.first
    }
}
