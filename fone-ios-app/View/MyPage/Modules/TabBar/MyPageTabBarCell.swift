//
//  MyPageTabBarCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit
import Then
import SnapKit

class MyPageTabBarCell: UICollectionViewCell {
    
    static let identifier = String(describing: MyPageTabBarCell.self)
    
    private let label = UILabel().then {
        $0.font = .font_r(14)
        $0.textColor = .gray_9E9E9E
    }
    
    private let underline = UIView()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.textColor = .red_CE0B39
                label.font = .font_m(14)
                underline.backgroundColor = .red_CE0B39
            } else {
                label.textColor = .gray_9E9E9E
                underline.backgroundColor = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        [label, underline]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        underline.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(MyPageTabBarCollectionView.Constants.selectedUnderlineHeight)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?) {
        label.text = title
    }
}



