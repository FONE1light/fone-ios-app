//
//  DefaultTextField.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/15.
//

import UIKit
import SnapKit

class DefaultTextField: UITextField {

    init(placeholder: String? = nil, keyboardType: UIKeyboardType? = .default) {
        super.init(frame: .zero)
        self.setUI(placeholder)
        self.setContraints()
        
        if let keyboardType = keyboardType {
            self.keyboardType = keyboardType
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setContraints() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }

}
