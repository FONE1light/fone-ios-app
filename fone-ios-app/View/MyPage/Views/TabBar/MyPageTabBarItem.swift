//
//  MyPageTabBarItem.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/24.
//

import UIKit

class MyPageTabBarItem: UITabBarItem {
    
    init(title: String?, tag: Int) {
        super.init()
        
        self.title = title
        self.image = nil
        self.tag = tag
        
        let fontAttributes = [
            NSAttributedString.Key.font: UIFont.font_r(14),
//            NSAttributedString.Key.foregroundColor: UIColor.gray_9E9E9E,
        ]
        let selectedFontAttributes = [
            NSAttributedString.Key.font: UIFont.font_m(14),
            NSAttributedString.Key.foregroundColor: UIColor.red_CE0B39,
//            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick,
//            NSAttributedString.Key.underlineColor: UIColor.red_CE0B39,
//            NSAttributedString.Key.backgroundColor: UIColor.white,
        ]
        
        setTitleTextAttributes(fontAttributes, for: .normal)
        setTitleTextAttributes(selectedFontAttributes, for: .selected)
        titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
