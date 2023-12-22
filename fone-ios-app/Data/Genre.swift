//
//  Genre.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/4/23.
//

import UIKit

enum Genre: String {
    case ACTION,DOCUMENTARY, DRAMA, ETC, FANTASY, MUSICAL, ROMANCE, THRILLER
    
    var koreanName: String {
        switch self {
        case .ACTION: return "액션"
        case .DOCUMENTARY: return "다큐멘터리"
        case .DRAMA: return "드라마"
        case .ETC: return "기타"
        case .FANTASY: return "판타지"
        case .MUSICAL: return "뮤지컬"
        case .ROMANCE: return "로맨스"
        case .THRILLER: return "스릴러"
        }
    }
    
    var unselectedImage: UIImage {
        switch self {
        case .ACTION: return UIImage(resource: .actionOff)
        case .DOCUMENTARY: return UIImage(resource: .documentaryOff)
        case .DRAMA: return UIImage(resource: .dramaOff)
        case .ETC: return UIImage(resource: .otherOff)
        case .FANTASY: return UIImage(resource: .fantasyOff)
        case .MUSICAL: return UIImage(resource: .musicalOff)
        case .ROMANCE: return UIImage(resource: .romanceOff)
        case .THRILLER: return UIImage(resource: .thrillerOff)
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .ACTION: return UIImage(resource: .actionOn)
        case .DOCUMENTARY: return UIImage(resource: .documentaryOn)
        case .DRAMA: return UIImage(resource: .dramaOn)
        case .ETC: return UIImage(resource: .otherOn)
        case .FANTASY: return UIImage(resource: .fantasyOn)
        case .MUSICAL: return UIImage(resource: .musicalOn)
        case .ROMANCE: return UIImage(resource: .romanceOn)
        case .THRILLER: return UIImage(resource: .thrillerOn)
        }
    }
}
