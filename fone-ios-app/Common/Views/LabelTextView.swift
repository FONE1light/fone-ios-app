//
//  LabelTextView.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/18/23.
//

import UIKit
import Then
import SnapKit

/// UILabel과 UITextView로 구성된 뷰
class LabelTextView: UIView, UITextViewDelegate {
    
    private let label = UILabel().then {
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let starImageView = UIImageView().then {
        $0.image = UIImage(named: "star")
        $0.isHidden = true
    }
    
    private let textView: DefaultTextView
    
    private let letterCountLabel = UILabel()
    
    private let placeholderString: String?
    
    /// - Parameters:
    ///   - label: UILabel에 들어갈 텍스트
    ///   - placeholder: UITextView에 들어갈 placeholder
    ///   - isRequired: 필수 항목인지 아닌지
    init(
        label text: String?,
        placeholder: String?,
        textViewHeight: CGFloat = 74,
        maximumLetterCount: Int = 50,
        isRequired: Bool? = false
    ) {
        placeholderString = placeholder
        textView = DefaultTextView(placeholder: placeholder, height: textViewHeight)
        
        super.init(frame: .zero)
        
        label.text = text
        
        if isRequired == true {
            starImageView.isHidden = false
        }
        
        setupUI()
        setConstraints()
        bindText(maximumLetterCount: maximumLetterCount)
    }
    
    private func setupUI() {
        [label, starImageView, textView, letterCountLabel]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        starImageView.snp.makeConstraints {
            $0.centerY.equalTo(label)
            $0.leading.equalTo(label.snp.trailing).offset(2)
            $0.size.equalTo(8)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        letterCountLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(2)
            $0.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private func bindText(maximumLetterCount: Int) {
        // 글자수 제한
        textView.rx.text
            .map { String($0?.prefix(maximumLetterCount) ?? "") }
            .bind(to: textView.rx.text)
            .disposed(by: rx.disposeBag)
        
        // 우측 하단 letterCountLabel 글자수 표시
        textView.rx.text.orEmpty
            .map { $0 == self.placeholderString ? "" : $0 }
            .map { $0.count }
            .map { String($0) }
            .map ({ count -> NSMutableAttributedString in
                let formattedString = NSMutableAttributedString()
                formattedString.setAttributeText("\(count)", .font_r(12), UIColor.gray_555555)
                formattedString.setAttributeText("/\(maximumLetterCount)", .font_r(12), UIColor.gray_C5C5C5)
                return formattedString
            })
            .bind(to: letterCountLabel.rx.attributedText)
            .disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
