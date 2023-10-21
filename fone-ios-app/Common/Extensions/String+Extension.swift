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
}

extension String {
    func prefixString(_ max: Int) -> String {
        return String(self.prefix(max))
    }
    
    func substring(_ r: Range<Int>) -> String {
        guard self.count >= r.upperBound else {
            return self
        }
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }
    
}

extension String {
    func phoneNumberFormatted() -> String {
        guard self.count == 11 else { return self }
        
        let firstPart = self.substring(0..<3)
        let secondPart = self.substring(3..<7)
        let thirdPart = self.substring(7..<11)
        
        return firstPart + "-" + secondPart + "-" + thirdPart
    }
}
