//
//  UIColor+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/10.
//

import Foundation
import UIKit

extension UIColor {
    /// RGB가 각각 `red`, `green`, `blue`이고 opacity는 `a`인 Color object 반환
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
}

extension UIColor {
    /// RGB가 `hex`, opacity는 1에 해당하는 Color object 반환
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xff,
            green: (hex >> 8) & 0xff,
            blue: hex & 0xff
        )
    }
}

extension UIColor {
    /// RGB(255, 255, 255)
    class var white_FFFFFF: UIColor { return UIColor(hex: 0xffffff) }
    /// RGB(0, 0, 0)
    class var black_000000: UIColor { return UIColor(hex: 0x000000) }
    
    // Gray
    class var gray_161616: UIColor { return UIColor(hex: 0x161616) }
    class var gray_555555: UIColor { return UIColor(hex: 0x555555) }
    class var gray_9E9E9E: UIColor { return UIColor(hex: 0x9E9E9E) }
    class var gray_C5C5C5: UIColor { return UIColor(hex: 0xC5C5C5) }
    class var gray_D9D9D9: UIColor { return UIColor(hex: 0xD9D9D9) }
    class var gray_EEEFEF: UIColor { return UIColor(hex: 0xEEEFEF) }
    class var gray_F8F8F8: UIColor { return UIColor(hex: 0xF8F8F8) }
    
    // MARK: - Primary color
    class var red_FFEBF0: UIColor { return UIColor(hex: 0xFFEBF0) }
    class var red_FDD1DB: UIColor { return UIColor(hex: 0xFDD1DB) }
    class var red_FAAABD: UIColor { return UIColor(hex: 0xFAAABD) }
    class var red_F8849F: UIColor { return UIColor(hex: 0xF8849F) }
    class var red_F43663: UIColor { return UIColor(hex: 0xF43663) }
    class var red_F21045: UIColor { return UIColor(hex: 0xF21045) }
    class var red_CE0B39: UIColor { return UIColor(hex: 0xCE0B39) }
    class var red_C0002C: UIColor { return UIColor(hex: 0xC0002C) }
    class var red_A7092E: UIColor { return UIColor(hex: 0xA7092E) }
    class var red_800724: UIColor { return UIColor(hex: 0x800724) }
    
    // MARK: - Secondary color
    // Violet
    class var violet_DCD7E8: UIColor { return UIColor(hex: 0xDCD7E8) }
    class var violet_C6BDD9: UIColor { return UIColor(hex: 0xC6BDD9) }
    class var violet_AFA3CA: UIColor { return UIColor(hex: 0xAFA3CA) }
    class var violet_9989BB: UIColor { return UIColor(hex: 0x9989BB) }
    class var violet_826FAC: UIColor { return UIColor(hex: 0x826FAC) }
    class var violet_6D5999: UIColor { return UIColor(hex: 0x6D5999) }
    class var violet_5B4A80: UIColor { return UIColor(hex: 0x5B4A80) }
    class var violet_483B66: UIColor { return UIColor(hex: 0x483B66) }
    class var violet_362C4C: UIColor { return UIColor(hex: 0x362C4C) }
    class var violet_241D32: UIColor { return UIColor(hex: 0x241D32) }
    
    // Beige
    class var beige_F9F1E6: UIColor { return UIColor(hex: 0xF9F1E6) }
    class var beige_F4E6D2: UIColor { return UIColor(hex: 0xF4E6D2) }
    class var beige_EFDBBD: UIColor { return UIColor(hex: 0xEFDBBD) }
    class var beige_E5C494: UIColor { return UIColor(hex: 0xE5C494) }
    class var beige_DBAD6C: UIColor { return UIColor(hex: 0xDBAD6C) }
    class var beige_D19643: UIColor { return UIColor(hex: 0xD19643) }
    class var beige_B47C2C: UIColor { return UIColor(hex: 0xB47C2C) }
    class var beige_8B6022: UIColor { return UIColor(hex: 0x8B6022) }
    class var beige_77521D: UIColor { return UIColor(hex: 0x77521D) }
    class var beige_624418: UIColor { return UIColor(hex: 0x624418) }
    
    // Red Crimson
    class var crimson_FFE7E4: UIColor { return UIColor(hex: 0xFFE7E4) }
    class var crimson_FFC4BB: UIColor { return UIColor(hex: 0xFFC4BB) }
    class var crimson_FFA093: UIColor { return UIColor(hex: 0xFFA093) }
    class var crimson_FF7C6A: UIColor { return UIColor(hex: 0xFF7C6A) }
    class var crimson_FF5841: UIColor { return UIColor(hex: 0xFF5841) }
    class var crimson_FF3418: UIColor { return UIColor(hex: 0xFF3418) }
    class var crimson_EE1D00: UIColor { return UIColor(hex: 0xEE1D00) }
    class var crimson_C61800: UIColor { return UIColor(hex: 0xC61800) }
    class var crimson_9D1300: UIColor { return UIColor(hex: 0x9D1300) }
    class var crimson_740E00: UIColor { return UIColor(hex: 0x740E00) }
}

extension UIColor {
    /// Opacity값이 `opacity`인 Color object 반환
    func alpha(_ opacity: CGFloat) -> UIColor {
        return self.withAlphaComponent(opacity)
    }
}
