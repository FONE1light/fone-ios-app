//
//  TitleValueView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/25.
//

import UIKit
import SnapKit

enum TitleValueType {
    case deadline
    case coorporate
    case gender
    case period
    case casting
    case field
    
    var title: String? {
        switch self {
        case .deadline: return "모집마감일"
        case .coorporate: return "제작"
        case .gender: return "성별"
        case .period: return "촬영기간"
        case .casting: return "배역"
        case .field: return "분야"
            
        }
    }
}

class TitleValueView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.font = .font_m(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private let valueLabel = UILabel().then {
        $0.font = .font_m(12)
        $0.textColor = .gray_555555
    }
    
    init(type: TitleValueType, value: String? = nil) {
        super.init(frame: .zero)
        
        titleLabel.text = type.title
        valueLabel.text = value
        
        setupUI()
        setConstraints()
    }
    
    /// `valueLabel`에 넣을 값을 받되, `type`을 신규 값으로 변경하고 싶다면 값이 들어옴. nil이라면 init()에서 설정된 `type` 그대로 유지.
    func setValue(_ text: String?, type: TitleValueType? = nil) {
        valueLabel.text = text
        if let type = type {
            titleLabel.text = type.title
        }
    }
    
    private func setupUI() {
        [titleLabel, valueLabel]
            .forEach { self.addSubview($0) }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
