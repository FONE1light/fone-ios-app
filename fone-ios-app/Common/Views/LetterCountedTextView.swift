//
//  LetterCountedTextView.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/26/23.
//

import UIKit
import Then
import SnapKit

/// 하단에 글자수 label이 있는 textView
class LetterCountedTextView: UIView, UITextViewDelegate {
    
    private var textView: DefaultTextView?
    private let letterCountLabel = UILabel()
    private var placeholderString: String?
    
    /// - Parameters:
    ///   - placeholder: UITextView에 들어갈 placeholder
    init(
        placeholder: String?,
        textViewHeight: CGFloat = 74,
        maximumLetterCount: Int = 50
    ) {
        super.init(frame: .zero)
        
        textView = DefaultTextView(
            placeholder: placeholder,
            height: textViewHeight
        )
        
        // FIXME: delegate 함수 실행 X
//        textView?.delegate = self
        
        placeholderString = placeholder
        
        setupUI()
        setConstraints()
        bindText(maximumLetterCount: maximumLetterCount)
    }
    
    /// - Parameters:
    ///   - placeholder: UITextView에 들어갈 placeholder
    func xibInit(
        label text: String?,
        placeholder: String?,
        textViewHeight: CGFloat = 74,
        maximumLetterCount: Int = 50
    ) {
        textView = DefaultTextView(
            placeholder: placeholder,
            height: textViewHeight
        )
        
        placeholderString = placeholder
        
        setupUI()
        setConstraints()
        bindText(maximumLetterCount: maximumLetterCount)
    }
    
    private func setupUI() {
        guard let textView = textView else { return }
        
        [textView, letterCountLabel]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        guard let textView = textView else { return }
        
        textView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        letterCountLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(2)
            $0.trailing.equalToSuperview()
        }
        
    }
    
    
    private func bindText(maximumLetterCount: Int) {
        guard let textView = textView else { return }
        
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
        super.init(coder: coder)
    }
    
}
