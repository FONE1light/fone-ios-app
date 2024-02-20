//
//  DefaultTextField.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/15.
//

import UIKit
import SnapKit

class DefaultTextField: UITextField {

    private var height: CGFloat = 40
    
    init(
        placeholder: String? = nil,
        height: CGFloat = 40,
        keyboardType: UIKeyboardType? = .default
    ) {
        self.height = height
        super.init(frame: .zero)
        self.setUI(placeholder)
        self.setContraints(height: height)
        
        if let keyboardType = keyboardType {
            self.keyboardType = keyboardType
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func xibInit(
        placeholder: String? = nil,
        height: CGFloat = 40,
        keyboardType: UIKeyboardType? = .default
    ) {
        self.height = height
        self.setUI(placeholder)
        self.setContraints(height: height)
        
        if let keyboardType = keyboardType {
            self.keyboardType = keyboardType
        }
    }
    
    private func setUI(_ placeholder: String?) {
        self.backgroundColor = .gray_F8F8F8
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: UIColor.gray_9E9E9E])
    
        self.font = .font_r(14)
//        self.lineHeight = 19 // TODO: lineHeight extension 추가
        self.textColor = .gray_161616
        
        self.cornerRadius = 5
    }
    
    private func setContraints(height: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func setTrailingPadding(_ offset: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: offset, height: height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setLeadingPadding(_ offset: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: offset, height: height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setTextAlignment(_ alignment: NSTextAlignment) {
        textAlignment = alignment
    }

}
