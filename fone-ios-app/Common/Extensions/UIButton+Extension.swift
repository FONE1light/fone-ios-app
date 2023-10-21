//
//  UIButton+Extension.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/08.
//

import UIKit

extension UIButton {
    func setEnabled(isEnabled: Bool) {
        self.isEnabled = isEnabled
        if self.isEnabled {
            self.backgroundColor = UIColor.red_CE0B39
            self.applyShadow(shadowType: .shadowBt)
        } else {
            self.backgroundColor = UIColor.gray_C5C5C5
            self.applyShadow(shadowType: .shadowIt2)
        }
    }
    
    func setMediumButtonEnabled(isEnabled: Bool) {
        self.isEnabled = isEnabled
        let color: UIColor = isEnabled ? .red_F43663 : .gray_D9D9D9
        self.setTitleColor(color, for: .normal)
        self.borderColor = color
    }
}
