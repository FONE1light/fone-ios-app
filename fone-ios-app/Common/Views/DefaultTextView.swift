//
//  DefaultTextView.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/18/23.
//

import UIKit
import SnapKit

class DefaultTextView: UITextView {

    private let placeholderString: String?
    
    init(placeholder: String? = nil, height: CGFloat, keyboardType: UIKeyboardType? = .default) {
        placeholderString = placeholder
        super.init(frame: .zero, textContainer: nil)
        delegate = self
        
        self.setUI()
        self.setContraints(height: height)
        
        if let keyboardType = keyboardType {
            self.keyboardType = keyboardType
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .gray_F8F8F8
        
        text = placeholderString ?? ""
        
        self.font = .font_r(16)
        self.textColor = .gray_9E9E9E
        self.cornerRadius = 5
    }
    
    private func setContraints(height: CGFloat) {
        textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }

}

extension DefaultTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetPlaceHolder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textViewSetPlaceHolder()
        }
    }
    
    func textViewSetPlaceHolder() {
        if text == placeholderString {
            text = ""
            textColor = .gray_161616
        } else if text == "" {
            text = placeholderString
            textColor = .gray_9E9E9E
        }
    }
}
