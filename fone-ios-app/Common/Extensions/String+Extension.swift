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
    
    func toast(positionType: ToastPositionType = .withNothing, completion: (() -> Void)? = nil) {
        ToastManager.show(self, positionType: positionType, completion: completion)
    }
}
