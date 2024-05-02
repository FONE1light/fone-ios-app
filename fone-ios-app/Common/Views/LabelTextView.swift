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
class LabelTextView: UIView {
    
    private let label = UILabel().then {
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let starImageView = UIImageView().then {
        $0.image = UIImage(named: "star")
        $0.isHidden = true
    }
    
    // FIXME: placeholderString 유저 입력 시 입력 가능하도록 수정
    var text: String? {
        let text = letterCountedTextView?.textView?.text
        return text == placeholderString ? "" : text
    }
    
    private var letterCountedTextView: LetterCountedTextView?
    
    private var placeholderString: String?
    
    /// - Parameters:
    ///   - label: UILabel에 들어갈 텍스트
    ///   - placeholder: UITextView에 들어갈 placeholder
    ///   - isRequired: 필수 항목인지 아닌지
    init(
        label text: String?,
        placeholder: String?,
        textViewHeight: CGFloat = 74,
        isRequired: Bool? = false,
        maximumLetterCount: Int = 50
    ) {
        placeholderString = placeholder
        letterCountedTextView = LetterCountedTextView(
            placeholder: placeholder,
            textViewHeight: textViewHeight,
            maximumLetterCount: maximumLetterCount
        )
        
        super.init(frame: .zero)
        
        label.text = text
        
        if isRequired == true {
            starImageView.isHidden = false
        }
        
        setupUI()
        setConstraints()
    }
    
    /// xib에서 사용 시 필요한 초기화 함수
    /// - top, leading, trailing constraints 잡으면 되고 textView의 높이를 바꾸고 싶다면 textViewHeight로 조정해야 함
    ///
    /// - Parameters:
    ///   - label: UILabel에 들어갈 텍스트
    ///   - placeholder: UITextView에 들어갈 placeholder
    ///   - isRequired: 필수 항목인지 아닌지(* 표기)
    func xibInit(
        label text: String?,
        placeholder: String?,
        textViewHeight: CGFloat = 74,
        isRequired: Bool? = false,
        maximumLetterCount: Int = 50
    ) {
        placeholderString = placeholder
        letterCountedTextView = LetterCountedTextView(
            placeholder: placeholder,
            textViewHeight: textViewHeight,
            maximumLetterCount: maximumLetterCount
        )
        
        label.text = text
        
        if isRequired == true {
            starImageView.isHidden = false
        }
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        guard let letterCountedTextView = letterCountedTextView else { return }
        [label, starImageView, letterCountedTextView]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        guard let letterCountedTextView = letterCountedTextView else { return }
        
        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        starImageView.snp.makeConstraints {
            $0.centerY.equalTo(label)
            $0.leading.equalTo(label.snp.trailing).offset(2)
            $0.size.equalTo(8)
        }
        
        letterCountedTextView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
