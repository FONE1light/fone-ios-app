//
//  HomeInfoProvider.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/12.
//

import Foundation
import Moya

enum HomeInfoTarget {
    case fetchHome
}

extension HomeInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        return "/api/v1/homes"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchHome:
            let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
            let authorization = "Bearer \(accessToken)"
            return ["Authorization": authorization]
        }
    }
}

let homeInfoProvider = MoyaProvider<HomeInfoTarget>()
