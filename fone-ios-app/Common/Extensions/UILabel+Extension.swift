//
//  UILabel+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/15.
//

import UIKit

extension UILabel {
//    public var lineHeight: CGFloat? {
//        get { paragraphStyle?.maximumLineHeight }
//        set {
//            let lineHeight = newValue ?? font.lineHeight
//            let baselineOffset = (lineHeight - font.lineHeight) / 4.0
//            addAttribute(.baselineOffset, value: baselineOffset)
//            setParagraphStyleProperty(lineHeight, for: \.minimumLineHeight)
//            setParagraphStyleProperty(lineHeight, for: \.maximumLineHeight)
//        }
//    }
    
    static func getLabelHeight(width: CGFloat, text: String, font: UIFont, line: Int = 0) -> CGFloat {
        if text.count == 0 {
            return 0
        }
        
        let constraintRect: CGSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
}
