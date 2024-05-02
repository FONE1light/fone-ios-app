//
//  BookmarkButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/24/23.
//

import UIKit

class BookmarkButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        setImage(UIImage(named: "bookmark_on_Interpace"), for: .selected)
        setImage(UIImage(named: "bookmark_off_Interpace"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setImage(UIImage(named: "bookmark_on_Interpace"), for: .selected)
        setImage(UIImage(named: "bookmark_off_Interpace"), for: .normal)
    }
    
    /// 토글 후 상태값 반환
    func toggle() -> Bool {
        isSelected = !isSelected
        return isSelected
    }
}
