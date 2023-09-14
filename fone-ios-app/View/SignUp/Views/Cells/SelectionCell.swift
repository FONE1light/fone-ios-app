//
//  SelectionCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/25.
//

import UIKit
import RxSwift

extension SelectionCell {
    struct Constants {
        /// leading, trailing inset
        static let leadingInset: CGFloat = 20
        /// top, bottom inset
        static let topInset: CGFloat = 8
        /// `label`의 fontSize
        static let fontSize: CGFloat = 14
    }
}

class SelectionCell: UICollectionViewCell {
    
    static let identifier = "SelectionCell"
    var disposeBag = DisposeBag()
    
    var isChosen = false
    
    let label = UILabel().then {
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
        self.addSubview(label)
        self.cornerRadius = 16
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.topInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.leadingInset)
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
