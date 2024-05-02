//
//  HeartButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 1/30/24.
//

import UIKit

class HeartButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        setImage(UIImage(named: "heart_on"), for: .selected)
        setImage(UIImage(named: "heart_01_off"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setImage(UIImage(named: "heart_on"), for: .selected)
        setImage(UIImage(named: "heart_01_off"), for: .normal)
    }
    
    /// 토글 후 상태값 반환
    func toggle() -> Bool {
        isSelected = !isSelected
        return isSelected
    }
}
