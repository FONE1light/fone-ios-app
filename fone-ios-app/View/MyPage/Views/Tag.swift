//
//  Tag.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/25.
//

import UIKit
import Then

class Tag: UIView {
    
    private let label = UILabel().then {
        $0.font = .font_m(12)
    }
    
    init(_ selectionType: Selection? = nil) {
        super.init(frame: .zero)
        
        backgroundColor = .yellow
        addSubview(label)
        
        if let selectionType = selectionType {
            setupUI(selectionType)
        }
        setConstraints()
    }
    
    func setType(as selectionType: Selection) {
        setupUI(selectionType)
    }
    
    private func setupUI(_ selectionType: Selection) {
        label.text = selectionType.name
        label.textColor = selectionType.tagTextColor
        self.backgroundColor = selectionType.tagBackgroundColor
        
        if let cornerRadius = selectionType.tagCornerRadius {
            self.cornerRadius = cornerRadius
        }
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
