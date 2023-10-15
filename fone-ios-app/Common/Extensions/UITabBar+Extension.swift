//
//  UITabBar+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/11.
//

import UIKit

extension UITabBar {
    struct Constants {
        /// leading, trailing inset
        static let horizontalInset: CGFloat = 16
        static let tabBarHeight: CGFloat = 38
    }
    
    func setUnderline(itemsCount: Int) {
        let tabBarwidth = UIScreen.main.bounds.width - Constants.horizontalInset * 2
        let itemHeight = Constants.tabBarHeight
        let itemWidth = tabBarwidth/Double(itemsCount)
        
        let selectedUnderLine = UIImage().createSelectionIndicator(
            color: .red_CE0B39,
            size: CGSize(
                width: itemWidth,
                height: itemHeight
            ),
            lineWidth: 2.0
        )
        
        self.selectionIndicatorImage = selectedUnderLine
    }
}
