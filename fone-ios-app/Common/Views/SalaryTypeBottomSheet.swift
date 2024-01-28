//
//  SalaryTypeBottomSheet.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 1/28/24.
//

import UIKit

class SalaryTypeBottomSheet: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib(SalaryTypeBottomSheet.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
