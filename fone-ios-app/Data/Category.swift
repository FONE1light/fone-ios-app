//
//  Category.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/14.
//

import UIKit

enum Category: Selection, CaseIterable {
    case featureFilm
    case shortFilm
    case independentFilm
    case webDrama
    case musicVideo
    case ottDrama
    case youtube
    case viral
    case etc
    
    var name: String {
        switch self {
        case .featureFilm: return "장편영화"
        case .shortFilm: return "단편영화"
        case .independentFilm: return "독립영화"
        case .webDrama: return "웹 드라마"
        case .musicVideo: return "뮤비 / CF"
        case .ottDrama: return "OTT/TV 드라마"
        case .youtube: return "유튜브"
        case .viral: return "홍보 / 바이럴"
        case .etc: return "기타"
        }
    }
    
    var serverName: String {
        switch self {
        case .featureFilm: return "FEATURE_FILM"
        case .shortFilm: return "SHORT_FILM"
        case .independentFilm: return "INDEPENDENT_FILM"
        case .webDrama: return "WEB_DRAMA"
        case .musicVideo: return "MOVIE"
        case .ottDrama: return "OTT_DRAMA"
        case .youtube: return "YOUTUBE"
        case .viral: return "VIRAL"
        case .etc: return "ETC"
        }
    }
    
    var tagTextColor: UIColor? {
        UIColor.violet_6D5999
    }
    
    var tagBackgroundColor : UIColor? {
        UIColor.gray_EEEFEF
    }
    
    var tagCornerRadius: CGFloat? {
        return 11
    }
}
