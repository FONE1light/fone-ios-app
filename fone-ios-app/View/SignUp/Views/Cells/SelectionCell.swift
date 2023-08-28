//
//  SelectionCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/25.
//

import UIKit
import RxSwift

class SelectionCell: UICollectionViewCell {
    
    static let identifier = "SelectionCell"
    var disposeBag = DisposeBag()
    
    let label = UILabel().then {
        $0.font = .font_r(14)
        $0.textColor = .gray_9E9E9E
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        self.backgroundColor = .beige_624418
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(label)
        self.cornerRadius = 15 // TODO: 정확한 값 확인 후 수정
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
