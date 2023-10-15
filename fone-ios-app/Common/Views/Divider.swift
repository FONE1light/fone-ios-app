//
//  Divider.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/24.
//

import UIKit
import SnapKit

class Divider: UIView {
    
    private var width: ConstraintRelatableTarget?
    private var height: ConstraintRelatableTarget?
    private var color: UIColor
    
    init(
        width: ConstraintRelatableTarget? = nil,
        height: ConstraintRelatableTarget? = nil,
        color: UIColor = .gray_D9D9D9
    ) {
        
        self.width = width
        self.height = height
        self.color = color
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        backgroundColor = color
        cornerRadius = 0.5
    }
    
    private func setConstraints() {
        snp.makeConstraints {
            if let nonOptionalWidth = width {
                $0.width.equalTo(nonOptionalWidth)
            }
            if let nonOptionalHeight = height {
                $0.height.equalTo(nonOptionalHeight)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
