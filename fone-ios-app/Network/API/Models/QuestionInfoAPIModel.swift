//
//  QuestionInfoAPIModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/30.
//

import Foundation

// MARK: - SubmitQuestionModel
struct SubmitQuestionModel: Codable {
    let result: String
    let data: Question?
    let message: String
    let errorCode: String?
}

// MARK: - Question
struct Question: Codable {
    let question: QuestionInfo
}

// MARK: - QuestionInfo
struct QuestionInfo: Codable {
    let email, type, title, description: String
    let agreeToPersonalInformation: Bool
}
