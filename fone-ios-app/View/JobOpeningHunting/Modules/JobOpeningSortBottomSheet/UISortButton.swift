//
//  UISortButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/16/23.
//

import UIKit
import SnapKit
import Then

class UISortButton: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel?.font = .font_b(14)
            } else {
                titleLabel?.font = .font_r(14)
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    private func setupUI() {
        setTitleColor(.gray_555555, for: .normal)
        setTitleColor(.red_CE0B39, for: .selected)
        titleLabel?.font = .font_r(14)
        contentHorizontalAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
