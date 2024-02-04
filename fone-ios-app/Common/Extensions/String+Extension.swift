//
//  String+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/17.
//

import UIKit

extension String {
    var url: URL? {
        get {
            return URL(string: self)
        }
    }
    
    /** 숫자형 문자열에 3자리수 마다 콤마 넣기 */
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        if let price: Int = Int(self) {
            return numberFormatter.string(from: NSNumber(value: price)) ?? self
        }
        return self
    }
    
    var weekDay: String {
        switch self {
        case "MON":
            return "월"
        case "TUE":
            return "화"
        case "WED":
            return "수"
        case "THU":
            return "목"
        case "FRI":
            return "금"
        case "SAT":
            return "토"
        case "SUN":
            return "일"
        default:
            return ""
        }
    }
    
    var dateServerFormat: String? {
        var result = String(self.dropLast(3))
        result = result.replacingOccurrences(of: ".", with: "-")
        return result
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
    
    /// 생년월일을 형식에 맞게 수정하여 반환
    /// - 마지막은 숫자(유저가 직접 dash를 지우는 일이 없도록 함)
    /// - 4글자, 6글자 초과 시 dash 추가
    /// - 8글자까지 입력 가능
    func birthFormatted() -> String {
        if self.last == "-" {
            return String(self.prefix(self.count - 1))
        }
        
        var birthNumbers = self.replacingOccurrences(of: "-", with: "")
        birthNumbers = String(birthNumbers.prefix(8))
        
        var newBirthString = birthNumbers
        
        if birthNumbers.count > 6 {
            newBirthString.insert("-", at: newBirthString.index(newBirthString.startIndex, offsetBy: 6))
        }
        
        if birthNumbers.count > 4 {
            newBirthString.insert("-", at: newBirthString.index(newBirthString.startIndex, offsetBy: 4))
        }
        
        return newBirthString
    }
    
    /// 생년월일 문자열에서 연도를 반환.
    ///
    /// e.g. `separator`가 "-"라면, "2023-01-01"에서 "2023"을 반환
    func birthYear(separator: String) -> String? {
        let characterSet = CharacterSet(charactersIn: separator)
        return components(separatedBy: characterSet).first
    }
}

extension String {
    var isSuccess: Bool {
        self == "SUCCESS"
    }
}

extension NSMutableAttributedString {
    @discardableResult func setAttributeText(_ text: String, _ font : UIFont, _ color: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor : color]
        let string = NSMutableAttributedString(string:text, attributes: attributes)
        append(string)
        
        return self
    }
}
