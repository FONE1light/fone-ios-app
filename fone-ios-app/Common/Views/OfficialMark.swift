//
//  OfficialMark.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/14.
//

import UIKit
import Then
import SnapKit

class OfficialMark: UIView {
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "mark")
    }
    
    init(size: CGFloat = 16) {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints(size: size)
    }
    
    private func setupUI() {
        addSubview(imageView)
    }
    
    private func setConstraints(size: CGFloat) {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(size)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
