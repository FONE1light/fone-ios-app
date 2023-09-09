//
//  BottomButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/07.
//

import UIKit

class BottomButton: UIButton {
    
    init(title: String? = "다음") {
        super.init(frame: .zero)
        setUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(title: String?) {
        backgroundColor = .red_C0002C
        setTitle(title, for: .normal)
        titleLabel?.font = .font_m(16)
        titleLabel?.textColor = .white_FFFFFF
        cornerRadius = 5
        applyShadow(shadowType: .shadowBt)
        
    }
}
