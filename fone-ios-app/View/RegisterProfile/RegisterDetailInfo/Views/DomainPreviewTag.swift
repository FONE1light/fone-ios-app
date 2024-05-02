//
//  DomainPreviewTag.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/7/23.
//

import UIKit
import Then

class DomainPreviewTag: UIView {
    
    private let label = UILabel().then {
        $0.font = .font_m(12)
    }
    
    init(_ selectionType: Selection? = nil, title: String? = nil) {
        super.init(frame: .zero)
        
        addSubview(label)
        
        if let name = selectionType?.name {
            label.text = name
        } else {
            label.text = title
        }
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        label.textColor = .red_CE0B39
        self.backgroundColor = .red_FFEBF0
        self.cornerRadius = 11
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(14)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
