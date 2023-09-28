//
//  Category.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/14.
//

import UIKit

enum Category: String, Selection, CaseIterable {
    case FEATURE_FILM
    case SHORT_FILM
    case INDEPENDENT_FILM
    case WEB_DRAMA
    case MOVIE
    case OTT_DRAMA
    case YOUTUBE
    case VIRAL
    case ETC
    
    var name: String {
        switch self {
        case .FEATURE_FILM: return "장편영화"
        case .SHORT_FILM: return "단편영화"
        case .INDEPENDENT_FILM: return "독립영화"
        case .WEB_DRAMA: return "웹 드라마"
        case .MOVIE: return "뮤비 / CF"
        case .OTT_DRAMA: return "OTT/TV 드라마"
        case .YOUTUBE: return "유튜브"
        case .VIRAL: return "홍보 / 바이럴"
        case .ETC: return "기타"
        }
    }
    
    var serverName: String {
        switch self {
        case .FEATURE_FILM: return "FEATURE_FILM"
        case .SHORT_FILM: return "SHORT_FILM"
        case .INDEPENDENT_FILM: return "INDEPENDENT_FILM"
        case .WEB_DRAMA: return "WEB_DRAMA"
        case .MOVIE: return "MOVIE"
        case .OTT_DRAMA: return "OTT_DRAMA"
        case .YOUTUBE: return "YOUTUBE"
        case .VIRAL: return "VIRAL"
        case .ETC: return "ETC"
        }
    }
    
    var tagTextColor: UIColor? {
        UIColor.violet_6D5999
    }
    
    var tagBackgroundColor : UIColor? {
        UIColor.gray_EEEFEF
    }
    
    var tagCornerRadius: CGFloat? {
        return 10 // TODO: 디자인 값 확정 후 수정
    }
}
