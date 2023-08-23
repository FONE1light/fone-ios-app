//
//  SelectionBlock.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/23.
//

import UIKit
import Then

class SelectionBlock: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .font_m(15)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
//    private let collectionView = UICollectionView().then {
//        $0.backgroundColor = .yellow
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 10
//
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//        $0.collectionViewLayout = layout
////        $0.register(<#T##LSHTTPClientHook#>)
//    }
    
    private let collectionView = UIView().then {
        $0.backgroundColor = .yellow
    }
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [titleLabel, subtitleLabel, collectionView]
            .forEach { self.addSubview($0) }
        
        self.backgroundColor = .gray_F8F8F8
        
    }
    
    private func setContraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(2)
            $0.bottom.equalTo(titleLabel)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(60) // TODO: 삭제
            $0.bottom.equalToSuperview()
        }
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setSubtitle(_ text: String) {
        subtitleLabel.text = text
    }
}
