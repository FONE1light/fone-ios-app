//
//  BottomButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/07.
//

import UIKit

class BottomButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .red_C0002C
        setTitle("다음", for: .normal)
        titleLabel?.font = .font_m(16)
        titleLabel?.textColor = .white_FFFFFF
        cornerRadius = 5
        applyShadow(shadowType: .shadowBt)
        
    }
}
