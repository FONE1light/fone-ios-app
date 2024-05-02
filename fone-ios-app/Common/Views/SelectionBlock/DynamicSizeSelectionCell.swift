//
//  DynamicSizeSelectionCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/27/23.
//

import UIKit
import RxSwift

extension DynamicSizeSelectionCell {
    struct Constants {
        /// `label`의 fontSize
        static let fontSize: CGFloat = 14
    }
}

/// 크기가 고정되지 않은 `UICollectionViewCell`
class DynamicSizeSelectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: DynamicSizeSelectionCell.self)
    var disposeBag = DisposeBag()
    
    override var isSelected: Bool {
        didSet {
            changeColor()
        }
    }
    
    var item: Selection? {
        didSet {
            label.text = item?.name
        }
    }
    
    private let label = UILabel().then {
        $0.font = .font_r(Constants.fontSize)
        $0.textColor = .gray_9E9E9E
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .gray_EEEFEF
        addSubview(label)
        cornerRadius = 16
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension DynamicSizeSelectionCell {
    func configure(_ selection: Selection) {
        item = selection
    }
    
    private func changeColor() {
        if isSelected {
            self.backgroundColor = .red_FFEBF0
            self.label.textColor = .red_CE0B39
            
        } else {
            self.backgroundColor = .gray_EEEFEF
            self.label.textColor = .gray_9E9E9E
        }
    }
    
}
