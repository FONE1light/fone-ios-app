//
//  EmptyView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/23.
//

import UIKit

class EmptyView: UIView {
    
    init(height: CGFloat) {
        super.init(frame: .zero)
        
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
