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
    
    var isChosen = false
    
    let label = UILabel().then {
        $0.font = .font_r(14)
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
        self.addSubview(label)
        self.cornerRadius = 15 // TODO: 정확한 값 확인 후 수정
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

extension SelectionCell {
    func changeSelectedState() {
        changeColor()
        isChosen = !isChosen
    }
    
    private func changeColor() {
        if isChosen {
            self.backgroundColor = .gray_EEEFEF
            self.label.textColor = .gray_9E9E9E
        } else {
            self.backgroundColor = .red_FFEBF0
            self.label.textColor = .red_CE0B39
        }
    }
    
    static func fittingSize(height: CGFloat, name: String?) -> CGSize {
        let cell = SelectionCell().then {
            $0.label.text = name
        }
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
}
