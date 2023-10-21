//
//  String+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/17.
//

import Foundation

extension String {
    var url: URL? {
        get {
            return URL(string: self)
        }
    }
    
    func toast(positionType: ToastPositionType = .withNothing, isKeyboardShowing: Bool = false, completion: (() -> Void)? = nil) {
        ToastManager.show(self, positionType: positionType, isKeyboardShowing: isKeyboardShowing, completion: completion)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    // 입력은 '-' 없이 받지만 서버에는 '-' 포함인 형태로 보내야함
    func insertDash() -> String? {
        guard self.count == 11 else { return nil }
        
        var phoneNumberWithDash = self
        let index1 = phoneNumberWithDash.index(phoneNumberWithDash.startIndex, offsetBy: 3)
        let index2 = phoneNumberWithDash.index(phoneNumberWithDash.startIndex, offsetBy: 7)
        phoneNumberWithDash.insert("-", at: index2)
        phoneNumberWithDash.insert("-", at: index1)
        
        return phoneNumberWithDash
    }
}
