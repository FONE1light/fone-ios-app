//
//  Int+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 1/31/24.
//

import Foundation

extension Int {
    func toDecimalFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        guard let stringInt = numberFormatter.string(for: self) else {
            return "\(self)"
        }
        
        return stringInt
    }
}
