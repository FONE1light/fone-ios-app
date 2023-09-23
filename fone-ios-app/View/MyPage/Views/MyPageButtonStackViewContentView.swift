//
//  MyPageButtonStackViewContentView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/17.
//

import UIKit
import SnapKit

enum MyPageButtonStackViewContentType {
    case scrap
    case save
    
    var imageName: String? {
        switch self {
        case .scrap: return "Bookmark"
        case .save: return "Heart_02"
        }
    }
    
    var labelText: String? {
        switch self {
        case .scrap: return "스크랩"
        case .save: return "찜"
        }
        
    }
}

class MyPageButtonStackViewContentView: UIView {

    let imageView = UIImageView()
    
    let label = UILabel().then {
        $0.font = .font_m(14)
        $0.textColor = .gray_555555
    }
    
    init(type: MyPageButtonStackViewContentType?) {
        super.init(frame: .zero)
        
        if let imageName = type?.imageName {
            imageView.image = UIImage(named: imageName)
        }
        
        label.text = type?.labelText
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        [imageView, label]
            .forEach { self.addSubview($0) }
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.top.leading.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
