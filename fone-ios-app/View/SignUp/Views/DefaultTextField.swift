//
//  DefaultTextField.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/15.
//

import UIKit
import SnapKit

class DefaultTextField: UITextField {

    init(placeHolder: String? = nil) {
        super.init(frame: .zero)
        self.setUI(placeHolder)
        self.setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(_ placeHolder: String?) {
        self.backgroundColor = .gray_F8F8F8
        self.placeholder = placeHolder
        self.font = .font_r(14)
//        self.lineHeight = 19 // TODO: lineHeight extension 추가
        self.textColor = .gray_9E9E9E
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
