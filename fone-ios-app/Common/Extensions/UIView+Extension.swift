//
//  UIView+Extension.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/10.
//

import UIKit

extension UIView {
    @IBInspectable var borderColor: UIColor {
        get {
            let color = self.layer.borderColor ?? UIColor.clear.cgColor
            return UIColor(cgColor: color)
        }
        
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

enum ShadowType {
    case shadowIt1
    case shadowIt2
    case shadowIt3
    case shadowIt4
    case shadowIt5
    case shadowIt6
    case shadowBt
    
    var shadowColor: CGColor {
        switch self {
        case .shadowBt: return UIColor(hex: 0xC0002C).cgColor
        default: return UIColor(hex: 0x0B0A1E).cgColor
        }
    }
    
    var shadowOpacity: Float {
        switch self {
        case .shadowIt1, .shadowIt3, .shadowIt4, .shadowBt: return 0.16
        case .shadowIt2: return 0.1
        case .shadowIt5: return 0.18
        case .shadowIt6: return 0.23
        }
    }
    
    var shadowOffset: CGSize {
        switch self {
        case .shadowIt1: return CGSize(width: 0, height: 1)
        case .shadowIt2: return CGSize(width: 0, height: 2)
        case .shadowIt3: return CGSize(width: 0, height: 3)
        case .shadowIt4, .shadowBt: return CGSize(width: 0, height: 4)
        case .shadowIt5: return CGSize(width: 0, height: 5)
        case .shadowIt6: return CGSize(width: 0, height: 6)
        }
    }
    
    var shadowBlur: CGFloat {
        switch self {
        case .shadowIt1: return 2
        case .shadowIt2: return 4
        case .shadowIt3: return 6
        case .shadowIt4, .shadowBt: return 8
        case .shadowIt5: return 12
        case .shadowIt6: return 15
        }
    }
}

extension UIView {
    func applyShadow(shadowType: ShadowType) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowType.shadowColor
        self.layer.shadowOpacity = shadowType.shadowOpacity
        self.layer.shadowOffset = shadowType.shadowOffset
        self.layer.shadowRadius = shadowType.shadowBlur / 2.0
    }
    
    func setTextFieldErrorBorder(showError: Bool) {
        if showError {
            self.borderWidth = 1
            self.borderColor = .crimson_FF5841
        } else {
            self.borderWidth = 0
        }
    }
}

extension UIView {
    /// 디바이스 상단의 노치 여백 반환
    static var notchTop: CGFloat {
        return UIApplication
            .keyWindow?
            .windowScene?
            .statusBarManager?
            .statusBarFrame.size.height ?? 0
    }
}
