//
//  DefaultButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/04.
//

import UIKit
import RxRelay

class DefaultButton: UIButton {
    
    /// 활성화된 상태인지 아닌지
    var isActivated = BehaviorRelay<Bool>(value: false)
}

extension DefaultButton {
    func activate() {
        isActivated.accept(true)
        
    }
    
    func deactivate() {
        isActivated.accept(false)
    }
}
