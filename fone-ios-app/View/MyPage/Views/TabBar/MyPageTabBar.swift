//
//  MyPageTabBar.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/24.
//

import UIKit

class MyPageTabBar: UITabBar {
    
    private var width: Double?
    private var height: Double?
    
    init(width: Double, height: Double) {
        super.init(frame: .zero)
        
        barTintColor = .white
        unselectedItemTintColor = .gray_9E9E9E
        barStyle = .black
        
        self.width = width
        self.height = height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        
        guard
            let itemsCount = items?.count,
            let width = width,
            let itemHeight = height else { return }
        
        let itemWidth = width/Double(itemsCount)
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
