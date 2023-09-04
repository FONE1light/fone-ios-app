//
//  UIFont+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/11.
//

import UIKit

// 추후 폰트 종류가 추가되면 아래 case 추가
enum FontType {
    case pretendard
    
    var regular: String { // weight 400
        switch self {
        case .pretendard: return "Pretendard-Regular"
        }
    }
    var medium: String { // weight 500
        switch self {
        case .pretendard: return "Pretendard-Medium"
        }
    }
    var bold: String { // weight 700
        switch self {
        case .pretendard: return "Pretendard-Bold"
        }
    }
}

extension UIFont {
    
    /// Bold 타입(weight 700)
    class func font_b(_ size: CGFloat) -> UIFont {
        let fontName = FontType.pretendard.bold
        guard let font = UIFont(name: fontName, size: size) else {
            return .systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    /// Medium 타입(weight 500)
    class func font_m(_ size: CGFloat) -> UIFont {
        let fontName = FontType.pretendard.medium
        guard let font = UIFont(name: fontName, size: size) else {
            return .systemFont(ofSize: size, weight: .medium)
        }

        return font
    }

    /// Regular 타입(weight 400)
    class func font_r(_ size: CGFloat) -> UIFont {
        let fontName = FontType.pretendard.regular
        guard let font = UIFont(name: fontName, size: size) else {
            return .systemFont(ofSize: size, weight: .regular)
        }

        return font
    }
    
}
