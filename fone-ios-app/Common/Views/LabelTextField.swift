//
//  LabelTextField.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/18/23.
//

import UIKit
import Then
import SnapKit

/// UILabel과 UITextField(DefaultTextField)로 구성된 뷰
class LabelTextField: UIView {
    
    private let label = UILabel().then {
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let starImageView = UIImageView().then {
        $0.image = UIImage(named: "star")
        $0.isHidden = true
    }
    
    private let textField: DefaultTextField
    
    private let textFieldLeadingOffset: CGFloat
    
    /// - Parameters:
    ///   - label: UILabel에 들어갈 텍스트
    ///   - placeholder: UITextField에 들어갈 placeholder
    ///   - isRequired: 필수 항목인지 아닌지
    ///   - textFieldLeadingOffset: 현재 뷰의 leading 기준으로 textField의 leading offset. 보통 62, 경우에 따라 50
    init(
        label text: String?, 
        placeholder: String?,
        isRequired: Bool? = false,
        textFieldLeadingOffset: CGFloat? = 62
    ) {
        textField = DefaultTextField(placeholder: placeholder)
        textField.font = .font_r(16)
        
        self.textFieldLeadingOffset = textFieldLeadingOffset ?? 62
        
        super.init(frame: .zero)
        
        label.text = text
        if isRequired == true {
            starImageView.isHidden = false
        }
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        [label, starImageView, textField]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        starImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(label.snp.trailing).offset(2)
            $0.size.equalTo(8)
        }
        
        textField.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(textFieldLeadingOffset)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
