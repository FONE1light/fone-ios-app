//
//  TitleValueBlock.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/25.
//

import UIKit
import SnapKit

class TitleValueBlock: UIView {
    
    private let deadlineView = TitleValueView(type: .deadline)
    private let coorporateView = TitleValueView(type: .coorporate)
    private let genderView = TitleValueView(type: .gender)
    private let periodView = TitleValueView(type: .period)
    /// 배역 혹은 분야
    private var castingFieldView = TitleValueView(type: .casting)
    
    private let firstRowDivider = Divider(width: 1, height: 12)
    private let secondRowDivider = Divider(width: 1, height: 12)
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    func setValues(
        deadline: String? = nil,
        coorporate: String? = nil,
        gender: String? = nil,
        period: String? = nil,
        casting: String? = nil,
        field: String? = nil
    ) {
        deadlineView.setValue(deadline)
        coorporateView.setValue(coorporate)
        genderView.setValue(gender)
        periodView.setValue(period)
        castingFieldView.setValue(casting)
        
        if casting == nil {
            castingFieldView.setValue(field, type: .field)
        }
    }
    
    private func setupUI() {
        [
            deadlineView,
            coorporateView,
            genderView,
            periodView,
            castingFieldView,
            firstRowDivider,
            secondRowDivider
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        deadlineView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        firstRowDivider.snp.makeConstraints {
            $0.centerY.equalTo(deadlineView)
            $0.leading.equalTo(deadlineView.snp.trailing).offset(8)
        }
        coorporateView.snp.makeConstraints {
            $0.centerY.equalTo(deadlineView)
            $0.leading.equalTo(firstRowDivider.snp.trailing).offset(8)
        }
        
        genderView.snp.makeConstraints {
            $0.top.equalTo(deadlineView.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
        }
        
        secondRowDivider.snp.makeConstraints {
            $0.centerY.equalTo(genderView)
            $0.leading.equalTo(genderView.snp.trailing).offset(8)
        }
        
        periodView.snp.makeConstraints {
            $0.centerY.equalTo(genderView)
            $0.leading.equalTo(secondRowDivider.snp.trailing).offset(8)
        }
        
        castingFieldView.snp.makeConstraints {
            $0.top.equalTo(genderView.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
