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

/// `label`의 inset이 고정된 `UICollectionViewCell`
class SelectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: SelectionCell.self)
    var disposeBag = DisposeBag()
    
    var isChosen = false {
        didSet {
            setColor()
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
        self.addSubview(label)
        self.cornerRadius = 16
        self.backgroundColor = .gray_EEEFEF
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.topInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.leadingInset)
        }
    }
}

extension SelectionCell {
    func setItem(_ selection: Selection) {
        item = selection
    }
    
    /// 선택 상태(isChosen) 변경
    func toggle() {
        isChosen = !isChosen
    }
    
    private func setColor() {
        if isChosen {
            self.backgroundColor = .red_FFEBF0
            self.label.textColor = .red_CE0B39
        } else {
            self.backgroundColor = .gray_EEEFEF
            self.label.textColor = .gray_9E9E9E
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
