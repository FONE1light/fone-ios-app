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
    
    /// 분야(스태프) 혹은 장르(배우)
    private let domainLabel = UILabel().then {
        $0.font = .font_m(13)
        $0.textColor = .gray_9E9E9E
    }
    
    /// 제작 주제
    private let produceLabel = UILabel().then {
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
        domainOrGenre: String? = nil, // STAFF 일 때는 domain, ACTOR 일 때는 genre
        produce: String? = nil
        
    ) {
        dDayLabel.text = dDay
        domainLabel.text = domainOrGenre
        produceLabel.text = produce
    }
    
    private func setupUI() {
        [
            dDayLabel,
            dotLabel,
            domainLabel,
            produceLabel
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
        
        domainLabel.snp.makeConstraints {
            $0.centerY.equalTo(dDayLabel)
            $0.leading.equalTo(dotLabel.snp.trailing).offset(4)
        }
        
        produceLabel.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).offset(6)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
