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
}
