//
//  NavigationTitleView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/07.
//

import UIKit

class NavigationTitleView: UILabel {
    
    init(title: String?) {
        super.init(frame: .zero)
        
        text = title
        font = .font_b(19)
        textColor = .gray_161616
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
