//
//  ImageUploadAPIModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/29/23.
//

import Foundation

// MARK: - Request
struct ImageUploadRequestModel: Codable {
    let images: [ImageInfoToUpload]
}

struct ImageInfoToUpload: Codable {
    let imageData, resource: String
    let stageVariables: StageVariables
}

struct StageVariables: Codable {
    let stage: String
}

// MARK: - Response
struct ImageUploadResponseModel: Codable {
    let result: String?
    let data: [ImageUrl]?
    let message: String?
    let errorCode: String?
}

struct ImageUrl: Codable {
    let imageUrl: String?
}
