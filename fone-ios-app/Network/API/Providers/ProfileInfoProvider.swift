//
//  ProfileInfoProvider.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/27/23.
//

import Foundation
import Moya

enum ProfileInfoTarget {
    case profiles(type: Job, sort: String, page: Int, size: Int)
    case profileDetail(profileId: Int, type: Job)
    /// 내가 찜한 프로필 조회
    case profilesWanted(type: Job)
    /// 프로필 찜하기/찜 해제하기
    case profileWant(profileId: Int)
    case myRegistrations
    case deleteProfile(profileId: Int)
    
    // 유효성 검사, 등록하기
    case validateContact(request: RegisterContactLinkInfo)
    case validateBasicInfo(request: RegisterBasicInfo)
    case validateDetailInfo(request: RegisterDetailInfo)
    case validateDetailContent(request: RegisterDetailContentInfo)
    case validateCareer(request: RegisterCareerInfo)
    case validateInterst(request: RegisterInterestInfo)
    case registerProfile(request: ProfileRequest)
}

extension ProfileInfoTarget: TargetType {
    var baseURL: URL {
        APISetting.shared.config.baseURL.url!
    }
    
    var path: String {
        switch self {
        case .profiles:
            return "/api/v1/profiles"
        case .profileDetail(let profileId, _):
            return "/api/v1/profiles/\(profileId)"
        case .profilesWanted:
            return "/api/v1/profiles/wants"
        case .profileWant(let profileId):
            return "/api/v1/profiles/\(profileId)/want"
        case .myRegistrations:
            return "/api/v1/profiles/my-registrations"
        case .deleteProfile(let profileId):
            return "/api/v1/profiles/\(profileId)"
            
        case .validateContact:
            return "/api/v1/profiles/validate/contact"
        case .validateBasicInfo:
            return "/api/v1/profiles/validate/basic"
        case .validateDetailInfo:
            return "/api/v1/profiles/validate/details"
        case .validateDetailContent:
            return "/api/v1/profiles/validate/description"
        case .validateCareer:
            return "/api/v1/profiles/validate/career"
        case .validateInterst:
            return "/api/v1/profiles/validate/interest"
        case .registerProfile:
            return "/api/v1/profiles"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profileWant,
                .validateContact,
                .validateBasicInfo,
                .validateDetailInfo,
                .validateDetailContent,
                .validateCareer,
                .validateInterst,
                .registerProfile:
            return .post
        case .deleteProfile:
            return .delete
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .profiles(type, sort, page, size):
            return .requestParameters(parameters: [
                "type": type.name,
                "sort": sort,
                "page": page,
                "size": size
            ], encoding: URLEncoding.default)
        case let .profileDetail(_, type):
            return .requestParameters(parameters: ["type": type.name], encoding: URLEncoding.default)
        case let .profilesWanted(type):
            return .requestParameters(parameters: [
                "type": type.name
            ], encoding: URLEncoding.default)
        case let .deleteProfile(profileId):
            return .requestParameters(parameters: [
                "profileId": profileId
            ], encoding: URLEncoding.default)
        case let .validateContact(request):
            return .requestJSONEncodable(request)
        case let .validateBasicInfo(request):
            return .requestJSONEncodable(request)
        case let .validateDetailInfo(request):
            return .requestJSONEncodable(request)
        case let .validateDetailContent(request):
            return .requestJSONEncodable(request)
        case let .validateCareer(request):
            return .requestJSONEncodable(request)
        case let .validateInterst(request):
            return .requestJSONEncodable(request)
        case let .registerProfile(request):
            return .requestJSONEncodable(request)
        case .profileWant, .myRegistrations:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let accessToken = Tokens.shared.accessToken.value
        let authorization = "Bearer \(accessToken)"
        return ["Authorization": authorization]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

let profileInfoProvider = MoyaProvider<ProfileInfoTarget>(session: Session(interceptor: AuthInterceptor.shared))
