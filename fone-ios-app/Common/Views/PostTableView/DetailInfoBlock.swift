//
//  DetailInfoBlock.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/14.
//

import UIKit
import SnapKit

class DetailInfoBlock: UIView {
    private let dDayLabel = UILabel().then {
        $0.font = .font_m(13)
        $0.textColor = .violet_6D5999
    }
    
    private let dotLabel = UILabel().then {
        $0.text = "·"
        $0.font = .font_m(13)
        $0.textColor = .gray_555555
    }
    private let fieldLabel = UILabel().then {
        $0.font = .font_m(13)
        $0.textColor = .gray_9E9E9E
    }
    
    private let coorporateLabel = UILabel().then {
        $0.font = .font_m(13)
        $0.textColor = .gray_9E9E9E
    }
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    func setValues(
        dDay: String? = nil,
        coorporate: String? = nil,
//        casting: String? = nil,
        field: String? = nil // FIXME: STAFF 일 때는 field, ACTOR 일 때는 casting 넣어야할듯. 서버 데이터 보고 결정
    ) {
        dDayLabel.text = dDay
        fieldLabel.text = field
        coorporateLabel.text = coorporate
    }
    
    private func setupUI() {
        [
            dDayLabel,
            dotLabel,
            fieldLabel,
            coorporateLabel
        ]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        dDayLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        dotLabel.snp.makeConstraints {
            $0.centerY.equalTo(dDayLabel)
            $0.leading.equalTo(dDayLabel.snp.trailing).offset(4)
        }
        
        fieldLabel.snp.makeConstraints {
            $0.centerY.equalTo(dDayLabel)
            $0.leading.equalTo(dotLabel.snp.trailing).offset(4)
        }
        
        coorporateLabel.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).offset(6)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
