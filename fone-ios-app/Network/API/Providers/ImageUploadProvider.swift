//
//  ImageUploadProvider.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/29/23.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum ImageUploadTarget {
    case uploadImage(images: ImageUploadRequestModel)
}

extension ImageUploadTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.imageUploadBaseURL.url!
    }
    
    var path: String {
        switch self {
        case .uploadImage: "/prod/image-upload/user-profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadImage: .post
        }
    }
    
    var task: Task {
        switch self {
        case let .uploadImage(images):
            return .requestJSONEncodable(images)
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json;charset=UTF-8"]
    }
}


let imageUploadProvider = MoyaProvider<ImageUploadTarget>()
